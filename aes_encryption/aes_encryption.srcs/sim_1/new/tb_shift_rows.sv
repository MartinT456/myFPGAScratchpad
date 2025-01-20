`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin Tran
// 
// Create Date: 01/19/2025 
// Design Name: 
// Module Name: tb_shift_rows
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


module tb_shift_rows;

    logic [127:0] state_in;
    logic [127:0] state_out;
    
    shift_rows uut_shift_rows(.state_in(state_in), .state_out(state_out));
    
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
        $display("Starting shift_rows Testbench...");

        // Test 1
        state_in = 128'h00112233445566778899aabbccddeeff; 
        #10; 
        display_test_result(state_in, 128'h0055aaff4499ee3388dd2277cc1166bb, state_out);

        // Test 2
        state_in = 128'hffeeddccbbaa99887766554433221100;
        #10;
        display_test_result(state_in, 128'hffaa5500bb6611cc7722dd8833ee9944, state_out);

        // Test 3
        state_in = 128'h6b4f9a2cd8e73f0ab1c245e68d9af347;
        #10;
        display_test_result(state_in, 128'h6be74547d8c2f32cb19a9a0a8d4f3fe6, state_out);
        
        // Test 4
        state_in = 128'ha3f9d4e7c81245b6f0ea34dc87ab1254;
        #10;
        display_test_result(state_in, 128'ha3123454c8ea12e7f0abd4b687f945dc, state_out);
        $display("shift_rows Testbench Completed.");
        $stop;
    end
endmodule
