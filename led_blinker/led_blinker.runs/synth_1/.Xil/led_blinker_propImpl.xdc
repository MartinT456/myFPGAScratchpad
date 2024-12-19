set_property SRC_FILE_INFO {cfile:{F:/FPGA Projects/led_blinker/led_blinker.srcs/constrs_1/new/led_blinker.xdc} rfile:../../../led_blinker.srcs/constrs_1/new/led_blinker.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:3 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN L17   IOSTANDARD LVCMOS33 } [get_ports { clk }];
set_property src_info {type:XDC file:1 line:6 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN A17   IOSTANDARD LVCMOS33 } [get_ports { leds[0] }]; #leds[0] to LED 1 (pin A17)
set_property src_info {type:XDC file:1 line:7 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN C16   IOSTANDARD LVCMOS33 } [get_ports { leds[1] }]; #leds[1] to LED 2 (pin C16)
set_property src_info {type:XDC file:1 line:9 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports { reset }]; #Assign reset to button 0
