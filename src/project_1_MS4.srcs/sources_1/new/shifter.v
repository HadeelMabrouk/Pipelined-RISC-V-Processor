`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2019 03:29:22 PM
// Design Name: 
// Module Name: shifter
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


module shifter(
    input [31:0] a,
    input [4:0] shamt,
    input [1:0] type,
    output reg [31:0] r
    );
    //MSB=func7 LSB=MSB func3
    always @(*) begin
        if(type==2'b00) //shift left
            r <=  a<<shamt;
        else if(type==2'b01) //shift right logical
            r <=  a>>shamt;
        else //shift right arithmatic
            r<= a>>>shamt;   
    end
endmodule
