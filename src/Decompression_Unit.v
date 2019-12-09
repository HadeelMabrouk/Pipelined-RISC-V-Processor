/*******************************************************************
*
* Module: Decompression_Unit.v
* Project: riscv32ic
* Author: Ahmed Abouzaid
*
**********************************************************************/
`timescale 1ns / 1ns

module Decompression_Unit(input [15:0] inst_in, output reg[31:0] inst_out);

reg [4:0] rs1;
reg [4:0] rs2;
reg [4:0] rd;
reg [11:0] imm;
reg [19:0] imm20;
reg [4:0] shamt;
always @(*) begin 

        // -----> op = 00
        if((inst_in[1:0]==2'b00) && inst_in[15:13]== 3'b000) // C.ADDI4SPN ---> ADDI rd, x2, nzuimm[9:2]
        begin
        inst_out <= {2'b00,inst_in[12:11],inst_in[10:7],inst_in[5],inst_in[6],2'b00, 5'b00010, 3'b000, inst_in[4:2], 7'b0010011}; 
        end 
        
        else if((inst_in[1:0]==2'b00) && inst_in[15:13]== 3'b010) // C.LW  //
        begin
        rd <=;
        rs1<= inst_in [9:7];
        imm<= {5'b00000,inst_in[5],inst_in[12:10],inst_in[6],2'b00};
        inst_out <= {imm, rs1, 3'b010, inst_in[4:2], 7'b0000011}; 
        end
        
        else if(inst_in[1:0]==2'b00 && inst_in[15:13]== 3'b110) // C.SW //
        begin
        rs2 <= inst_in[4:2];
        rs1<= inst_in [9:7];
        imm<= {5'b00000,inst_in[5],inst_in[12:10],inst_in[6],2'b00};
        inst_out <= {imm[11:5], rs2, rs1, 3'b010, imm[4:0], 7'b0100011};
        end 
        
        //---- op = 01
        else if(inst_in== 2'b01 && inst_in[15:13]== 3'b0 && inst_in[11:7] == 5'b0) // C.NOP ---> addi x0, x0, 0
        begin
        inst_out <= {25'b0, 7'b0010011};
        end
        
        else if((inst_in[1:0]==2'b01) && inst_in[15:13]== 3'b000) // C.ADDI 
        begin
        rs1<= inst_in [11:7];
        imm<= {6'b0,inst_in[12],inst_in[6:2]};
        inst_out <= {imm[11:0], rs1, 3'b111, rs1, 7'b0010011}; 
        end
        else if((inst_in[1:0]==2'b01) && inst_in[15:13]== 3'b001) // C.JAL
        begin
        imm20<= {8'b0, inst_in[12], inst_in[8], inst_in[10:9], inst_in[6],inst_in[7], inst_in[2], inst_in[11], inst_in[5:3], 1'b0};
        inst_out <= {imm20[19], imm20[9:0], imm20[10], imm20[18:11], 5'b00001, 7'b1101111}; // I assumed RD=x1 //////////////////////////
        end
        
        else if((inst_in[1:0]==2'b01) && inst_in[15:13]== 3'b011 && inst_in[11:7] == 5'b00010) // C.ADDI16SP ---> addi x2, x2, nzimm[9:4]
        begin
        imm20<= {2'b0, inst_in[12], inst_in[4:3], inst_in[6], inst_in[2], inst_in[6], 4'b0};
        inst_out <= {imm, 5'b00010, 3'b000, 5'b00010, 7'b0010011};
        end
        
        else if((inst_in[1:0]==2'b01) && inst_in[15:13]== 3'b011) // C.LUI 
        begin
        imm20 <= {2'b0,inst_in[12],inst_in[6:2], 12'b0};
        inst_out <= {imm20, 5'b0, 7'b0110111}; 
        end
        else if((inst_in[1:0]==2'b01) && inst_in[15:13]== 3'b100 && inst_in[11:10] == 2'b00) // C.SRLI --> srli rd, rd, 64
        begin
        rd<= inst_in [9:7];
        shamt <= inst_in[6:2]; 
        inst_out <= {7'b0, shamt, rd, 3'b101, rd, 7'b0010011}; 
        end
        else if((inst_in[1:0]==2'b01) && inst_in[15:13]== 3'b100 && inst_in[11:10] == 2'b01) // C.SRAI --> SRAI rd, rd, shamt[5:0]
        begin
        rd<= inst_in [9:7];
        shamt <= inst_in[6:2]; 
        inst_out <= {7'b0100000, shamt, rd, 3'b101, rd, 7'b0010011}; 
        end        
        else if((inst_in[1:0]==2'b01) && inst_in[15:13]== 3'b100 && inst_in[11:10]==2'b10) // C.ANDI
        begin
        rs1 <= inst_in[9:7]; 
        imm <= {6'b0,inst_in[12],inst_in[6:2]};
        inst_out <= {imm, rs1, 3'b111, rs1, 7'b0010011};
        end
        else if((inst_in[1:0]==2'b01) && inst_in[15:13]== 3'b100 && inst_in[11:10]==2'b11 && inst_in[6:5] == 2'b00) // C.SUB
        begin    // 
        rs1 <= inst_in[9:7]; 
        rs2 <= inst_in[4:2]; 
        inst_out <= {7'b0100000, rs2, rs1, 3'b000, rs1, 7'b0110011};
        end
        
        else if((inst_in[1:0]==2'b01) && inst_in[15:13]== 3'b100 && inst_in[11:10]==2'b11 && inst_in[6:5] == 2'b01) // C.XOR
        begin
        rs1 <= inst_in[9:7]; 
        rs2 <= inst_in[4:2]; 
        inst_out <= {7'b0000000, rs2, rs1, 3'b100, rs1, 7'b0110011};
        end
        
        else if((inst_in[1:0]==2'b01) && inst_in[15:13]== 3'b100 && inst_in[11:10]==2'b11 && inst_in[6:5] == 2'b10) // C.OR
        begin
        rs1 <= inst_in[9:7]; 
        rs2 <= inst_in[4:2]; 
        inst_out <= {7'b0000000, rs2, rs1, 3'b110, rs1, 7'b0110011};
        end
        
        else if((inst_in[1:0]==2'b01) && inst_in[15:13]== 3'b100 && inst_in[11:10]==2'b11 && inst_in[6:5] == 2'b11) // C.AND
        begin
        rs1 <= inst_in[9:7]; 
        rs2 <= inst_in[4:2]; 
        inst_out <= {7'b0000000, rs2, rs1, 3'b111, rs1, 7'b0110011};
        end
        
        else if(inst_in[1:0]==2'b01 && inst_in[15:13] == 3'b101)  // C.J
        begin
        imm20<= {8'b0, inst_in[12], inst_in[8], inst_in[10:9], inst_in[6], inst_in[7], inst_in[2], inst_in[11], inst_in[5:3], 1'b0};
        inst_out <= {imm20[19], imm20[9:0], imm20[10], imm20[18:11], 5'b00000, 7'b1101111}; // jal x0, offset[11:1] /// CHECK!!!
        end
        
        else if(inst_in[1:0]==2'b01 && inst_in[15:13] == 3'b110)  // C.BEQZ ---> beq rs1, x0, offset[8:1]
        begin
        rs1 <= inst_in[9:7];
        imm <= {3'b0, inst_in[12], inst_in[6:5], inst_in[2], inst_in[11:10], inst_in[4:3], 1'b0};
        inst_out <= {imm[11], imm[9:4], 5'b0, rs1, 3'b0, imm[4:1], imm[11], 7'b1100011};
        end
        
        else if(inst_in[1:0]==2'b01 && inst_in[15:13] == 3'b111)  // C.BNEZ ---> bne rs1, x0, offset[8:1]
        begin
        rs1 <= inst_in[9:7];
        imm <= {3'b0, inst_in[12], inst_in[6:5], inst_in[2], inst_in[11:10], inst_in[4:3], 1'b0};
        inst_out <= {imm[11], imm[9:4], 5'b0, rs1, 3'b001, imm[4:1], imm[11], 7'b1100011};
        end
        // ---- OP = 10 
        else if(inst_in[1:0] == 2'b10 && inst_in[15:13]== 3'b000)  // C.SLLI
        begin
        rd <= inst_in[11:7];
        shamt <= inst_in[6:2];
        inst_out <= {7'b0, shamt, rd, 3'b001, rd, 7'b0010011}; // check again,I'm not sure either inst_in[12] is 0 or 1  
        end
        
        else if(inst_in[1:0]==2'b10 && inst_in [15:13] ==3'b010) // C.LWSP
        begin
        rd <= inst_in[11:7];
        imm<= {4'b0, inst_in[3:2], inst_in[12], inst_in[6:4], 2'b0};
        inst_out <= {imm, 5'b00010, 3'b010, rd, 7'b0000011};
        end
        
        else if(inst_in[1:0]==2'b10 && inst_in [15:13] ==3'b100 && inst_in[6:2]==5'b0 && inst_in[12]==1'b0) // C.JR
        begin
        rs1 <= inst_in[11:7];
        inst_out <= {12'b0, rs1 , 3'b0, 5'b0, 7'b1100111}; 
        end
        
        else if(inst_in[1:0] == 2'b10 && inst_in[15:13]== 3'b100&& inst_in[12] == 1'b1 && inst_in[6:2] == 5'b0 && inst_in[11:7] == 5'b0)  // C.EBREAK
        begin
        inst_out <= {12'b000000000001, 5'b0, 3'b0, 5'b0, 7'b1110011};
        end
        
        else if(inst_in[1:0] == 2'b10 && inst_in[15:13]== 3'b100&& inst_in[12] == 1'b1 && inst_in[6:2] == 5'b0 && inst_in[11:7] != 5'b0)  // C.JALR
        begin
        rs1<= inst_in[11:7];
        inst_out <= {12'b0, rs1, 3'b0, 5'b00001, 7'b1100111};
        end
        
        else if(inst_in[1:0] == 2'b10 && inst_in[15:13]== 3'b100&& inst_in[12] == 1'b1 && inst_in[6:2] != 5'b0 && inst_in[11:7] != 5'b0)  // C.ADD
        begin
        rs1<= inst_in[11:7];
        rs2 <= inst_in[6:2];
        inst_out <= {7'b0, rs2, rs1, 3'b0, rs1, 7'b0110011};
        end
        
         else if(inst_in[1:0]==2'b10 && inst_in [15:13] ==3'b110) // C.SWSP
         begin
         rs2 <= inst_in[6:2];
         imm<= {4'b0, inst_in[8:7], inst_in[12:9], 2'b0};
         inst_out <= {imm[11:5], rs2, 5'b00010, 3'b010, imm[4:0], 7'b0100011};
         end
        end


endmodule


