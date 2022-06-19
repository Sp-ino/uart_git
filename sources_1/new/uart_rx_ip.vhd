----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.06.2022 15:51:38
-- Design Name: 
-- Module Name: uart_rx_ip - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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



entity uart_rx_ip is
    port ( i_rx : in std_logic;
           i_ck : in std_logic;
           i_rst : in std_logic;
           i_data_seen : in std_logic;
           o_data_ready : out std_logic;
           o_data_out : out std_logic_vector (out_len - 1 downto 0)
    );
end uart_rx_ip;


architecture Behavioral of uart_rx_ip is

    -- The elementary time unit is the clock cycle (that lasts tck seconds). 
    -- A data bit lasts an amount of time which is equal to bit_duration*tck.

    signal w_next_state, r_present_state: states;
    signal r_count_bits: integer; -- r_count_bits counts how many data bits we've seen until now
    signal r_count_clock_cycles: integer; -- r_count_clock counts how many clock cycles have passed from the beginngin of the frame
    constant initial_wait: integer := 3*bit_duration/2; -- N. of clock cycles to wait before we start sampling after a start bit is detected.

begin

    -- Combinational process for computing next_state
    compute_next_state: process(i_rst, r_present_state, i_rx, r_count_bits, i_data_seen)
    begin

        if i_rst = '1' then
            w_next_state <= idle;
        else
            case r_present_state is
            when idle =>
                if i_rx = '0' then -- stay in idle until we detect a start bit
                    w_next_state <= count_cycles;
                else
                    w_next_state <= idle;
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
            when count_cycles =>
                r_count_clock_cycles <= r_count_clock_cycles + 1; -- Increment r_count_clock_cycles
                if r_count_bits <= frame_len then -- If the frame is not over check on r_count_clock_cycles
                -- If the initial wait time is over and r_count_clock_cycles - initial_wait is an integer multiple of bit_duration
                -- then increment r_count_bits and, if r_count_bits < frame_len, sample the input
                    if r_count_clock_cycles >= initial_wait and (r_count_clock_cycles - initial_wait) rem bit_duration = 0 then
                        if r_count_bits < frame_len then
                            o_data_out(r_count_bits) <= i_rx;
                        end if;
                        r_count_bits <= r_count_bits + 1;
                    end if;
                else
                    if i_rx = '1' then
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
            end case;
        end if;

    end process perform_operations;

end Behavioral;
