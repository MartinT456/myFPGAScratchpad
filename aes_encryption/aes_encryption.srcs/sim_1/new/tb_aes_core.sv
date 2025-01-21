`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin Tran
// 
// Create Date: 01/20/2025 
// Design Name: 
// Module Name: tb_aes_core
// Project Name: aes_encryption
// 
// Description: 
// Testbench for verifying the functionality of the AES Core module. The 
// AES Core implements the AES-128 encryption algorithm, processing a 
// 128-bit plaintext input and producing a 128-bit ciphertext output using 
// a 128-bit encryption key. 
//
// This testbench initializes the AES Core, provides test vectors (plaintext
// and keys), then compares and displays the resulting ciphertext to 
// precalculated expected ciphertexts. 
//
//////////////////////////////////////////////////////////////////////////////////


module tb_aes_core;
    
    logic clk, reset;
    logic [127:0] plaintext, ciphertext, key, expected_ciphertext;
        
    aes_core uut_aes_core(.clk(clk), .reset(reset), .plaintext(plaintext), .ciphertext(ciphertext), .key(key));
    
    // Clock generation
    always #42 clk = ~clk;  // 12 MHz clock

    // Task to reset
    task reset_uut();
        begin
            reset = 1'b1;
            #10;  // Hold reset for 10 ns
            reset = 1'b0;
        end
    endtask

    // Task to display results    
        task display_test_result(
        input [127:0] plaintext,
        input [127:0] key,
        input [127:0] expected_ciphertext,
        input [127:0] actual_ciphertext
    );
        if (expected_ciphertext === actual_ciphertext) begin
            $display("PASS: Plaintext = %h, Key = %h, Ciphertext = %h", plaintext, key, actual_ciphertext);
        end else begin
            $display("FAIL: Plaintext = %h, Key = %h, Expected Ciphertext = %h, Actual Ciphertect = %h", 
            plaintext, key, expected_ciphertext, actual_ciphertext);       
        end
    endtask

    // Test Process
    initial begin
        // Initialize signals
        clk = 1'b0;
        reset = 1'b0;
        
        // Test 1:
        plaintext = 128'h00000000000000000000000000000000;  
        key = 128'h00000000000000000000000000000000;
        expected_ciphertext = 128'h66e94bd4ef8a2c3b884cfa59ca342b2e;    
        reset_uut(); // Reset
        wait (ciphertext != 128'b0);  // Wait until ciphertext is updated
        #10;  
        display_test_result(plaintext, key, expected_ciphertext, ciphertext);
        
        // Test 2:
        plaintext = 128'h00000000000000000000000000000000;  
        key = 128'hffffffffffffffffffffffffffffffff;
        expected_ciphertext = 128'ha1f6258c877d5fcd8964484538bfc92c;    
        reset_uut(); // Reset
        wait (ciphertext != 128'b0);  // Wait until ciphertext is updated
        #10;  
        display_test_result(plaintext, key, expected_ciphertext, ciphertext);
        
        // Test 3:
        plaintext = 128'hffffffffffffffffffffffffffffffff;  
        key = 128'h00000000000000000000000000000000;
        expected_ciphertext = 128'h3f5b8cc9ea855a0afa7347d23e8d664e;    
        reset_uut(); // Reset
        wait (ciphertext != 128'b0);  // Wait until ciphertext is updated
        #10;  
        display_test_result(plaintext, key, expected_ciphertext, ciphertext);
        
        // Test 4:
        plaintext = 128'hffffffffffffffffffffffffffffffff;  
        key = 128'hffffffffffffffffffffffffffffffff;
        expected_ciphertext = 128'hbcbf217cb280cf30b2517052193ab979;    
        reset_uut(); // Reset
        wait (ciphertext != 128'b0);  // Wait until ciphertext is updated
        #10;  
        display_test_result(plaintext, key, expected_ciphertext, ciphertext);
        
        
        // Test 5:
        plaintext = 128'he7af0fa06c6bbf7a573645cf1be7ace3;  
        key = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
        expected_ciphertext = 128'h571dda98bc6f128a91b67253cf1c08a4;    
        reset_uut(); // Reset
        wait (ciphertext != 128'b0);  // Wait until ciphertext is updated
        #10;  
        display_test_result(plaintext, key, expected_ciphertext, ciphertext);

        
        $finish;
    end
endmodule
