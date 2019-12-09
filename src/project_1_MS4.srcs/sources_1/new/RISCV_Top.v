// file: RISCV_Top.v
// author: @cherifsalama

`timescale 1ns/1ns

module RISCV_Top (
    input clk, 
    input rclk, 
    input rst, 
    input [1:0] ledSel, 
    input [3:0] ssdSel,
    output [15:0] led, 
    output [3:0] an, 
    output [6:0] seg
);

    wire [12:0] ssd;

    RISCV rv(rclk,rst,ledSel,ssdSel,led,ssd);
    SSDDriver sd(clk,ssd,an,seg);
endmodule

