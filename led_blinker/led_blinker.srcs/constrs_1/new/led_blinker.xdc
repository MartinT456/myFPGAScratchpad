
## Clock signal 12 MHz
set_property -dict { PACKAGE_PIN L17   IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk_pin -period 83.33 -waveform {0 41.66} [get_ports {clk}];

set_property -dict { PACKAGE_PIN A17   IOSTANDARD LVCMOS33 } [get_ports { leds[0] }]; #leds[0] to LED 1 (pin A17)
set_property -dict { PACKAGE_PIN C16   IOSTANDARD LVCMOS33 } [get_ports { leds[1] }]; #leds[1] to LED 2 (pin C16)

set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports { reset }]; #Assign reset to button 0