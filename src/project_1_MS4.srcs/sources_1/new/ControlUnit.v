`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2019 12:12:08 PM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
       input [31:0] IF_ID_Inst, 
       input [4:0] Instruction,
       output reg  Branch, MemRead, MemtoReg,MemWrite, ALUSrc, RegWrite,JALR,JAL, AUIPC, ECALL,
       output reg [1:0] ALUOp  
    );
    
    
   always @ (*)
    begin 
    
    case (Instruction)
        
 // R-Format
        5'b01100: begin 
            Branch <= 0;
            MemRead <= 0 ;
            MemtoReg <= 0 ;
            ALUOp <= 2'b10;
            MemWrite <= 0;
            ALUSrc <= 0 ;
            RegWrite <= 1 ;
            JALR <= 0;
            JAL <= 0;
            AUIPC <= 0;
            ECALL <= 0;
        end 
        
        
 // LW
       5'b00000: begin 
           Branch <= 0;
           MemRead <= 1 ;
           MemtoReg <= 1;
           ALUOp <= 2'b00;
           MemWrite <= 0;
           ALUSrc <=1 ;
           RegWrite <= 1 ;
           JALR <= 0;
           JAL <= 0;
           AUIPC <= 0;
           ECALL <= 0;

       end 
       
 // SW
         5'b01000: begin 
             Branch <= 0;
             MemRead <= 0 ;
             MemtoReg <= 1'b0; //don't care
             ALUOp <= 2'b00;
             MemWrite <= 1;
             ALUSrc <=1 ;
             RegWrite <= 0 ;
             JALR <= 0;
             JAL <= 0;
             AUIPC <= 0;
             ECALL <= 0;
         end 
         
// BEQ
           5'b11000: begin 
               Branch <= 1;
               MemRead <= 0 ;
               MemtoReg <= 1'b0; //don't care
               ALUOp <= 2'b01; 
               MemWrite <= 0;
               ALUSrc <=0 ;
               RegWrite <= 0 ;
               JALR <= 0;
               JAL <= 0;
               AUIPC <= 0;
               ECALL <= 0;

           end 
// imm 
         5'b00100: begin 
                     Branch <= 0;
                     MemRead <= 0 ;
                     MemtoReg <= 1'b0;
                     ALUOp <= 2'b10; 
                     MemWrite <= 0;
                     ALUSrc <=1 ;
                     RegWrite <= 1 ;
                     JALR <= 0;
                     JAL <= 0;
                     AUIPC <= 0;
                     ECALL <= 0;
                     end 
 // LUI                      
         5'b01101: begin 
                       Branch <= 0;
                       MemRead <= 0 ;
                       MemtoReg <= 1'b0;
                       ALUOp <= 2'b11; 
                       MemWrite <= 0;
                       ALUSrc <=1 ;
                       RegWrite <= 1 ;
                       JALR <= 1;
                       JAL <= 0;
                       AUIPC <= 0;
                       ECALL <= 0;
                         end 
  // JAL                     
         5'b11011: begin 
                       Branch <= 0;
                       MemRead <= 0 ;
                       MemtoReg <= 1'b0;
                       ALUOp <= 2'b0; //don't care
                       MemWrite <= 0;
                       ALUSrc <=1 ;
                       RegWrite <= 1 ;
                       JALR <= 0;
                       JAL <= 1;
                       AUIPC <= 0;
                       ECALL <= 0;
                         end                

   // AUIPC                      
          5'b00101: begin 
                        Branch <= 0;
                        MemRead <= 0 ;
                        MemtoReg <= 1'b0;
                        ALUOp <= 2'b0; //don't care
                        MemWrite <= 0;
                        ALUSrc <=1 ;
                        RegWrite <= 1 ;
                        JALR <= 0;
                        JAL <= 0;
                        AUIPC <= 1;
                        ECALL <= 0;
                          end          
   // E Call                      
         5'b11100: begin 
         if (IF_ID_Inst[31:0] ==  32'b00000_00000_00000_00000_00000_1110011) begin 
                       Branch <= 0;
                       MemRead <= 0 ;
                       MemtoReg <= 1'b0;
                       ALUOp <= 2'b0; //don't care
                       MemWrite <= 0;
                       ALUSrc <=1 ;
                       RegWrite <= 1 ;
                       JALR <= 0;
                       JAL <= 0;
                       AUIPC <= 1;
                       ECALL <= 1;
                       end
                       end    
        default: begin
                      Branch <= 0;
                      MemRead <= 0 ;
                      MemtoReg <= 1'b0;
                      ALUOp <= 2'b00; 
                      MemWrite <= 0;
                      ALUSrc <=0 ;
                      RegWrite <= 0 ;
                      JALR <= 0;
                      JAL <= 0;
                      AUIPC <= 0;
                      ECALL <= 0;
                   end
    endcase
    
    end  
endmodule

