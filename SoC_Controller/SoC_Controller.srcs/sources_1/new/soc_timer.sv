`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin Tran
// 
// Create Date: 01/17/2025 
// Module Name: soc_timer
// Project Name: SoC_Controller
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module soc_timer #(
    parameter WIDTH = 32 // Timer width
)(
    input  logic clk,
    input  logic reset,
    input  logic enable,
    input  logic [WIDTH-1:0] interval,
    output logic interrupt
);

    logic [WIDTH-1:0] counter;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            interrupt <= 0;
        end else if (enable) begin
            if (counter == interval) begin
                counter <= 0;
                interrupt <= 1; // Raise interrupt
            end else begin
                counter <= counter + 1;
                interrupt <= 0;
            end
        end
    end

endmodule