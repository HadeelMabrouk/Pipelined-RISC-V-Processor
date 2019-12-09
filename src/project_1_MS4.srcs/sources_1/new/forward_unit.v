`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2019 11:43:45 AM
// Design Name: 
// Module Name: forward_unit
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


/*module forward_unit(
    input [4:0] IDEXRegisterRs1,
     [4:0] IDEXRegisterRs2, [4:0] EXMEMRegisterRd, [4:0] MEMWBRegisterRd,
    input EXMEMRegWrite,  MEMWBRegWrite,
    output reg [1:0] forwardA, 
      output reg [1:0] forwardB
    );*/
    
 module forward_unit(
                      input [4:0] IDEXRegisterRs1, [4:0] IDEXRegisterRs2,[4:0] MEMWBRegisterRd,
                      input  MEMWBRegWrite,
                      output reg forwardA, 
                      output reg forwardB
                      );
           
    always @(*) begin
    //  if((EXMEMRegWrite && EXMEMRegisterRd != 0) &&(EXMEMRegisterRd == IDEXRegisterRs1))
    //          forwardA<=2'b10;
    //  else 
        
        if ((MEMWBRegWrite && MEMWBRegisterRd != 0)&& (MEMWBRegisterRd == IDEXRegisterRs1))  
                forwardA<=1'b1;
         else
                forwardA<=1'b0;
  // if ((EXMEMRegWrite && EXMEMRegisterRd != 0) &&(EXMEMRegisterRd == IDEXRegisterRs2))
  //              forwardB<=2'b10;
  //    else  
   if ((MEMWBRegWrite && MEMWBRegisterRd != 0)&& (MEMWBRegisterRd == IDEXRegisterRs2))   
                forwardB<=1'b1;
       else
             forwardB<=1'b0;    
    end
    
    
    
    
    
    
    
    
endmodule
