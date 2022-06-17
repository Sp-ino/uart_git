library IEEE;
use IEEE.std_logic_1164.all;


package uart_pkg is

    constant out_len: integer := 8;
    constant bit_duration: integer := 32;
    type states is (idle, count_cycles, wait_data_seen);

end uart_pkg;