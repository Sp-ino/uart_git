----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.06.2022 11:57
-- Design Name: 
-- Module Name: interf_ip - Behavioral
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
use xil_defaultlib.uart_pkg.all;




entity interf_ip is
    port(
        i_ck: in std_logic;
        i_rst: in std_logic;
        i_data_ready: in std_logic;
        i_data: in std_logic_vector (out_len - 1 downto 0);
        o_data_seen: out std_logic;
        o_data: out std_logic_vector (out_len - 1 downto 0)
    );
end interf_ip;


architecture Behavioral of interf_ip is

    signal count: integer;
    constant max_count: integer := 5; 

begin

    update_output: process (i_ck, i_rst)
    begin

        if i_rst = '1' then
            o_data <= (others => '0');
            count <= 0;
        elsif rising_edge(i_ck) then
            if i_data_ready = '1' and count = 0 then
                o_data <= i_data;
                o_data_seen <= '1';
                count <= count + 1;
            elsif count > 0 and count < max_count then
                count <= count + 1;
            elsif count = max_count then
                count <= 0;
            end if;
        end if;
        
    end process update_output;

end Behavioral;