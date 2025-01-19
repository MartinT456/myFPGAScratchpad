`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin Tran
// 
// Create Date: 01/19/2025
// Design Name: 
// Module Name: tb_key_expansion
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


module tb_key_expansion;
    // Testbench Signals
    logic clk, reset;
    logic [127:0] key;
    logic [127:0] round_keys [0:10];

    // Clock Generation
    always #5 clk = ~clk; // 100 MHz clock (period = 10ns)

    // DUT Instantiation
    key_expansion uut (
        .clk(clk),
        .reset(reset),
        .key(key),
        .round_keys(round_keys)
    );


    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        key = 128'b0;

        // Apply Reset
        #10 reset = 0;
        #50;
        @(posedge clk); // Wait for one clock edge
        $display("Test 1: Basic Key = %h", key);
        for (int i = 0; i < 11; i++) begin
            $display("Round %0d Key: %h", i, round_keys[i]);
        end
        
        // Test Case 2: All Ones Key
        #10 key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // All ones key
        #50
        @(posedge clk);
        $display("Test 2: All Ones Key = %h", key);
        for (int i = 0; i < 11; i++) begin
            $display("Round %0d Key: %h", i, round_keys[i]);
        end

        #10;
        $stop;
    end
endmodule
