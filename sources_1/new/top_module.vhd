----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.06.2022 16:14
-- Design Name: 
-- Module Name: top_module - Behavioral
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



entity top_module is
    port(
        i_clock: in std_logic;
        i_reset: in std_logic;
        i_receive: in std_logic;
        o_data_leds: out std_logic_vector (out_len - 1 downto 0)
    );
end top_module;


architecture Behavioral of top_module is

    component uart_rx_2_ip
        port ( 
            i_rx : in std_logic;
            i_ck : in std_logic;
            i_rst : in std_logic;
            i_data_seen : in std_logic;
            o_data_ready : out std_logic;
            o_data_out : out std_logic_vector (out_len - 1 downto 0)
        );
    end component;

    component interf_ip
        port (
            i_ck: in std_logic;
            i_rst: in std_logic;
            i_data_ready: in std_logic;
            i_data: in std_logic_vector (out_len - 1 downto 0);
            o_data_seen: out std_logic;
            o_leds: out std_logic_vector (out_len - 1 downto 0)
        );
    end component;

    component ckdiv_ip
        port (
            i_ckin : in std_logic;
            i_rst : in std_logic;
            o_ckout : out std_logic
        );
    end component;

    signal scaled_ck: std_logic;
    signal data_ready: std_logic;
    signal data_seen: std_logic;
    signal data: std_logic_vector (out_len - 1 downto 0);

begin

    uart: uart_rx_2_ip
    port map (
        i_ck => scaled_ck,
        i_rst => i_reset,
        i_rx => i_receive,
        i_data_seen => data_seen,
        o_data_ready => data_ready,
        o_data_out => data
    );


    interf: interf_ip
    port map (
        i_ck => scaled_ck,
        i_rst => i_reset,
        i_data_ready => data_ready, 
        i_data => data,
        o_data_seen => data_seen,
        o_leds => o_data_leds
    );


    ckvdiv: ckdiv_ip
    port map (
        i_ckin => i_clock,
        i_rst => i_reset,
        o_ckout => scaled_ck
    );

end Behavioral;