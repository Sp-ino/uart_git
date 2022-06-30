----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.06.2022 19:58:21
-- Design Name: 
-- Module Name: uart_tb - Behavioral
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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tb is
--  Port ( );
end uart_tb;

architecture Behavioral of uart_tb is

    component uart_rx_ip
        port ( 
            i_ck : in std_logic;
            i_rx : in std_logic;
            i_rst : in std_logic;
            i_data_seen : in std_logic;
            o_data_ready : out std_logic;
            o_data_out : out std_logic_vector (out_len - 1 downto 0)
        );
    end component;
    
    signal ck: std_logic;
    signal rst: std_logic;
    signal rx: std_logic;
    signal data_seen: std_logic;
    signal data_ready: std_logic;
    signal data_out: std_logic_vector (out_len - 1 downto 0);
    constant tck: time := 10 ns;

begin
    
    uart_rx: uart_rx_ip
    port map (
        i_rx => rx,
        i_ck => ck,
        i_rst => rst,
        i_data_seen => data_seen,
        o_data_ready => data_ready,
        o_data_out => data_out
    );


    clock_gen: process
    begin

        ck <= '1';
        wait for tck/2;
        ck <= '0';
        wait for tck/2;

    end process clock_gen;


    generate_test_sig: process
    begin

        rx <= '1';
        rst <= '1';
        wait for 3*tck/2;
        rst <= '0';

        -- send start bit
        wait for 2*tck; 
        rx <= '0';

        -- then send a "01010011" (83)
        wait for bit_duration*tck;
        rx <= '1';
        wait for bit_duration*tck;
        rx <= '1';
        wait for bit_duration*tck;
        rx <= '0';
        wait for bit_duration*tck;
        rx <= '0';
        wait for bit_duration*tck;
        rx <= '1';
        wait for bit_duration*tck;
        rx <= '0';
        wait for bit_duration*tck;
        rx <= '1';
        wait for bit_duration*tck;
        rx <= '0';

        -- send stop bit
        wait for bit_duration*tck;
        rx <= '1';

        -- send a new start bit
        wait for bit_duration*tck; 
        rx <= '0';

        -- then send a "10011010" (154)
        wait for bit_duration*tck;
        rx <= '0';
        wait for bit_duration*tck;
        rx <= '1';
        wait for bit_duration*tck;
        rx <= '0';
        wait for bit_duration*tck;
        rx <= '1';
        wait for bit_duration*tck;
        rx <= '1';
        wait for bit_duration*tck;
        rx <= '0';
        wait for bit_duration*tck;
        rx <= '0';
        wait for bit_duration*tck;
        rx <= '1';

        -- send stop bit
        wait for bit_duration*tck;
        rx <= '1';
        
        -- send a new start bit
        wait for bit_duration*tck; 
        rx <= '0';

        -- then send a "00001010" (10)
        wait for bit_duration*tck;
        rx <= '0';
        wait for bit_duration*tck;
        rx <= '1';
        wait for bit_duration*tck;
        rx <= '0';
        wait for bit_duration*tck;
        rx <= '1';
        wait for bit_duration*tck;
        rx <= '0';
        wait for bit_duration*tck;
        rx <= '0';
        wait for bit_duration*tck;
        rx <= '0';
        wait for bit_duration*tck;
        rx <= '0';

        -- send stop bit
        wait for bit_duration*tck;
        rx <= '1';
        
        wait for bit_duration*tck;

    end process generate_test_sig;


    assert_data_seen: process
    begin
    
        -- wait until data is ready to be read from output port of receiver
        -- then assert data_seen
        data_seen <= '0';
        wait until data_ready = '1';
        wait for 3*tck/2;
        data_seen <= '1';
        wait for tck;
        data_seen <= '0';

    end process assert_data_seen;

end Behavioral;
