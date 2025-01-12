`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// WRitten by: Martin Tran
// Create Date: 01/11/2025
// Module Name: convolution_2d
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


module convolution_2d(
    input logic clk,
    input logic reset,
    input logic [7:0] img [0:4][0:4], // 5x5 image with 8-bit pixels
    input logic [7:0] kernel [0:2][0:2], //3x3 convolution kernel
    output logic [15:0] result [0:2][0:2]
    );
    
    logic [15:0] mult_result [0:2][0:2]; // Used to store multiplication
    logic [15:0] sum_result; // Sum of products for each pixel
    
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
