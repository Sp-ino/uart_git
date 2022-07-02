----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.07.2022 18:03:02
-- Design Name: 
-- Module Name: ckdiv_ip - Behavioral
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ckdiv_ip is
    Port ( 
        i_ckin : in std_logic;
        i_rst : in std_logic;
        o_ckout : out std_logic
    );
end ckdiv_ip;


architecture Behavioral of ckdiv_ip is

    constant out_bit: integer := 3;
    signal r_internal_count: std_logic_vector (3 downto 0);

begin

    o_ckout <= r_internal_count(out_bit);

    counter: process(i_ckin, i_rst)
    begin

        if i_rst = '1' then
            r_internal_count <= (others => '0');
        elsif rising_edge(i_ckin) then
            r_internal_count <= std_logic_vector(unsigned(r_internal_count) + 1);
        end if;

    end process counter;

end Behavioral;
