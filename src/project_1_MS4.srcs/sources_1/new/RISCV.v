// file: RISCV.v
// author: @cherifsalama

`timescale 1ns/1ns

module RISCV (
    input clk, 
    input rst, 
    input [1:0] ledSel, 
    input [3:0] ssdSel,
    output reg [15:0] leds, 
    output reg [12:0] ssd
         );
    wire stall;
    wire [7:0] cuMuxOut;
    wire [31:0] instMUX;
    wire [4:0] crtlMUX;
    wire orMUx;
    wire [31:0] PC_out, PCAdder_out, BranchAdder_out, PC_in, 
        RegR1, RegR2, RegW, ImmGen_out, Shift_out, ALUSrcMux_out, 
        ALU_out, Mem_out, Inst;
    wire Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, Zero;
    wire [1:0] ALUOp;
    wire [3:0] ALUSel;
    wire PCSrc;
    wire fA,fB;
    
    wire [31:0] IF_ID_PC, IF_ID_Inst, 
        ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, 
        EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, 
        MEM_WB_Mem_out, MEM_WB_ALU_out;
    wire [7:0] ID_EX_Ctrl;
    wire [4:0] EX_MEM_Ctrl;
    wire [1:0] MEM_WB_Ctrl;
    wire [3:0] ID_EX_Func;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd, EX_MEM_Rd, MEM_WB_Rd;
    wire EX_MEM_Zero;
    wire [31:0]fuout1,fuout2;
    wire cf,vf,sf;
    wire JALR,JAL, AUIPC;  
    wire EX_MEM_cf,EX_MEM_vf,EX_MEM_sf;
    wire [2:0] EX_MEM_Func;
    wire counter; // Memory counter
    
    wire [9:0] Mem_in; // Memory Input
    
    wire [31:0] IF_ID_PCAdder_out,ID_EX_PCAdder_out,EX_MEM_PCAdder_out,MEM_WB_PCAdder_out; // PC+4 
    wire [31:0] MEM_WB_BranchAddOut;
    
    wire [31:0] MUX_out_WData;
    wire ID_EX_JALR;
    wire [2:0] Inst_Func_3;
    wire [1:0] MemReadWrite;
    wire EX_MEM_bit30;
    wire ECALL;
    wire [2:0] PCADDEROP;
    wire [31:0] ID_EX_Inst;
    wire [31:0] pc_in_ECALL;
    
   
    
    // Memory Counter & Registers activator 
    MemoryCounter MC(.clk(clk),.rst(rst),.counter(counter));
     
    // *********************** Mem MUX **********************
    assign Mem_in = (counter)? ALU_out: PC_out; //EX_MEM_ALU_out
    
    // ******************** MUX for Instruction & Data Mem ******************
    assign Inst_Func_3 = (counter)? EX_MEM_Func: 3'b010;
    assign MemReadWrite = (counter) ? {EX_MEM_Ctrl[1],EX_MEM_Ctrl[0]}: 2'b10;
    
    // Single Memory 
    SingleMemory SM(.clk(clk),.MemRead(MemReadWrite[1]), .MemWrite(MemReadWrite[0]),
                    .Addr(Mem_in),.Data_in(EX_MEM_RegR2), .flag(Inst_Func_3),.Mem_out(Mem_out));
     
    //wire stall_fix;
    RegWLoad #(32) PC(clk,rst,counter,PC_in,PC_out);
    
 
    RegWLoad #(96) IF_ID(clk,rst,~counter,
                            {PC_out,Mem_out,PCAdder_out}, //Mem_out=Inst
                            {IF_ID_PC,IF_ID_Inst,IF_ID_PCAdder_out}
                            );

    RegWLoad #(188) ID_EX(clk,rst,counter,
                            {cuMuxOut,
                                IF_ID_PC,RegR1,RegR2,ImmGen_out,
                                IF_ID_Inst[30],IF_ID_Inst[14:12],
                                IF_ID_Inst[19:15],IF_ID_Inst[24:20],IF_ID_Inst[11:7],IF_ID_PCAdder_out,JALR},
                            {ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,ID_EX_Imm,
                                ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd,ID_EX_PCAdder_out,ID_EX_JALR}
                            );
    RegWLoad #(146) EX_MEM (clk,rst,~counter,
                            {ID_EX_Ctrl[7:3],
                                BranchAdder_out,Zero,cf,vf,sf,ALU_out,
                                fuout2,ID_EX_Rd,ID_EX_Func,ID_EX_PCAdder_out},
                            {EX_MEM_Ctrl,EX_MEM_BranchAddOut,EX_MEM_Zero,EX_MEM_cf,EX_MEM_vf,
                            EX_MEM_sf,EX_MEM_ALU_out,
                                EX_MEM_RegR2, EX_MEM_Rd,EX_MEM_bit30,EX_MEM_Func,EX_MEM_PCAdder_out}
                            );
    RegWLoad #(135) MEM_WB (clk,rst,counter,
                            {EX_MEM_Ctrl[4:3],Mem_out,EX_MEM_ALU_out,EX_MEM_Rd,EX_MEM_PCAdder_out,EX_MEM_BranchAddOut},
                            {MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Rd,MEM_WB_PCAdder_out,MEM_WB_BranchAddOut}
                            );

    //InstMem imem(rst,PC_out[7:2],Inst);
    
    //******************** MUX ECALL & Normal pc+4 Instruction *****************
   // Mux2_1  #(3) ECALL_MUX (.sel(ECALL),.in1(4),.in2(3'b0),.out(PCADDEROP)); 
    Mux2_1  #(32) ECALL_MUX (.sel(ECALL),.in1(4),.in2(3'b0),.out(PCADDEROP)); 
    
    // ******************* MUX JAlR/JAL, AUIPC, Mem_out ****************
    //  01 -> AUIPC,  10 -> JAL/JALR ,    00-> RegW           
    MUX_4x1_32Bits JMP_Inst (.A(RegW) ,.B(MEM_WB_PCAdder_out) ,.C(MEM_WB_BranchAddOut),
                             .load({JAL,AUIPC}),.MUX_out(MUX_out_WData));
    
    
    // ******************* PC + 4 *********************
    RippleAdder IncPC(PC_out,4,1'b0,PCAdder_out,);
    
    // ******************* Register File ****************
    RegFile rf(~clk,rst,MEM_WB_Ctrl[1],IF_ID_Inst[19:15],IF_ID_Inst[24:20]
              ,MEM_WB_Rd,MUX_out_WData,RegR1,RegR2);
              
    // ************************ Imm Generator ***************************         
    rv32_ImmGen ig(.IR(IF_ID_Inst),.Imm(ImmGen_out));
    
    //************ 2X1 MUX ALU & IMM *******************
    Mux2_1 #(32) aluSrcBMux(ID_EX_Ctrl[0],fuout2,ID_EX_Imm,ALUSrcMux_out);
    
    //**********************THE FORWARDING UNIT MUXs**************************
   // Mux4_1 #(32) mm1(fA,ID_EX_RegR1,RegW,EX_MEM_ALU_out,0,fuout1);
   // Mux4_1 #(32) mm2(fB,ID_EX_RegR2,RegW,EX_MEM_ALU_out,0,fuout2);
    Mux2_1  #(32) mm1 (.sel(fA),.in1(ID_EX_RegR1),.in2(RegW),.out(fuout1)); 
    Mux2_1  #(32) mm2 (.sel(fB),.in1(ID_EX_RegR2),.in2(RegW),.out(fuout2));
    
  
    //forward_unit FU1(ID_EX_Rs1,ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd,EX_MEM_Ctrl[4],  MEM_WB_Ctrl[1],fA,fB);
   
    // ********************Forwading Unit to Forward the Rd in MEM_WB Reg
    forward_unit FU1(.IDEXRegisterRs1(ID_EX_Rs1),.IDEXRegisterRs2(ID_EX_Rs2),.MEMWBRegisterRd(MEM_WB_Rd),
                 .MEMWBRegWrite( MEM_WB_Ctrl[1]), .forwardA(fA), .forwardB(fB));
                 
                 
                 
    //********************* MUX FLUSH OF BRANCH   PCSrc == Branch output **********************
     Mux2_1 #(8) CUMUX(PCSrc,{RegWrite,MemToReg,Branch,MemRead,MemWrite,ALUOp,ALUSrc},8'b0,cuMuxOut);
     
      //**********************THE HAZARD DETECTION UNIT********************
    // HDU hdu1(IF_ID_Inst[19:15],IF_ID_Inst[24:20],ID_EX_Rd,ID_EX_Ctrl[4],stall);
    //*******************************************************************
    //************************FLUSHING IMPLEMENTATION**********************
     //Mux2_1 #(5) crtlMux (PCSrc,ID_EX_Ctrl[7:3],5'b0,crtlMUX);
     //Mux2_1 #(32) InstMux (PCSrc,Inst,32'b00000000000000000000000000110011,instMUX);
    //assign orMUx=PCSrc;
    //ALU a1(ALUSel,fuout1,ALUSrcMux_out,ALU_out,Zero);
    
    // ************************** ALU *****************************
    prv32_ALU a1(.a(fuout1), .b(ALUSrcMux_out),.shamt(ID_EX_Rs2),.r(ALU_out),
        .cf(cf), .zf(Zero), .vf(vf), .sf(sf),.alufn(ALUSel));
    
    //ShiftLeft1 sh(ID_EX_Imm,Shift_out);
    
    RippleAdder OffsetPC(ID_EX_PC,ID_EX_Imm,1'b0,BranchAdder_out,);  // ID_EX_PC replaced with IF_ID_PC    && ID_EX_Imm replaced with ImmGen_out
    
    //    Mux2_1 #(32) pcSrcMux(PCSrc,PCAdder_out,EX_MEM_BranchAddOut,PC_in);
    // ******************* MUX for PC in4 4X1   A00=PC + 4 , C01=JALR , B10=PC in Branch 
     MUX_4x1_32Bits pcSrcMux(.A(PCAdder_out),.B(BranchAdder_out),.C(ALU_out),.load({PCSrc,ID_EX_JALR}),.MUX_out(PC_in));
    
  //  DataMem dmem(clk,rst,EX_MEM_Ctrl[1],EX_MEM_Ctrl[0],EX_MEM_ALU_out[7:2],EX_MEM_RegR2,Mem_out);
  
    // ****************** MUX for ALU & MemOut *********************
    Mux2_1 #(32) regWSrcMux(MEM_WB_Ctrl[0],MEM_WB_ALU_out,MEM_WB_Mem_out,RegW);
    
    //ControlUnit cu(IF_ID_Inst[6:4],Branch,MemRead,MemToReg,ALUOp,MemWrite,ALUSrc,RegWrite);
    
    Control_Unit cu(.IF_ID_Inst(IF_ID_Inst),.Instruction(IF_ID_Inst[6:2]),
           .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemToReg),.MemWrite(MemWrite), 
           .ALUSrc(ALUSrc), .RegWrite(RegWrite),.JALR(JALR),.JAL(JAL), .AUIPC(AUIPC),
           .ALUOp(ALUOp),.ECALL(ECALL));
    
    //ALUControl acu(ID_EX_Ctrl[2:1],ID_EX_Func[2:0],ID_EX_Func[3],ALUSel);
    
    // ***************************** ALU Control Unit ****************************
    ALU_Control_Unit acu( .ALUOp(ID_EX_Ctrl[2:1]),.Inst1(ID_EX_Func[2:0]), 
                          .Inst2(ID_EX_Func[3]),.ALU_Sel(ALUSel));
    // Branch CU output 
     //assign PCSrc = EX_MEM_Zero && EX_MEM_Ctrl[2];
     
     // *************************************** Branching UNIT **************************
     BranchCU branchCU(.branch(EX_MEM_Ctrl[2]),.func3(EX_MEM_Func),.zf(EX_MEM_Zero),.vf(EX_MEM_vf),
                                              .cf(EX_MEM_cf),.sf(EX_MEM_sf),.branch_out(PCSrc));


    always @(*) begin
        case(ledSel)
            0: leds <= Mem_out[15:0];
            1: leds <= Mem_out[31:16];
            2: leds <= {Branch, MemRead, MemToReg, ALUOp, MemWrite, 
                        ALUSrc, RegWrite, Zero, PCSrc, ALUSel};
            default: leds <= 0;            
        endcase
        
        case(ssdSel)
            0: ssd <= PC_out[12:0];
            1: ssd <= PCAdder_out[12:0]; 
            2: ssd <= BranchAdder_out[12:0]; 
            3: ssd <= PC_in[12:0];
            4: ssd <= RegR1[12:0]; 
            5: ssd <= RegR2[12:0]; 
            6: ssd <= RegW[12:0]; 
            7: ssd <= ImmGen_out[12:0]; 
            8: ssd <= ImmGen_out[12:0]; 
            9: ssd <= ALUSrcMux_out[12:0]; 
            10: ssd <= ALU_out[12:0]; 
            11: ssd <= Mem_out[12:0];
            default: ssd <= 0;
        endcase
    end
endmodule



