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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_ip is
    Port ( i_rx : in STD_LOGIC;
           i_ck : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_data_seen : in STD_LOGIC;
           o_data_ready : out STD_LOGIC;
           o_data_out : out STD_LOGIC_VECTOR (7 downto 0));
end uart_ip;

architecture Behavioral of uart_ip is

begin


end Behavioral;
