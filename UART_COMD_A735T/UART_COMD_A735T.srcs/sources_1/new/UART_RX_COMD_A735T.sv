`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Martin Tran
// Create Date: 12/23/2024 12:25:33 PM
//
// Module Name: UART_RX_COMD_A735T
// Project Name: UART_COMD_A735T
// Target Devices: COMD A7-35T
// Description: 
// UART RX Module
// 
// This SystemVerilog module implements a UART receiver that converts 8-bit
// serial data stream into parallel data over UART line.
// 
// The receiver is controlled by a finite state machine with the following
// states: IDLE, START, DATA, STOP. The module uses a shift register to receive
// each bit of the data stream, and then sets valid signal to high when data is ready.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_RX_COMD_A735T(
    input wire clk,          // System clock
    input wire reset,        // Reset signal
    input wire rx,           // Serial data input
    output reg [7:0] data,   // Parallel data output
    output reg valid         // Data valid signal
    );
    
    parameter int BAUD_RATE = 9600;
    parameter int CLK_FREQ  = 12_000_000; // FPGA clock frequency in Hz
    parameter int BIT_TIME  = CLK_FREQ / BAUD_RATE;

    // States definition
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} rx_state_t;
    rx_state_t state = IDLE;

    // Registers and counters
    logic [15:0] baud_count;   // Counter for baud rate timing
    logic [3:0]  bit_index;    // Bit index (0-7 for data bits)
    logic [7:0]  shift_reg;    // Shift register for received data

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data <= 8'd0;
            valid <= 1'b0;
            baud_count <= 16'd0;
            bit_index <= 4'd0;
        end else begin
            case (state)
                IDLE: begin
                    valid <= 1'b0;
                    baud_count <= 16'd0;
                    if (rx == 1'b0) state <= START; // Detect start bit
                end
                START: begin
                    if (baud_count == (BIT_TIME / 2) - 1) begin // Synchronize with center of start bit for accurate data sampling
                        baud_count <= 16'd0;
                        state <= DATA;
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end
                DATA: begin
                    if (baud_count == BIT_TIME - 1) begin
                        baud_count <= 16'd0;
                        shift_reg <= {rx, shift_reg[7:1]}; // Shift in bits
                        bit_index <= bit_index + 1;
                        if (bit_index == 7) state <= STOP;
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end
                STOP: begin
                    if (baud_count == BIT_TIME - 1) begin
                        data <= shift_reg;
                        valid <= 1'b1; // Indicate valid data
                        state <= IDLE;
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end
            endcase
        end
    end
endmodule
