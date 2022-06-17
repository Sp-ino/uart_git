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
    signal r_count_half: integer;
    signal r_count_cy: integer;

begin

    compute_next_state: process(all)
    begin

        if rst = '0' then
            w_next_state <= idle;
        else
            case r_present_state is
            when idle =>
                if i_rx = '1' then
                    w_next_state <= idle;
                else
                    w_next_state <= count_cycles;
            when
                if count_half <= 20 then
                    if r_count_cy = 3*bit_duration mod 2*bit_duration; 
            end case;
        end if;

    end compute_next_state;


end Behavioral;
