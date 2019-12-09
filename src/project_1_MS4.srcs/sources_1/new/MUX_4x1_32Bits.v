`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2019 01:08:50 PM
// Design Name: 
// Module Name: MUX_4x1_32Bits
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


module MUX_4x1_32Bits(input [31:0] A ,[31:0] B ,[31:0] C  , input [1:0]load , output [31:0] MUX_out );

genvar i ; 
generate 
for (i=0 ; i<32 ; i = i+1 ) begin 
 MUX_4X1 MUX1 (.A( A[i]), .B(B[i]),.C(C[i]),.S(load),.O(MUX_out[i]));
end 
endgenerate
endmodule

 