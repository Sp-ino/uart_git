----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.06.2022 15:51:38
-- Design Name: 
-- Module Name: uart_rx_2_ip - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Another version of synthesizable UART RX module
--              that's more readable. It should be also more efficient
--              resource-wise.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
library xil_defaultlib;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use xil_defaultlib.uart_pkg.all;



entity uart_rx_2_ip is
    port ( 
        i_ck : in std_logic;
        i_rx : in std_logic;
        i_rst : in std_logic;
        i_data_seen : in std_logic;
        o_data_ready : out std_logic;
        o_data_out : out std_logic_vector (out_len - 1 downto 0)
    );
end uart_rx_2_ip;


architecture Behavioral of uart_rx_2_ip is

    -- The elementary time unit is the clock cycle (that lasts tck seconds). 
    -- A data bit lasts an amount of time which is equal to bit_duration*tck.

    signal w_next_state, r_present_state: uart_states_2;
    signal r_count_bits: integer; -- r_count_bits counts how many data bits we've seen until now
    signal r_count_clock_cycles: integer; -- r_count_clock_cycles counts how many clock cycles have passed from the beginngin of the frame
    constant initial_wait: integer := 3*bit_duration/2; -- N. of clock cycles to wait before we start sampling after a start bit is detected.

begin

    -- Combinational process for computing next_state
    compute_next_state: process(all)
    begin

        if i_rst = '1' then
            w_next_state <= idle;
        else
            case r_present_state is
            when idle =>
                if i_rx = '0' then -- stay in idle until we detect a start bit
                    w_next_state <= wait_initial_time;
                else
                    w_next_state <= idle;
                end if;
            when wait_initial_time =>
                if r_count_clock_cycles < initial_wait then
                    w_next_state <= wait_initial_time;
                else
                    w_next_state <= count_cycles;
                end if;
            when count_cycles =>
                if r_count_bits <= frame_len then -- Remain in count_cycles until we have sampled all the 8 bit
                    w_next_state <= count_cycles;
                else
                    if i_rx = '0' then
                        w_next_state <= idle; -- If we do not receive a stop bit, consider the frame invalid and jump to idle
                    else
                        w_next_state <= wait_data_seen; -- otherwise go to wait_data_seen
                    end if;
                end if;
            when wait_data_seen =>
                if i_data_seen = '0' then -- Wait until someone asserts data_seen
                    w_next_state <= wait_data_seen;
                else
                    w_next_state <= idle;
                end if;
           when others =>
               w_next_state <= idle;
            end case;
        end if;

    end process compute_next_state;


    -- Synchrounous process that implements the state register
    state_reg: process(i_ck, i_rst)
    begin

        if i_rst = '1' then
            r_present_state <= idle;
        elsif rising_edge(i_ck) then
            r_present_state <= w_next_state;
        end if;

    end process state_reg;


    -- Synchronous process that performs operations associated to each state
    perform_operations: process(i_ck, i_rst)
    begin

        if i_rst = '1' then
            r_count_bits <= 0;
            r_count_clock_cycles <= 1;
            o_data_ready <= '0';
            o_data_out <= (others => '0');
        elsif rising_edge(i_ck) then
            case r_present_state is
            when idle =>
                r_count_bits <= 0;
                r_count_clock_cycles <= 1;
                o_data_ready <= '0';
            when wait_initial_time =>
                if r_count_clock_cycles < initial_wait then
                    r_count_clock_cycles <= r_count_clock_cycles + 1;
                else
                    r_count_bits <= r_count_bits + 1;
                    r_count_clock_cycles <= 1;
                    o_data_out(r_count_bits) <= i_rx;
                end if;
            when count_cycles =>
                if r_count_bits <= frame_len then -- If the frame is not over check on r_count_clock_cycles
                    if r_count_clock_cycles < bit_duration then -- If bit_duration cycles haven't passed yet, increment r_count_clock_cycles
                        r_count_clock_cycles <= r_count_clock_cycles + 1;
                    else                                        -- Otherwise reset r_count_clock_cycles and increment r_count_bits
                        r_count_bits <= r_count_bits + 1;
                        r_count_clock_cycles <= 1;
                        if r_count_bits <= frame_len - 1 then    -- If we haven't reached the stop bit, sample i_rx on the output 
                            o_data_out(r_count_bits) <= i_rx;
                        end if;
                    end if;
                else
                    if i_rx = '1' then      -- If i_rx is high after the 8 data bits, the frame is valid and we assert o_data_ready
                        o_data_ready <= '1';
                    end if;
                end if;
            when wait_data_seen =>
                if i_data_seen = '1' then
                    o_data_ready <= '0';
                end if;
            when others =>
                r_count_bits <= 0;
                r_count_clock_cycles <= 1;
                o_data_ready <= '0';
                o_data_out <= (others => '0');
            end case;
        end if;

    end process perform_operations;

end Behavioral;
