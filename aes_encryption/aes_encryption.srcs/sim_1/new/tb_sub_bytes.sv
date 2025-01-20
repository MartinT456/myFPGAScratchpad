`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin Tran
//
// Create Date: 01/19/2025
// 
// Module Name: tb_sub_bytes
// Project Name: aes_encryption
// 
// Description: 
// The testbench ensures that the sub_bytes module performs the byte-by-byte 
// substitution correctly, as per the AES standard. It tests the module using 
// a variety of input values to confirm accuracy by taking the output from the 
// uut and compares it to the pre-calculated expected result of the transformation.
//
//////////////////////////////////////////////////////////////////////////////////


module tb_sub_bytes;
    
    logic [127:0] state_in;
    logic [127:0] state_out;
    
    sub_bytes uut_sub_bytes(.state_in(state_in), .state_out(state_out));
    
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
        $display("Starting sub_bytes Testbench...");

        // Test 1
        state_in = 128'h00112233445566778899aabbccddeeff; 
        #10; 
        display_test_result(state_in, 128'h638293c31bfc33f5c4eeacea4bc12816, state_out);

        // Test 2
        state_in = 128'hffeeddccbbaa99887766554433221100;
        #10;
        display_test_result(state_in, 128'h1628c14beaaceec4f533fc1bc3938263, state_out);

        // Test 3
        state_in = 128'h6b4f9a2cd8e73f0ab1c245e68d9af347;
        #10;
        display_test_result(state_in, 128'h7f84b87161947567c8256e8e5db80da0, state_out);
        
        // Test 4
        state_in = 128'ha3f9d4e7c81245b6f0ea34dc87ab1254;
        #10;
        display_test_result(state_in, 128'h0a994894e8c96e4e8c8718861762c920, state_out);
        $display("sub_bytes Testbench Completed.");
        $stop;
    end
endmodule
