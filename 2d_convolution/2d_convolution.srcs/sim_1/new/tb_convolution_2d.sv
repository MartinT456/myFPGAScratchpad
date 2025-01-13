`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/12/2025 05:44:45 PM
// Design Name: 
// Module Name: tb_convolution_2d
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


module tb_convolution_2d();
    
        // Declare signals for the testbench
    logic clk;
    logic reset;
    logic [7:0] image [0:4][0:4]; // 5x5 image
    logic [7:0] kernel [0:2][0:2]; // 3x3 kernel
    logic [15:0] result [0:2][0:2]; // 3x3 result matrix
    
    always #42 clk = ~clk; // Generate 12 MHz clock

    // Instantiate the DUT (Device Under Test)
    convolution_2d #(
    ) uut_convolution_2d (
        .clk(clk),
        .reset(reset),
        .image(image),
        .kernel(kernel),
        .result(result)
    );
    
    initial begin
        // Initialize the clock and reset
        clk = 0;
        reset = 0;

        // Initialize image and kernel (simple values for testing)
        image[0] = {8'd1, 8'd2, 8'd3, 8'd4, 8'd5};
        image[1] = {8'd6, 8'd7, 8'd8, 8'd9, 8'd10};
        image[2] = {8'd11, 8'd12, 8'd13, 8'd14, 8'd15};
        image[3] = {8'd16, 8'd17, 8'd18, 8'd19, 8'd20};
        image[4] = {8'd21, 8'd22, 8'd23, 8'd24, 8'd25};

        kernel[0] = {8'd1, 8'd0, 8'd1};
        kernel[1] = {8'd0, 8'd1, 8'd0};
        kernel[2] = {8'd1, 8'd0, 8'd1};

        // Apply reset
        reset = 1;
        #10 reset = 0;

        // Run simulation
        #100;

        // Print the result
        $display("Convolution Result:");
        for (int i = 0; i < 3; i++) begin
            for (int j = 0; j < 3; j++) begin
                $display("result[%0d][%0d] = %0d", i, j, result[i][j]);
            end
        end

        $finish;
    end
endmodule
