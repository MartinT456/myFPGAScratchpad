`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin TRan
// 
// Create Date: 01/17/2025
// Design Name: 
// Module Name: soc_top_level
// Project Name: 
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


module soc_top_level(
    input  logic clk,
    input  logic reset,
    input  logic rx, // UART receive pin
    output logic tx  // UART transmit pin
);

    parameter int BAUD_RATE = 9600;
    parameter int CLK_FREQ = 12_000_000;
    
    logic [7:0] rx_data;
    logic rx_valid;
    logic tx_start, tx_busy;

    logic [31:0] reg_data_in, reg_data_out;
    logic [3:0] reg_addr;
    logic write_enable;
    logic [31:0] alu_operand_a, alu_operand_b, alu_result;
    logic [2:0] alu_opcode;
    logic alu_zero_flag;
    logic timer_interrupt;

    // Instantiate modules
    UART_RX_CMOD_A735T #(
        .BAUD_RATE(BAUD_RATE),
        .CLK_FREQ(CLK_FREQ)
    ) uart_rx (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data(rx_data),
        .valid(rx_valid)
    );
    
    UART_TX_CMOD_A735T #(
        .BAUD_RATE(BAUD_RATE),
        .CLK_FREQ(CLK_FREQ)
    ) uart_tx (
        .clk(clk),
        .reset(reset),
        .tx(tx),
        .tx_start(tx_start),
        .tx_busy(tx_busy)
    );

    register_file reg_file_inst (
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        .write_addr(reg_addr),
        .write_data(reg_data_in),
        .read_addr(reg_addr),
        .read_data(reg_data_out)
    );

    alu alu_inst (
        .operand_a(alu_operand_a),
        .operand_b(alu_operand_b),
        .opcode(alu_opcode),
        .result(alu_result),
        .zero_flag(alu_zero_flag)
    );

    timer timer_inst (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .interval(32'd50000), 
        .interrupt(timer_interrupt)
    );

endmodule
