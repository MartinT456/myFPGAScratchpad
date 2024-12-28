`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2024 12:25:33 PM
// Design Name: 
// Module Name: UART_TX_COMD_A735T
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


module UART_TX_COMD_A735T(
    input wire clk,          // System clock
    input wire reset,        // Reset signal
    input wire rx,           // Serial data input
    output reg [7:0] data,   // Parallel data output
    output reg valid         // Data valid signal
    );
    
    // Parameters
    parameter int BAUD_RATE = 9600;
    parameter int CLK_FREQ  = 12_000_000; // FPGA clock frequency in Hz
    parameter int BIT_TIME  = CLK_FREQ / BAUD_RATE;

    // State definitions
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} rx_state_t;
    rx_state_t state = IDLE;

    // Registers and counters
    logic [15:0] baud_counter; // Counter for baud rate timing
    logic [3:0]  bit_index;      // Bit index (0-7 for data bits)
    logic [7:0]  shift_reg;    // Shift register for received data

    // Receive logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data <= 8'd0;
            valid <= 1'b0;
            baud_counter <= 16'd0;
            bit_index <= 4'd0;
        end else begin
            case (state)
                IDLE: begin
                    valid        <= 1'b0;
                    baud_counter <= 16'd0;
                    if (rx == 1'b0) state <= START; // Detect start bit
                end
                START: begin
                    if (baud_counter == (BIT_TIME / 2) - 1) begin
                        baud_counter <= 16'd0;
                        state <= DATA;
                    end else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
                DATA: begin
                    if (baud_counter == BIT_TIME - 1) begin
                        baud_counter <= 16'd0;
                        shift_reg <= {rx, shift_reg[7:1]}; // Shift in bits
                        bit_index <= bit_index + 1;
                        if (bit_index == 7) state <= STOP;
                    end else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
                STOP: begin
                    if (baud_counter == BIT_TIME - 1) begin
                        data <= shift_reg;
                        valid <= 1'b1; // Indicate valid data
                        state <= IDLE;
                    end else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
            endcase
        end
    end
endmodule
