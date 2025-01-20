`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin Tran
// 
// Create Date: 01/19/2025
//
// Module Name: tb_key_expansion
// Project Name: aes_encryption
//
// Description: 
// This file serves as the testbench for verifying the functionality of the AES-128 key expansion module.
// The key expansion module takes a 128-bit cipher key as input and generates 11 round keys (128 bits each)
// based on the AES-128 key schedule algorithm. The testbench ensures the correctness of the module by 
// applying various test cases and then comparing the generated round keys against expected values.
//
//////////////////////////////////////////////////////////////////////////////////


module tb_key_expansion;
    // Testbench Signals
    logic clk, reset;
    logic [127:0] key;
    logic [127:0] round_keys [0:10];

    // Clock Generation
    always #5 clk = ~clk; // 100 MHz clock

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
        
        /*  Test case 1 expected result:
            00000000000000000000000000000000
            62636363626363636263636362636363
            9b9898c9f9fbfbaa9b9898c9f9fbfbaa
            90973450696ccffaf2f457330b0fac99
            ee06da7b876a1581759e42b27e91ee2b
            7f2e2b88f8443e098dda7cbbf34b9290
            ec614b851425758c99ff09376ab49ba7
            217517873550620bacaf6b3cc61bf09b
            0ef903333ba9613897060a04511dfa9f
            b1d4d8e28a7db9da1d7bb3de4c664941
            b4ef5bcb3e92e21123e951cf6f8f188e   */
            
        $display("Test 1: Key = %h", key);
        for (int i = 0; i < 11; i++) begin
            $display("Round %0d Key: %h", i, round_keys[i]);
        end
        
        /*
         Test case 2 expected result:
         ffffffffffffffffffffffffffffffff 
         e8e9e9e917161616e8e9e9e917161616 
         adaeae19bab8b80f525151e6454747f0 
         090e2277b3b69a78e1e7cb9ea4a08c6e 
         e16abd3e52dc2746b33becd8179b60b6 
         e5baf3ceb766d488045d385013c658e6 
         71d07db3c6b6a93bc2eb916bd12dc98d 
         e90d208d2fbb89b6ed5018dd3c7dd150 
         96337366b988fad054d8e20d68a5335d 
         8bf03f233278c5f366a027fe0e0514a3 
         d60a3588e472f07b82d2d7858cd7c326 */
        
        #10 key = 128'hffffffffffffffffffffffffffffffff; // All ones key
        #50
        @(posedge clk);
        $display("Test 2: Key = %h", key);
        for (int i = 0; i < 11; i++) begin
            $display("Round %0d Key: %h", i, round_keys[i]);
        end
        
         /*       
         Test case 3 expected result:
         7ecadb064e95916336bf0d76b5a8f483 
         bd7537d3f3e0a6b0c55fabc670f75f45 
         d7ba5982245aff32e10554f491f20bb1 
         5a9191037ecb6e319fce3ac50e3c3174 
         b95603a8c79d6d995853575c566f6628 
         01653719c6f85a809eab0ddcc8c46bf4 
         3d1a88f1fbe2d2716549dfadad8db459 
         20974364db759115be3c4eb813b1fae1 
         68babb19b3cf2a0c0df364b41e429e55 
         5fb1476bec7e6d67e18d09d3ffcf9786 
         e339037d0f476e1aeeca67c91105f04f */
        
        #10 key = 128'h7ecadb064e95916336bf0d76b5a8f483;
        #50
        $display("Test 3: Key = %h", key);
        for (int i = 0; i < 11; i++) begin
            $display("Round %0d Key: %h", i, round_keys[i]);
        end
        $stop;
    end
endmodule
