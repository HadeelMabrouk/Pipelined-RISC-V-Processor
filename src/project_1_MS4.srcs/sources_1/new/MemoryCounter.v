`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2019 06:47:41 PM
// Design Name: 
// Module Name: MemoryCounter
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


module MemoryCounter(input clk, input rst, output reg counter);

always @(posedge rst) begin
   counter<=0;
end

    always@(posedge clk)
    begin
       //if(rst) counter <=0;
       // else
        counter <= ~counter;
    end
    
endmodule
