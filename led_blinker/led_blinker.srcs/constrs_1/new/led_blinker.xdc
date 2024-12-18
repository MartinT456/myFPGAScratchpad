
## Clock pin
set_property PACKAGE_PIN L17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

set_property PACKAGE_PIN C16 [get_ports leds[0]] ## leds[0] to built-in board LED pin C16
set_property PACKAGE_PIN A17 [get_ports leds[1]] ## leds[1] to built-in board LED pin A17
set_property IOSTANDARD LVCMOS33 [get_ports leds]

set_property PACKAGE_PIN A18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]