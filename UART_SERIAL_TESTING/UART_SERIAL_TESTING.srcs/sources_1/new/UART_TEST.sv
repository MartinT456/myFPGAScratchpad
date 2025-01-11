`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2025 09:48:46 AM
// Design Name: 
// Module Name: UART_TEST
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


module UART_TEST(
    input  logic       clk,         // System clock
    input  logic       reset,       // Reset signal
    output logic       tx,          // UART TX line
    input  logic       rx,          // UART RX line
    output logic [1:0] leds         // LEDs for visual feedback
    );
    
    parameter int BAUD_RATE = 9600;
    parameter int CLK_FREQ = 12_000_000;
    
    // Counter
    logic [7:0] counter;
    logic [31:0] delay_counter;
    logic tx_start, tx_busy;
    
    logic [7:0] rx_data;
    logic rx_valid;

    // Takes RX and echos it as TX
    /*
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 8'd0;
            tx_start <= 1'b0;
        end else if ((tx_busy == 1'b0) && (rx_valid)) begin         
            counter <= rx_data;
            tx_start <= 1'b1;
        end else begin
            delay_counter <= delay_counter + 1;
            tx_start <= 1'b0;
        end                 
    end
    */
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 8'd47;
            delay_counter <= 32'd0;
            tx_start <= 1'b0;
        end else if ((tx_busy == 1'b0) && (delay_counter >= CLK_FREQ)) begin
            delay_counter <= 32'd0;
            if (counter == 8'd57) begin // Go back to ASCII '0' after '9'
                counter <= 8'd48;
            end else begin
                counter <= counter + 1;
            end
            tx_start <= 1'b1; // Start TX
        end else begin
            delay_counter <= delay_counter + 1;
            tx_start <= 1'b0;
        end                
    end
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            leds <= 2'b01;
        end else if (rx_valid) begin
            leds <= ~leds; // Swap leds on successful RX
        end
        

    end
    
    
        // TX Instantiation
    UART_TX_CMOD_A735T #(
        .BAUD_RATE(BAUD_RATE),
        .CLK_FREQ(CLK_FREQ)
    ) uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .data(counter),
        .start(tx_start),
        .tx(tx),
        .busy(tx_busy)
    );
    
    UART_RX_CMOD_A735T #(
        .BAUD_RATE(BAUD_RATE),
        .CLK_FREQ(CLK_FREQ)
    ) uart_rx_inst (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data(rx_data),
        .valid(rx_valid)
    );
    
endmodule

    


    
    

