----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.06.2022 15:51:38
-- Design Name: 
-- Module Name: uart_ip - Behavioral
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
-- arithmetic functions with Signed or Unsigned values
use IEEE.numeric_std.all;
use xil_defaultlib.uart_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity uart_ip is
    Port ( i_rx : in std_logic;
           i_ck : in std_logic;
           i_rst : in std_logic;
           i_data_seen : in std_logic;
           o_data_ready : out std_logic;
           o_data_out : out std_logic_vector (out_len - 1 downto 0)
    );
end uart_ip;


architecture Behavioral of uart_ip is

    signal w_next_state: states;
    signal r_present_state: states;
    signal r_count_half_bit: integer;
    signal r_count_clock_cycles: integer;

begin

    compute_next_state: process(i_rst, r_present_state, i_rx, r_count_half_bit, i_data_seen)
    begin

        if i_rst = '0' then
            w_next_state <= idle;
        else
            case r_present_state is
            when idle =>
                if i_rx = '1' then
                    w_next_state <= idle;
                else
                    w_next_state <= count_cycles;
                end if;
            when count_cycles =>
                if r_count_half_bit <= 20 then
                    w_next_state <= count_cycles;
                else
                    if i_rx = '1' then
                        w_next_state <= wait_data_seen;
                    else
                        w_next_state <= idle;
                    end if;
                end if;
            when wait_data_seen =>
                if i_data_seen = '1' then
                    w_next_state <= idle;
                else
                    w_next_state <= wait_data_seen;
                end if;
            when others =>
                w_next_state <= idle;
            end case;
        end if;

    end process compute_next_state;


    state_reg: process(i_ck, i_rst)
    begin

        if i_rst = '1' then
            r_present_state <= idle;
        elsif rising_edge(i_ck) then
            r_present_state <= w_next_state;
        end if;

    end process state_reg;


    perform_operations: process(i_ck, i_rst)
    begin

        if i_rst = '1' then
            r_count_half_bit <= 0;
            r_count_clock_cycles <= 0;
            o_data_ready <= '0';
        elsif rising_edge(i_ck) then
            case r_present_state is
            when idle =>
                r_count_half_bit <= 0;
                r_count_clock_cycles <= 0;
                o_data_ready <= '0';
                if i_rx = '0' then
                    r_count_clock_cycles <= r_count_clock_cycles + 1;
                end if;
            when count_cycles =>
                r_count_clock_cycles <= r_count_clock_cycles + 1;
                if r_count_half_bit <= 20 then
                    if i_rx = '1' then
                        o_data_ready <= '1';
                    end if;
                else
                    if r_count_clock_cycles mod 2*bit_duration = 3*bit_duration then
                        o_data_out((r_count_clock_cycles - 3*bit_duration)/2) <= i_rx;
                        r_count_half_bit <= r_count_half_bit + 1;
                    end if;
                end if;
            when wait_data_seen =>
                if i_data_seen = '1' then
                    o_data_ready <= '0';
                end if;
            when others =>
                r_count_half_bit <= 0;
                r_count_clock_cycles <= 0;
                o_data_ready <= '0';
            end case;
        end if;

    end process perform_operations;


end Behavioral;
