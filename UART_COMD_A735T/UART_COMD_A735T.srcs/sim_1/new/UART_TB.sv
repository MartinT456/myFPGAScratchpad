`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Martin Tran
// Create Date: 01/04/2025 09:55:44 AM
//
// Module Name: UART_TB
// Project Name: UART_COMD_A735T
// Target Devices: COMD A7-35T
// Description: 
// Testbench for UART Transmitter and Receiver (Loopback Simulation)
//
// Description:
// This testbench is designed to verify the functionality of the UART transmitter (UART_TX_COMD_A735T)
// and receiver (UART_RX_COMD_A735T) modules using a loopback configuration. The transmitter sends 
// data to the receiver, which then outputs the received data. The testbench includes 
// a clock generator, a reset signal, and stimulus for the transmitter and receiver modules.
//
// Key Components:
// 1. **Clock Generator**: Generates a clock signal with a period of 20ns (50MHz) to drive the simulation.
// 2. **Reset Logic**: Initializes the design by asserting the reset signal at the start of the simulation.
// 3. **Data Input for Transmitter**: The testbench sends predefined data to the UART transmitter to simulate real-world UART communication.
// 4. **Loopback Connection**: The transmitted data from `uart_tx` is connected to the receiver's `rx` input, enabling data reception from the transmitter in the same simulation.
// 5. **Simulation Monitor**: The testbench includes monitoring of signals, including the transmitted data (`tx`), received data (`rx_data`), and other status flags to validate proper operation.
// 6. **Waveform Display**: The testbench configures signals for display in the waveform viewer to observe signal transitions and verify correct data transmission and reception.
//
//Simulation Flow:
// - The testbench starts by initializing the clock and reset signals.
// - The reset is asserted, and once deasserted, the UART transmitter begins sending data.
// - The receiver captures the data sent by the transmitter through the loopback connection.
// - The testbench monitors the received data and displays it in the simulation output to verify that the transmitted data is correctly received.
//
// This testbench serves as a functional verification tool to ensure that the UART modules (transmitter and receiver) work as expected under typical operation, handling both data transmission and reception correctly.

// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_TB();

    parameter int CLK_FREQ = 12_000_000;
    parameter int BAUD_RATE = 9600;
    parameter int BIT_TIME = CLK_FREQ / BAUD_RATE;
    
    logic clk, reset;
    logic tx, rx;
    logic [7:0] tx_data;
    logic [7:0] rx_data;
    logic tx_start;
    logic tx_busy;
    logic rx_valid;
    
    always #42 clk = ~clk; // Generate 12 MHz clock
    
    // Instantiate UART TX
    UART_TX_COMD_A735T #(
        .BAUD_RATE(BAUD_RATE),
        .CLK_FREQ(CLK_FREQ)
    ) uut_tx (
        .clk(clk),
        .reset(reset),
        .data(tx_data),
        .start(tx_start),
        .tx(tx),
        .busy(tx_busy)
    );
        
    // Instantiate UART RX
    UART_RX_COMD_A735T #(
        .BAUD_RATE(BAUD_RATE),
        .CLK_FREQ(CLK_FREQ)
    ) uut_rx (
        .clk(clk),
        .reset(reset),
        .rx(tx),         // Using loopback connection to test
        .data(rx_data),
        .valid(rx_valid)
    );
       
    // Test logic
    initial begin
        clk = 0;
        reset = 0;
        tx_data = 8'b0;
        tx_start = 0;
        
        // Reset
        #50 reset = 1;
        #50 reset = 0;
        
        #50;
        tx_data = 8'b 1001_0110; // Test data
        tx_start = 1; // Send start bit
        
        // Wait for TX to complete
        @(negedge tx_busy);
        tx_start = 0;
        
        // Wait for RX to complete
        wait (rx_valid);
        $display("RX Data: %b", rx_data);
        
        #100 $finish;
    end
        
    
endmodule
