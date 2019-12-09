`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2019 01:09:47 PM
// Design Name: 
// Module Name: MUX_4X1
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


module MUX_4X1(input A, B, C, input [1:0] S, output reg O);
// C01 -> AUIPC,  B10 -> JAL/JALR ,    A00-> rd
always @(*) begin
 
 if (S == 2'b00)   // PC + 4
      O <= A;
  else
  if (S == 2'b10)  // PC in Branch 
       O <= B;
  else 
  if (S == 2'b01) //  JALR
      O <= C;
    end 

endmodule