`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2019 02:47:58 PM
// Design Name: 
// Module Name: BranchCU
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


module BranchCU(
    input  branch,
    input [2:0] func3,
    input zf,
    input vf,
    input cf,
    input sf,
    output reg branch_out
    );
    
    always @(*) begin
        if((branch & zf & (func3==3'b000))||
        (branch & !zf & (func3==3'b001))||
        (branch & (sf!=vf) & (func3==3'b100))
        ||(branch & (sf==vf) & (func3==3'b101))
        ||(branch & (~cf) & (func3==3'b110)
        ||(branch & (cf) & (func3==3'b111))))
            branch_out<=1;
        else
            branch_out<=0;                 
    end
endmodule
