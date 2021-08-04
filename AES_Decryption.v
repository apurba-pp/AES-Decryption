`timescale 1ns / 1ps

module AES_Decrypter(CipherText, key, PlainText);  
    input wire[127:0] CipherText,key;          
    output reg [127:0] PlainText;
  
