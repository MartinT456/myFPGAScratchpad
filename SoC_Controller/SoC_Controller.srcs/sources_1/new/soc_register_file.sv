`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin Tran
// 
// Create Date: 01/17/2025 
// Module Name: soc_register_file
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


module soc_register_file #(
    parameter ADDR_WIDTH = 4, // Number of registers (2^ADDR_WIDTH)
    parameter DATA_WIDTH = 32
)(
    input  logic clk,
    input  logic reset,
    input  logic write_enable,
    input  logic [ADDR_WIDTH-1:0] write_addr,
    input  logic [DATA_WIDTH-1:0] write_data,
    input  logic [ADDR_WIDTH-1:0] read_addr,
    output logic [DATA_WIDTH-1:0] read_data
);

    logic [DATA_WIDTH-1:0] registers[2**ADDR_WIDTH-1:0];

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
                registers[i] <= 0;
            end
        end else if (write_enable) begin
            registers[write_addr] <= write_data;
        end
    end

    assign read_data = registers[read_addr];

endmodule
