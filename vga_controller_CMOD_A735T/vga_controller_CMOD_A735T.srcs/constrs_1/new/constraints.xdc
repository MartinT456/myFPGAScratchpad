# Clock signal 12 MHz
set_property -dict { PACKAGE_PIN L17   IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk_pin -period 83.33 -waveform {0 41.66} [get_ports {clk}];


## LEDs
set_property -dict { PACKAGE_PIN A17   IOSTANDARD LVCMOS33 } [get_ports { leds[0] }]; 
set_property -dict { PACKAGE_PIN C16   IOSTANDARD LVCMOS33 } [get_ports { leds[1] }];

#set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVCMOS33 } [get_ports { led_b }]; 
#set_property -dict { PACKAGE_PIN B16   IOSTANDARD LVCMOS33 } [get_ports { led_g }]; 
#set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports { led_r }]; 


# Buttons
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports { reset }]; 
#set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports { btn_1 }]; 

## UART
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { tx }]; 
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { rx }]; 
