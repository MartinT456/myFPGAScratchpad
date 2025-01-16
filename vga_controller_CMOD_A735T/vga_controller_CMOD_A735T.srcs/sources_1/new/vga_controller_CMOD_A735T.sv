`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin Tran
// 
// Create Date: 01/14/2025
// Design Name: 
// Module Name: vga_controller_CMOD_A735T
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


module vga_controller_CMOD_A735T(
    input logic clk,               // Input 25.16MHz clock via clocking wizard
    input logic reset,            
    output logic hsync,           
    output logic vsync,            
    output logic [3:0] red,        // Red 4-bit signal
    output logic [3:0] green,      // Green 4-bit signal
    output logic [3:0] blue,       // Blue 4-bit color signal
    output logic valid_pixel       // Signal to indicate a valid pixel
);

    // VGA 640x480 @ 60Hz timing parameters
    localparam H_SYNC_CYCLES = 96; // Sync pulse width in pixels
    localparam H_BACK_PORCH = 48; // Back porch in pixels
    localparam H_FRONT_PORCH = 16; // Front porch in pixels
    localparam H_ACTIVE_VIDEO = 640; // Active video pixels
    localparam H_TOTAL_CYCLES = 800; // Total horizontal pixels

    localparam V_SYNC_CYCLES = 2; // Sync pulse width in lines
    localparam V_BACK_PORCH = 33; // Back porch in lines
    localparam V_FRONT_PORCH = 10; // Front porch in lines
    localparam V_ACTIVE_VIDEO = 480; // Active video lines
    localparam V_TOTAL_CYCLES = 525; // Total vertical lines

    // Counters for pixel clock and sync signal generation
    logic [$clog2(H_TOTAL_CYCLES)-1:0] h_count; // Horizontal
    logic [$clog2(V_TOTAL_CYCLES)-1:0] v_count; // Vertical



    // Horizontal and Vertical Counter Logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            if (h_count == H_TOTAL_CYCLES - 1) begin
                h_count <= 0;
                if (v_count == V_TOTAL_CYCLES - 1)
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
            end else begin
                h_count <= h_count + 1;
            end
        end
    end

    // Generate the sync signals
    always_ff @(posedge clk) begin
        // Horizontal sync
        if (h_count < H_SYNC_CYCLES)
            hsync <= 0; 
        else
            hsync <= 1; 

        // Vertical sync
        if (v_count < V_SYNC_CYCLES)
            vsync <= 0; 
        else
            vsync <= 1; 
    end

    // Generate color signals and valid pixel flag
    always_ff @(posedge clk) begin
        // Set valid_pixel when we're in the active video area
        if ((h_count < H_ACTIVE_VIDEO) && (v_count < V_ACTIVE_VIDEO)) begin   // Fill the left half of the screen with red
            valid_pixel <= 1; 
            red   <= (h_count < H_ACTIVE_VIDEO / 2) ? 4'hF : 4'h0; // Red pattern
            green <= 4'h0; // No green
            blue  <= 4'h0; // No blue
        end else begin
            valid_pixel <= 0; // Outside active video area
            red   <= 4'h0;
            green <= 4'h0;
            blue  <= 4'h0;
        end
    end

endmodule
