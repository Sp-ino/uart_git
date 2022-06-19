library IEEE;
use IEEE.std_logic_1164.all;


package uart_pkg is

    constant out_len: integer := 8; -- length of an output word
    constant bit_duration: integer := 8; -- duration of a data bit in clock cycles
    constant frame_len: integer := 8; -- number of data bits in a frame
    type states is (idle, count_cycles, wait_data_seen);

end uart_pkg;