`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2019 04:51:09 PM
// Design Name: 
// Module Name: Memory_Counter
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

module MemoryCounter_tb( );
    reg clk;
    reg rst;
    wire counter;
    MemoryCounter ds( clk,rst, counter);
    
        always #10 clk <= ~clk;
    
   initial begin
   
        clk = 0;
rst=1;
#50
rst=0;
        end

endmodule