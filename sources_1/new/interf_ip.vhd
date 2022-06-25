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
        o_data: in std_logic_vector (out_len - 1 downto 0);
    );
end interf_ip;


architecture Behavioral of interf_ip is
begin
    

end Behavioral;