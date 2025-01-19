`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin Tran
// 
// Create Date: 01/19/2025
// Design Name: 
// Module Name: shift_rows
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


module shift_rows(
    input logic [127:0] state_in,
    output logic [127:0] state_out
    );
    
    assign state_out = {
        state_in[127:120], state_in[87:80], state_in[47:40], state_in [7:0],         
        state_in[95:88], state_in[55:48], state_in[15:8], state_in[103:96],
        state_in[63:56], state_in[23:16], state_in[111:104], state_in[71:64],
        state_in[31:24], state_in[119:112], state_in[79:72], state_in[39:32]
    };
endmodule
