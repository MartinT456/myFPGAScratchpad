`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin Tran
// 
// Create Date: 01/18/2025 
//
// Module Name: key_expansion
// Project Name: aes_encryption
//
// Description: 
// 
// This file implements the key_expansion module, a component of the AES-128
// encryption algorithm. The key_expansion module generates 11 round keys, each 128 bits long, 
// from an initial 128-bit cipher key, following the AES key schedule specification. These
// round keys are used during the encryption process to perform transformations on the plaintext.
//
// Interface:
//
// Inputs:
// - clk: A clock signal driving the module.
// - reset: Active-high reset signal that clears all round keys.
// - key:The 128-bit cipher key used to derive the round keys.
//
// Outputs:
// - round_keys: Array of 11 round keys, each 128 bits.
//////////////////////////////////////////////////////////////////////////////////


module key_expansion(
    input logic clk,
    input logic reset,
    input logic [127:0] key,
    output logic [127:0] round_keys [0:10]
    );
    
    logic [31:0] tmp;
    

    // Generates round constant, modifying first byte for each round key
    // https://en.wikipedia.org/wiki/AES_key_schedule
    function logic [31:0] rcon(input int round);
        case (round)
            1: rcon = 32'h01_00_00_00;
            2: rcon = 32'h02_00_00_00;
            3: rcon = 32'h04_00_00_00;
            4: rcon = 32'h08_00_00_00;
            5: rcon = 32'h10_00_00_00;
            6: rcon = 32'h20_00_00_00;
            7: rcon = 32'h40_00_00_00;
            8: rcon = 32'h80_00_00_00;
            9: rcon = 32'h1b_00_00_00;
            10: rcon = 32'h36_00_00_00;
            default: rcon = 32'h00_00_00_00;
        endcase
    endfunction
   
    
    function logic [7:0] sbox(input logic [7:0] byte_in);
    
        logic [7:0] sbox_lookup [0:255] = '{
            8'h63, 8'h7c, 8'h77, 8'h7b, 8'hf2, 8'h6b, 8'h6f, 8'hc5,  // 0x00-0x07
            8'h30, 8'h01, 8'h67, 8'h2b, 8'hfe, 8'hd7, 8'hab, 8'h76,  // 0x08-0x0f
            8'hca, 8'h82, 8'hc9, 8'h7d, 8'hfa, 8'h59, 8'h47, 8'hf0,  // 0x10-0x17
            8'had, 8'hd4, 8'ha2, 8'haf, 8'h9c, 8'ha4, 8'h72, 8'hc0,  // 0x18-0x1f
            8'hb7, 8'hfd, 8'h93, 8'h26, 8'h36, 8'h3f, 8'hf7, 8'hcc,  // 0x20-0x27
            8'h34, 8'ha5, 8'he5, 8'hf1, 8'h71, 8'hd8, 8'h31, 8'h15,  // 0x28-0x2f
            8'h04, 8'hc7, 8'h23, 8'hc3, 8'h18, 8'h96, 8'h05, 8'h9a,  // 0x30-0x37
            8'h07, 8'h12, 8'h80, 8'he2, 8'heb, 8'h27, 8'hb2, 8'h75,  // 0x38-0x3f
            8'h09, 8'h83, 8'h2c, 8'h1a, 8'h1b, 8'h6e, 8'h5a, 8'ha0,  // 0x40-0x47
            8'h52, 8'h3b, 8'hd6, 8'hb3, 8'h29, 8'he3, 8'h2f, 8'h84,  // 0x48-0x4f
            8'h53, 8'hd1, 8'h00, 8'hed, 8'h20, 8'hfc, 8'hb1, 8'h5b,  // 0x50-0x57
            8'h6a, 8'hcb, 8'hbe, 8'h39, 8'h4a, 8'h4c, 8'h58, 8'hcf,  // 0x58-0x5f
            8'hd0, 8'hef, 8'haa, 8'hfb, 8'h43, 8'h4d, 8'h33, 8'h85,  // 0x60-0x67
            8'h45, 8'hf9, 8'h02, 8'h7f, 8'h50, 8'h3c, 8'h9f, 8'ha8,  // 0x68-0x6f
            8'h51, 8'ha3, 8'h40, 8'h8f, 8'h92, 8'h9d, 8'h38, 8'hf5,  // 0x70-0x77
            8'hbc, 8'hb6, 8'hda, 8'h21, 8'h10, 8'hff, 8'hf3, 8'hd2,  // 0x78-0x7f
            8'hcd, 8'h0c, 8'h13, 8'hec, 8'h5f, 8'h97, 8'h44, 8'h17,  // 0x80-0x87
            8'hc4, 8'ha7, 8'h7e, 8'h3d, 8'h64, 8'h5d, 8'h19, 8'h73,  // 0x88-0x8f
            8'h60, 8'h81, 8'h4f, 8'hdc, 8'h22, 8'h2a, 8'h90, 8'h88,  // 0x90-0x97
            8'h46, 8'hee, 8'hb8, 8'h14, 8'hde, 8'h5e, 8'h0b, 8'hdb,  // 0x98-0x9f
            8'he0, 8'h32, 8'h3a, 8'h0a, 8'h49, 8'h06, 8'h24, 8'h5c,  // 0xa0-0xa7
            8'hc2, 8'hd3, 8'hac, 8'h62, 8'h91, 8'h95, 8'he4, 8'h79,  // 0xa8-0xaf
            8'he7, 8'hc8, 8'h37, 8'h6d, 8'h8d, 8'hd5, 8'h4e, 8'ha9,  // 0xb0-0xb7
            8'h6c, 8'h56, 8'hf4, 8'hea, 8'h65, 8'h7a, 8'hae, 8'h08,  // 0xb8-0xbf
            8'hba, 8'h78, 8'h25, 8'h2e, 8'h1c, 8'ha6, 8'hb4, 8'hc6,  // 0xc0-0xc7
            8'he8, 8'hdd, 8'h74, 8'h1f, 8'h4b, 8'hbd, 8'h8b, 8'h8a,  // 0xc8-0xcf
            8'h70, 8'h3e, 8'hb5, 8'h66, 8'h48, 8'h03, 8'hf6, 8'h0e,  // 0xd0-0xd7
            8'h61, 8'h35, 8'h57, 8'hb9, 8'h86, 8'hc1, 8'h1d, 8'h9e,  // 0xd8-0xdf
            8'he1, 8'hf8, 8'h98, 8'h11, 8'h69, 8'hd9, 8'h8e, 8'h94,  // 0xe0-0xe7
            8'h9b, 8'h1e, 8'h87, 8'he9, 8'hce, 8'h55, 8'h28, 8'hdf,  // 0xe8-0xef
            8'h8c, 8'ha1, 8'h89, 8'h0d, 8'hbf, 8'he6, 8'h42, 8'h68,  // 0xf0-0xf7
            8'h41, 8'h99, 8'h2d, 8'h0f, 8'hb0, 8'h54, 8'hbb, 8'h16   // 0xf8-0xff             
        };
        sbox = sbox_lookup[byte_in];
    endfunction
    
     
    function logic [31:0] subword(input logic [31:0] word);
        logic [7:0] sbox_byte;
        logic [7:0] byte_in; // temp veriable for each byte
 
        for (int j = 0; j < 4; j++) begin
            // Perform S-Box substitution
            byte_in = word[j*8+:8];

            subword[j*8+:8] = sbox(byte_in);
        end
    endfunction

    always_comb begin
    
        round_keys[0] = key; // Initial key
        for (int i = 1; i < 11; i = i + 1) begin
        // https://en.wikipedia.org/wiki/AES_key_schedule#/media/File:AES-Key_Schedule_128-bit_key.svg
            tmp = subword({round_keys[i-1][23:0], round_keys[i-1][31:24]}) ^ rcon(i); // rotate word, take subword, XOR with round constant
            round_keys[i][127:96] = round_keys[i-1][127:96] ^ tmp;
            round_keys[i][95:64] = round_keys[i-1][95:64] ^ round_keys[i][127:96];
            round_keys[i][63:32] = round_keys[i-1][63:32] ^ round_keys[i][95:64];
            round_keys[i][31:0] = round_keys[i-1][31:0] ^ round_keys[i][63:32];
        end
    end
    /*
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 11; i = i + 1)
                round_keys[i] <= 128'b0;      // Clear round keys on reset
        end else begin
            round_keys[0] <= key; // Initial key
            for (i = 1; i < 11; i = i + 1) begin
            // https://en.wikipedia.org/wiki/AES_key_schedule#/media/File:AES-Key_Schedule_128-bit_key.svg
                tmp = subword({round_keys[i-1][23:0], round_keys[i-1][31:24]}) ^ rcon(i); // rotate word, take subword, XOR with round constant
                round_keys[i][127:96] = round_keys[i-1][127:96] ^ tmp;
                round_keys[i][95:64] = round_keys[i-1][95:64] ^ round_keys[i][127:96];
                round_keys[i][63:32] = round_keys[i-1][63:32] ^ round_keys[i][95:64];
                round_keys[i][31:0] = round_keys[i-1][31:0] ^ round_keys[i][63:32];
            end
        end
    end
    */
    
endmodule
