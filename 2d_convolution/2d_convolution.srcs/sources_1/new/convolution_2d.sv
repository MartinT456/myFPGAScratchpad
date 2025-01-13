`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin Tran
// Create Date: 01/11/2025
// Module Name: convolution_2d
// Target Devices: 
// Tool Versions: 
// Description: 
// The 2D convolution module computes the convolution of a 5x5 image with a 3x3 kernel, producing a 3x3 output matrix. This module demonstrates basic image processing using SystemVerilog. Below is the description:
//
// Module Purpose:
// Performs 2D convolution by sliding a 3x3 kernel over a 5x5 input image.
// Each output pixel is calculated as the sum of element-wise multiplications of the kernel and a corresponding 3x3 sub-region of the input image.
//
// Inputs:
// clk: System clock.
// reset: Resets the module, clearing the output matrix.
// image: A 5x5 matrix representing the input image, where each pixel is an 8-bit value.
// kernel: A 3x3 matrix representing the convolution kernel, where each value is an 8-bit coefficient.
//
// Outputs:
// result: A 3x3 output matrix representing the convolution result. Each value is a 16-bit signed value to accommodate the sum of 8-bit multiplications.
//
//////////////////////////////////////////////////////////////////////////////////



    
module convolution_2d (
    input logic clk,                   // Clock signal
    input logic reset,                 // Reset signal
    input logic [7:0] image [0:4][0:4], // Input 5x5 image (8-bit pixels)
    input logic [7:0] kernel [0:2][0:2], // 3x3 convolution kernel (8-bit values)
    output logic [15:0] result [0:2][0:2] // Output 3x3 result matrix (16-bit sums)
);

   
    logic [15:0] mult_result [0:2][0:2]; // Store the multiplication results (16-bit)
    logic [15:0] sum_result; // Store the sum of the products for each pixel

    // Iterate over the image matrix with the kernel
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset the result matrix to zero on reset
            for (int i = 0; i < 3; i++) begin
                for (int j = 0; j < 3; j++) begin
                    result[i][j] <= 0;
                end
            end
        end else begin
            // Perform the convolution operation for each output pixel (3x3 output)
            for (int i = 0; i < 3; i++) begin
                for (int j = 0; j < 3; j++) begin
                    sum_result = 0; // Clear the sum for each pixel

                    // Apply the kernel to the image (3x3 convolution)
                    for (int m = 0; m < 3; m++) begin
                        for (int n = 0; n < 3; n++) begin
                            // Multiply image and kernel values, and accumulate the result
                            mult_result[m][n] = image[i+m][j+n] * kernel[m][n];
                            sum_result = sum_result + mult_result[m][n];
                        end
                    end
                    
                    // Store the convolution result
                    result[i][j] <= sum_result;
                end
            end
        end
    end
endmodule
