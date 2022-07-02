library IEEE;
use IEEE.std_logic_1164.all;


package uart_pkg is

    constant out_len: integer := 8; -- length of an output word
    constant frame_len: integer := 8; -- number of data bits in a frame
    constant clock_frequ: integer := 100e6;
    constant clock_scaling_factor: integer := 16;
    constant baud_rate: integer := 38400; -- baud rate of the UART module
    constant bit_duration: integer := clock_frequ/(baud_rate*clock_scaling_factor); -- duration of a data bit in clock cycles
    type states is (idle, count_cycles, wait_data_seen);

end uart_pkg;