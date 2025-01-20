`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin Tran
// 
// Create Date: 01/19/2025 
// Design Name: 
// Module Name: mix_columns
// Project Name: aes_encryption
// Target Devices: CMOD A7-35T

// Description: 
// 
//
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mix_columns(
    input logic [127:0] state_in,
    output logic [127:0] state_out
    );
    
    // Finite field/Galois field multiplication functions:  
    // Multiply by 2: xtime(a)=(a<<1)⊕((a AND 0x80)?0x1B:0) as per AES standard
    function logic [7:0] xtime(input logic [7:0] byte_in);
        xtime = (byte_in << 1) ^ ((byte_in[7]) ? 8'h1b : 0);
    endfunction
    
    // Multiply by 3: gmul3(a)=xtime(a)⊕a
    function logic [7:0] gmul3(input logic [7:0] byte_in);
        gmul3 = xtime(byte_in)^ byte_in;
    endfunction
    
    logic [7:0] column_in [0:3];
    logic [7:0] column_out [0:3];
    
    function void mix_column(input logic [7:0] column_in [0:3], output logic [7:0] column_out [0:3]);
        
        column_out[0] = xtime(column_in[0]) ^ gmul3(column_in[1]) ^ column_in[2] ^ column_in[3];
        column_out[1] = column_in[0] ^ xtime(column_in[1]) ^ gmul3(column_in[2]) ^ column_in[3];
        column_out[2] = column_in[0] ^ column_in[1] ^ xtime(column_in[2]) ^ gmul3(column_in[3]);
        column_out[3] = gmul3(column_in[0]) ^ column_in[1] ^ column_in[2] ^ xtime(column_in[3]);

    endfunction
    
    always_comb begin
        // Extract 4 columns and perform a mix_column on each
        for(int i = 0; i < 4; i++)begin
            column_in[0] = state_in[(i*32+31)-:8];
            column_in[1] = state_in[(i*32+23)-:8];
            column_in[2] = state_in[(i*32+15)-:8];
            column_in[3] = state_in[(i*32+7)-:8];
            
            mix_column(column_in, column_out);      // Perform mix_column on current extracted column
            
            // Assign transformed column to output state
            state_out[(i*32+31)-:8] = column_out[0];
            state_out[(i*32+23)-:8] = column_out[1];
            state_out[(i*32+15)-:8] = column_out[2];
            state_out[(i*32+7)-:8] = column_out[3];
        end
    end
        
endmodule
