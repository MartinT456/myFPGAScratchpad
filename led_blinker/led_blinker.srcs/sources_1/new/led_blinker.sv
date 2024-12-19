`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 12/18/2024 01:40:22 PM
// Module Name: led_blinker
// Description: 
// This is a simple LED blinker design for the Xilinx Artix-7 (A7-35T) FPGA.  
// The module drives the 2 LEDs in an alternating pattern (blinking) based on  
// clock cycles. 
//
// Version 1.0 - Initial creation of the LED blinking design  
//////////////////////////////////////////////////////////////////////////////////


module led_blinker(
        input wire clk,
        input wire reset,
        output reg [1:0] leds
    );
    
// Counter
reg [24:0] counter;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        leds <= 2'b10;
        counter <= 0;
    end else begin
        counter <= counter + 1;
        // Switch to other LED each second
        if (counter == 12_000_000) begin
            if (!leds) begin
                leds <= 2'b10;
            end else begin
                leds <= ~leds;
            end
            counter <= 0;
        end
    end
end
endmodule
