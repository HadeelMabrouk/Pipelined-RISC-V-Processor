`timescale 1ns / 1ps
/*******************************************************************
*
* Module: SingleMemory.v
* Project: RISC-V FPGA Implementation and Testing
* Author: Hadeel Mabrouk - Zahraa Shehabeldin - Mohamed Samir  
* Description: Single Memory 
**********************************************************************/

module SingleMemory(
                    input clk,
                    input MemRead, 
                    input MemWrite,
                    input [9:0] Addr,
                    input [31:0] Data_in, 
                    input [2:0]flag,
                    output reg [31:0] Mem_out
                     );
                     
    // DATA MEMORY  & INSTRUCTION MEMORY
     reg [7:0] Mem [0:1023];   // 1K   DATA MEM BYTE ADDRESSABLE
     
     
   // INSTRUCTION MEMORY ASSIGNMENT  
     always @(*) 
     begin
            //if (MemRead) begin
                case (flag) 
                    3'b000: //lb 
                        Mem_out <= {{24{Mem[Addr][7]}},Mem[Addr]};
                    3'b001: //lh
                        Mem_out <= {{16{Mem[Addr+1][7]}},Mem[Addr+1], Mem[Addr]};
                    3'b010: //lw
                        Mem_out <= {Mem[Addr+3],  Mem[Addr + 2], Mem[Addr + 1], Mem[Addr]};
                    3'b100: //lbu
                        Mem_out <= {24'b0, Mem[Addr]};
                    default: //lhu
                        Mem_out <= {16'b0,Mem[Addr+1],Mem[Addr]};
                endcase 
       end
       
   // DATA MEMORY STORE      
    always@(posedge clk) begin 
        if (MemWrite) begin
            case (flag) 
                3'b000: //sb 
                      Mem[Addr] <= Data_in[7:0];
                3'b001: //sh
                    { Mem[Addr+1], Mem[Addr]} <= Data_in[15:0];
                3'b010: //sw
                    { Mem[Addr+3], Mem[Addr + 2],  Mem[Addr + 1], Mem[Addr]} <= Data_in;                
                default:
                    Mem[Addr] <= 8'b0;
            endcase
   
     end
    end
    
    
    initial begin
       //  $readmemh("singleCycleHexa.data",Mem);   // To test the Single Cylce Programs 
       // $readmemh("addImmTest.data",Mem);   // To test the Single Cylce Programs 
       // 
        
         // Working Programm  FOR To test the Single Cylce Programs 
       /*   {Mem[3],Mem[2],Mem[1],Mem[0]}=32'b001000000000_00000_010_00001_0000011 ; //lw x1, 512(x0) 0000 2083  //5
            {Mem[7],Mem[6],Mem[5],Mem[4]}=32'b001000000100_00000_010_00010_0000011 ; //lw x2, 516(x0)            //7
            {Mem[11],Mem[10],Mem[9],Mem[8]}=32'b001000001000_00000_010_00011_0000011 ; //lw x3, 520(x0)          //9
            {Mem[15],Mem[14],Mem[13],Mem[12]}=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2        //11
            {Mem[19],Mem[18],Mem[17],Mem[16]}=32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 2       //13
            {Mem[23],Mem[22],Mem[21],Mem[20]}=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2 //should be skipped 
            {Mem[27],Mem[26],Mem[25],Mem[24]}=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2       //17
            {Mem[31],Mem[30],Mem[29],Mem[28]}=32'b0010000_00101_00000_010_01100_0100011; //sw x5, 524(x0)        //19
            {Mem[35],Mem[34],Mem[33],Mem[32]}=32'b001000001100_00000_010_00110_0000011 ; //lw x6, 524(x0)        //21
            {Mem[39],Mem[38],Mem[37],Mem[36]}=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1     
            {Mem[43],Mem[42],Mem[41],Mem[40]}=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2 
            {Mem[47],Mem[46],Mem[45],Mem[44]}=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
            {Mem[51],Mem[50],Mem[49],Mem[48]}=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
            {Mem[55],Mem[54],Mem[53],Mem[52]}=32'b0000000_00000_00000_000_00000_1110011 ; //add x9, x0, x1*/
            
            
         // To test the Single Cylce Programs     (WORKING)
      /*   {Mem[3],Mem[2],Mem[1],Mem[0]}=32'b001000000000_00000_010_00001_0000011 ; //lw x1, 512(x0) 0000 2083  //5
         {Mem[7],Mem[6],Mem[5],Mem[4]}=32'b001000000100_00000_010_00010_0000011 ; //lw x2, 516(x0)            //7
         {Mem[11],Mem[10],Mem[9],Mem[8]}=32'b001000001000_00000_010_00011_0000011 ; //lw x3, 520(x0)          //9
         {Mem[15],Mem[14],Mem[13],Mem[12]}=32'b00000000_00110000_10000010_00010011; //addi x4,x1,3      //11
         {Mem[19],Mem[18],Mem[17],Mem[16]}=32'b00000000_01000001_10000010_10110011; //add x5,x3,x4      //13
      */   
   
     // To test the   XOR    (WORKING)
      /*     {Mem[3],Mem[2],Mem[1],Mem[0]}=32'b001000000000_00000_010_00001_0000011 ; //lw x1, 512(x0) 0000 2083  17
             {Mem[7],Mem[6],Mem[5],Mem[4]}=32'b001000000100_00000_010_00010_0000011 ; //lw x2, 516(x0)             9
             {Mem[11],Mem[10],Mem[9],Mem[8]}=32'b001000001000_00000_010_00011_0000011 ; //lw x3, 520(x0)           25
             {Mem[15],Mem[14],Mem[13],Mem[12]}=32'b00000000_00100000_11000010_00110011; // xor x4, x1, x2          24
             {Mem[19],Mem[18],Mem[17],Mem[16]}=32'b00000000_00100010_00000010_10110011; //add x5, x4 ,x2         33
         */
     
       // To test the   ORI , ANDI,     (WORKING)
            {Mem[3],Mem[2],Mem[1],Mem[0]}=32'b001000000000_00000_010_00001_0000011 ; //lw x1, 512(x0) 0000 2083  17
            {Mem[7],Mem[6],Mem[5],Mem[4]}=32'b001000000100_00000_010_00010_0000011 ; //lw x2, 516(x0)             9
            {Mem[11],Mem[10],Mem[9],Mem[8]}=32'b00000000_01010001_01100010_00010011 ; //ori x4,x2,5       13    
           {Mem[15],Mem[14],Mem[13],Mem[12]}=32'b00000000_01100010_01110010_10010011; // andi x5,x4,6     4  
           {Mem[19],Mem[18],Mem[17],Mem[16]}=32'b00000000_00010010_11000011_00010011; // xori x6, x5, 1    // 5
               
       Mem[512]=8'd17;  //0
       Mem[4+512]=8'd9;   //4
       Mem[8+512]=8'd25;  //8
       Mem[1+512]=8'd0;
       Mem[2+512]=8'd0;
       Mem[3+512]=8'd0;
       Mem[5+512]=8'd0;
       Mem[6+512]=8'd0;
       Mem[7+512]=8'd0;
       Mem[9+512]=8'd0;
       Mem[10+512]=8'd0;
       Mem[11+512]=8'd0;
       Mem[12+512]=8'd0;
       Mem[13+512]=8'd0;
       Mem[14+512]=8'd0;
       
         /*   Mem[512]=8'd0;  //0
              Mem[4+512]=8'd0;   //4
              Mem[8+512]=8'd0;  //8
              Mem[1+512]=8'd0;
              Mem[2+512]=8'd0;
              Mem[3+512]=8'd17;
              Mem[5+512]=8'd0;
              Mem[6+512]=8'd0;
              Mem[7+512]=8'd9;
              Mem[9+512]=8'd0;
              Mem[10+512]=8'd0;
              Mem[11+512]=8'd25;
              Mem[12+512]=8'd0;
              Mem[13+512]=8'd0;
              Mem[14+512]=8'd0;*/
       
      end 
endmodule
