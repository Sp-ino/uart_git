# W5 is the clock pin 
set_property PACKAGE_PIN W5 [get_ports i_clock]
set_property IOSTANDARD LVCMOS33 [get_ports i_clock]

# for the reset I use one of pins that are connected to pushbuttons
set_property PACKAGE_PIN W19 [get_ports i_reset]    
set_property IOSTANDARD LVCMOS33 [get_ports i_reset]

# In this constraint set we map the rx port to one of the pins
# in the PMOD ports because we want to use an external FTDI module.
# Specifically, we choos pin G2, corresponding to JA4 in the JA port.
set_property PACKAGE_PIN G2 [get_ports i_receive]
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