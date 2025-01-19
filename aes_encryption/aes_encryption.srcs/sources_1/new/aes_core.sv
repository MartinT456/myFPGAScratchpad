`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Written by: Martin Tran
// 
// Create Date: 01/18/2025 
// Design Name: 
// Module Name: aes_core
// Project Name: aes_encryption
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


module aes_core(
    input logic clk,
    input logic reset,
    input logic [127:0] plaintxt,        // plaintext input
    input logic [127:0] key,             // encyption key
    input logic [127:0] ciphertxt        // ciphertext output
    );
    
    logic [127:0] state; // encryption state
    logic [127:0] round_keys [0:10]; // 11 keys for AES-128
    int round; // keeping track of current round
    
    ///// TODO: key expansion, sub bytes, shift rows, mix columns 
    
endmodule