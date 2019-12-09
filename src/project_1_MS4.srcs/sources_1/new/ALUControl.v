`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2019 12:55:18 PM
// Design Name: 
// Module Name: ALU_Control_Unit
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


module ALU_Control_Unit(
    input [1:0] ALUOp,
    input [2:0] Inst1, 
    input Inst2,
    output reg[3:0] ALU_Sel
    );
    
    always @ (*) begin
    case (ALUOp)
        
        2'b01: begin   // Branch ,"Subtract"
            ALU_Sel <= 4'bb00_01;
        end 
        
		2'b00: begin // LW, SW  "add"
			ALU_Sel <= 4'b00_00;
		
		end
		
		
        2'b10: begin 
                      if (Inst1 == 0 && Inst2 ==0)  // ADD , ADDI 
                            ALU_Sel <= 4'b00_00; 
                      else
                      if (Inst1 == 0 && Inst2 ==1)  // SUB
                            ALU_Sel <= 4'b00_01;
					    else
						if (Inst1 == 3'b010)  // SLT , SLTI
						     ALU_Sel <= 4'b11_01;
					    else 
						if (Inst1 == 3'b011)  // SLTU , SLTIU
						     ALU_Sel <= 4'b11_11;	
                        else 
						if (Inst1 == 3'b100)  // XOR , XORI
							 ALU_Sel <= 4'b01_11;
						else 
						if (Inst1 == 3'b110)  // OR ,ORI
							 ALU_Sel <= 4'b01_00;
						else 
						if (Inst1 == 3'b111)   // AND , ANDI
						   ALU_Sel <= 4'b01_01;
						else
						if (Inst1 == 3'b001)  // SLL , SLLI
						   ALU_Sel <= 4'b10_00;	
						else
						if (Inst1 == 3'b101 && Inst2 ==0) // SRL , SRLI 
						   ALU_Sel <= 4'b10_01;	
                        else 
						// (Inst1 ==3'b101 && Inst2 ==1) //SRA , SRAI
							 ALU_Sel <= 4'b10_10;							   
               end 
               
        2'b11:
          begin 
                 ALU_Sel <= 4'b01_101;  // LUI
          end       
         endcase                
    end
endmodule

