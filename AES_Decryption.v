`timescale 1ns / 1ps

module AES_Decrypter(CipherText, key, PlainText);  
    input wire[127:0] CipherText,key;          
    output reg [127:0] PlainText;
    // Add Round Key Transformation
    function [127:0] Add_Round_key(input [127:0] State,input [127:0]  Round_key);
        begin
        Add_Round_key = State ^ Round_key;
        end
    endfunction 
    
    // Inverse Shift Row Transformation
    function [127 : 0] Inv_ShiftRow(input [127 : 0] state);
        reg [31 : 0] c0, c1, c2, c3;
        reg [31 : 0] sc0, sc1, sc2, sc3;
        begin
            c0 = state[127 : 096];
            c1 = state[095 : 064];
            c2 = state[063 : 032];
            c3 = state[031 : 000];
    
            sc0 = {c0[31 : 24], c3[23 : 16], c2[15 : 08], c1[07 : 00]};
            sc1 = {c1[31 : 24], c0[23 : 16], c3[15 : 08], c2[07 : 00]};
            sc2 = {c2[31 : 24], c1[23 : 16], c0[15 : 08], c3[07 : 00]};
            sc3 = {c3[31 : 24], c2[23 : 16], c1[15 : 08], c0[07 : 00]};
            
            Inv_ShiftRow = {sc0, sc1, sc2, sc3};
        end
    endfunction