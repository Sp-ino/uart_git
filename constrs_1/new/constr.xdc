# the -name is useful if I need to refer to 
# this clock in another statement
create_clock -name master_ck -period 10.00 [get_ports i_clock]
create_generated_clock -name ckdiv16 -source [get_ports i_clock] -divide_by 16

# W5 is the clock pin 
set_property PACKAGE_PIN W5 [get_ports i_clock]
set_property IOSTANDARD LVCMOS33 [get_ports i_clock]

# for the reset I use one of pins that are connected to pushbuttons
set_property PACKAGE_PIN W19 [get_ports i_reset]    
set_property IOSTANDARD LVCMOS33 [get_ports i_reset]

# B18 the fpga pin that is connected to TXD of the FT2232 module
# therefore we choose it as the RX pin
set_property PACKAGE_PIN B18 [get_ports i_receive]
set_property IOSTANDARD LVCMOS33 [get_ports i_receive]

# output pins of the interface module are mapped to LED pins
set_property PACKAGE_PIN U16 [get_ports o_data_leds[0]]
set_property PACKAGE_PIN E19 [get_ports o_data_leds[1]]
set_property PACKAGE_PIN U19 [get_ports o_data_leds[2]]
set_property PACKAGE_PIN V19 [get_ports o_data_leds[3]]
set_property PACKAGE_PIN W18 [get_ports o_data_leds[4]]
set_property PACKAGE_PIN U15 [get_ports o_data_leds[5]]
set_property PACKAGE_PIN U14 [get_ports o_data_leds[6]]
set_property PACKAGE_PIN V14 [get_ports o_data_leds[7]]
set_property IOSTANDARD LVCMOS33 [get_ports o_data_leds[0]]
set_property IOSTANDARD LVCMOS33 [get_ports o_data_leds[1]]
set_property IOSTANDARD LVCMOS33 [get_ports o_data_leds[2]]
set_property IOSTANDARD LVCMOS33 [get_ports o_data_leds[3]]
set_property IOSTANDARD LVCMOS33 [get_ports o_data_leds[4]]
set_property IOSTANDARD LVCMOS33 [get_ports o_data_leds[5]]
set_property IOSTANDARD LVCMOS33 [get_ports o_data_leds[6]]
set_property IOSTANDARD LVCMOS33 [get_ports o_data_leds[7]]

# set this option so the synthesizer doesn't complain
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design] 