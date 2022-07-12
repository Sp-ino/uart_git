# the -name is useful if I need to refer to 
# this clock in another statement
create_clock -name master_ck -period 10.00 [get_ports i_clock]
create_generated_clock -name ckdiv16 -source [get_ports i_clock] -divide_by 16 [get_pins {ckvdiv/r_internal_count_reg[3]/Q}]
# create_generated_clock -name {ckvdiv/Q[0]} -source [get_ports i_clock] -divide_by 16 [get_pins {ckvdiv/r_internal_count_reg[3]/Q}]
# create_generated_clock -name ckdiv16 -source [get_ports i_clock] -divide_by 16 [get_pins ckdiv/Q[0]]