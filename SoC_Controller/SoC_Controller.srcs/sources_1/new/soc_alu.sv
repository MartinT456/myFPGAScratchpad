`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin Tran
// 
// Create Date: 01/17/2025 
// Module Name: soc_alu
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


module soc_alu #(
    parameter DATA_WIDTH = 32 // ALU data width
)(
    input  logic [DATA_WIDTH-1:0] operand_a,
    input  logic [DATA_WIDTH-1:0] operand_b,
    input  logic [2:0] operation, // 3-bit opcode
    output logic [DATA_WIDTH-1:0] result,
    output logic zero_flag // Indicates result == 0
);

    always_comb begin
        case (operation)
            3'b000: result = operand_a + operand_b; 
            3'b001: result = operand_a - operand_b; 
            3'b010: result = operand_a & operand_b; 
            3'b011: result = operand_a | operand_b; 
            3'b100: result = operand_a ^ operand_b;
            default: result = 0;
        endcase
        zero_flag = (result == 0);
    end

endmodule