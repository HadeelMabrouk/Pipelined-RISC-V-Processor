// file: RISCV_tb.v
// author: @cherifsalama
// Testbench for RISCV

`timescale 1ns/1ns

module RISCV_tb;

	//Inputs
	reg clk;
	reg rst;
	reg [1: 0] ledSel;
	reg [3: 0] ssdSel;

	//Outputs
	wire [15: 0] leds;
	wire [12: 0] ssd;

    reg [4:0]i;

	//Instantiation of Unit Under Test
	RISCV uut (
		.clk(clk),
		.rst(rst),
		.ledSel(ledSel),
		.ssdSel(ssdSel),
		.leds(leds),
		.ssd(ssd)
	);

    always #50 clk = ~clk;

	initial begin
	//Inputs initialization
		clk = 0;
		rst = 0;
		i=0;
		ledSel = 0;
		ssdSel = 0;

	//Wait for the reset
		#51 rst=1;
		#4 rst = 0;
        for(i=0;i<40;i=i+1) begin
		//#35 ssdSel = 6; ledSel = 0;
		//#65;
		#35 ssdSel = 0; ledSel = 0; 
        #5 ssdSel = 1; 
        #5 ssdSel = 2; 
        #5 ssdSel = 3;
        #5 ssdSel = 4;
        #5 ssdSel = 5; ledSel = 1;
        #5 ssdSel = 6;
        #5 ssdSel = 7;
        #5 ssdSel = 8;
        #5 ssdSel = 9;
        #5 ssdSel = 10;
        #5 ssdSel = 11; ledSel = 2;
        #10;
        end

	end

endmodule

