`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Martin Tran
// Create Date: 12/19/2024 12:25:33 PM

// Module Name: UART_TX_COMD_A735T
// Project Name: UART_COMD_A735T
// Target Devices: COMD A7-35T
// Description: 
// UART TX Module
// 
// This SystemVerilog module implements a UART transmitter that converts 8-bit
// parallel data into a serial data stream for transmission over a UART line.
// 
// The transmitter is controlled by a finite state machine (FSM) with the following
// states: IDLE, START, DATA, STOP. The module uses a shift register to transmit
// each bit of the data frame, and a bit index register to track the position
// of the current bit being transmitted.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_TX_COMD_A735T(
    input logic clk,             // System clock 12MHz
    input logic reset,
    input logic [7:0] data,
    input logic start,            // Start bit trigger
    output logic tx,        // UART tx line
    output logic busy            // Line busy flag
    );
    
    parameter int BAUD_RATE = 9600;
    parameter int CLK_FREQ = 12_000_000;
    parameter int BIT_TIME = CLK_FREQ / BAUD_RATE;
    
    // 2-bit state definitions
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} tx_state_t;
    tx_state_t state = IDLE;
    
    logic [3:0] bit_index;    // Bit index for 8 bits
    logic [15:0] baud_count;  // Baud rate timing count
    logic [7:0] shift_reg;    // Data shift register
    
    // Transmit logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx <= 1'b1;
            busy <= 1'b0;
            bit_index <= 4'd0;
            baud_count <= 16'd0;           
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    busy <= 1'b0;
                    baud_count <= 16'd0;
                    if (start) begin
                        state <= START;
                        shift_reg <= data;
                        busy <= 1'b1;
                    end
                end
                START: begin 
                    tx <= 1'b0; // Start bit (low)
                    if (baud_count == BIT_TIME - 1) begin
                        baud_count <= 16'd0;    // Reset baud count
                        bit_index <= 4'd0;      // Reset bit index
                        state <= DATA;
                    end else begin
                        baud_count <= baud_count + 1;
                    end 
                end
                DATA: begin
                    tx <= shift_reg[0]; // Send LSB over tx line
                    if (baud_count == BIT_TIME - 1) begin
                        baud_count <= 16'd0;
                        shift_reg <= shift_reg >> 1;
                        bit_index <= bit_index + 1;
                        if (bit_index == 7) state <= STOP;   
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end
                STOP: begin
                    tx <= 1'b1; // Stop bit
                    if (baud_count == BIT_TIME - 1) begin
                        state <= IDLE;
                    end else begin
                        baud_count <= 16'd0;
                    end
                end
            endcase   
        end
    end
endmodule
