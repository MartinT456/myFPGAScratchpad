`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin Tran
// 
// Create Date: 01/19/2025
//
// Module Name: tb_mix_columns
// Project Name: aes_encryption
//
// Description: 
// This file contains the testbench for verifying the functionality of the 
// mix_columns module, which implements the MixColumns transformation in the 
// AES encryption process. MixColumns is responsible for mixing the data within 
// each column of the AES state matrix to achieve diffusion, a necessary property 
// for the security of the cipher.
// 
// The testbench is designed to validate that the mix_columns module correctly 
// performs the Galois field matrix multiplication as specified by the AES standard.
// It compares the module's outputs to known expected values to ensure the 
// implementation is accurate.
//////////////////////////////////////////////////////////////////////////////////


module tb_mix_columns;

    logic [127:0] state_in, state_out;
    
    mix_columns uut_mix_columns(.state_in(state_in), .state_out(state_out));
    
    task display_test_result(
        input [127:0] input_state,
        input [127:0] expected_output,
        input [127:0] actual_output
    );
        if (actual_output === expected_output) begin
            $display("PASS: Input = %h, Output = %h", input_state, actual_output);
        end else begin
            $display("FAIL: Input = %h, Expected = %h, Actual = %h", input_state, expected_output, actual_output);
        end
    endtask
    
    initial begin
        $display("Starting mix_columns testbench...");

        // Test 1
        state_in = 128'h00112233445566778899aabbccddeeff; 
        #10; 
        display_test_result(state_in, 128'h2277005566334411aaff88ddeebbcc99, state_out);

        // Test 2
        state_in = 128'hffeeddccbbaa99887766554433221100;
        #10;
        display_test_result(state_in, 128'hdd88ffaa99ccbbee5500772211443366, state_out);

        // Test 3
        state_in = 128'h6b4f9a2cd8e73f0ab1c245e68d9af347;
        #10;
        display_test_result(state_in, 128'hb16c7f30ac465fbf8707c89800eb236b, state_out);
        
        // Test 4
        state_in = 128'ha3f9d4e7c81245b6f0ea34dc87ab1254;
        #10;
        display_test_result(state_in, 128'h7ecadb064e95916336bf0d76b5a8f483, state_out);
        $display("mix_columns Testbench Completed.");
        $stop;
    end
    
endmodule
