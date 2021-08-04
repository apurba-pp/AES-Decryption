`timescale 1ns / 1ps

module AES_Decrypter(CipherText, key, PlainText);  
    input wire[127:0] CipherText,key;          
    output reg [127:0] PlainText;
  

    
     // Inverse Mix Column Transformation
    function [7 : 0] mul_2(input [7 : 0] in);
        begin
            mul_2 = {in[6 : 0], 1'b0} ^ (8'h1b & {8{in[7]}});
        end
    endfunction 
    
    function [7 : 0] mul_4(input [7 : 0] in);
        begin
            mul_4 = mul_2(mul_2(in));
        end
    endfunction 
    
    function [7 : 0] mul_8(input [7 : 0] in);
        begin
            mul_8 = mul_2(mul_4(in));
        end
    endfunction 
    
    function [7 : 0] mul_9(input [7 : 0] in);
        begin
            mul_9 = mul_8(in) ^ in;
        end
    endfunction 
    
    function [7 : 0] mul_11(input [7 : 0] in);
        begin
            mul_11 = mul_8(in) ^ mul_2(in) ^ in;
        end
    endfunction 
    
    function [7 : 0] mul_13(input [7 : 0] in);
        begin
            mul_13 = mul_8(in) ^ mul_4(in) ^ in;
        end
    endfunction 
    
    function [7 : 0] mul_14(input [7 : 0] in);
        begin
            mul_14 = mul_8(in) ^ mul_4(in) ^ mul_2(in);
        end
    endfunction 
    
    function [31 : 0] inv_mixc(input [31 : 0] c);
        reg [7 : 0] b0, b1, b2, b3;
        reg [7 : 0] mb0, mb1, mb2, mb3;
        begin
            b0 = c[31 : 24];
            b1 = c[23 : 16];
            b2 = c[15 : 08];
            b3 = c[07 : 00];
    
            mb0 = mul_14(b0) ^ mul_11(b1) ^ mul_13(b2) ^ mul_9(b3);
            mb1 = mul_9(b0) ^ mul_14(b1) ^ mul_11(b2) ^ mul_13(b3);
            mb2 = mul_13(b0) ^ mul_9(b1) ^ mul_14(b2) ^ mul_11(b3);
            mb3 = mul_11(b0) ^ mul_13(b1) ^ mul_9(b2) ^ mul_14(b3);
    
            inv_mixc = {mb0, mb1, mb2, mb3};
        end
    endfunction
    
    function [127 : 0] inv_mixcolumns(input [127 : 0] info);
        reg [31 : 0] c0, c1, c2, c3;
        reg [31 : 0] cs0, cs1, cs2, cs3;
        begin
            c0 = info[127 : 096];
            c1 = info[095 : 064];
            c2 = info[063 : 032];
            c3 = info[031 : 000];
    
            cs0 = inv_mixc(c0);
            cs1 = inv_mixc(c1);
            cs2 = inv_mixc(c2);
            cs3 = inv_mixc(c3);
    
            inv_mixcolumns = {cs0, cs1, cs2, cs3};
        end
    endfunction
