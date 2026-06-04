`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2025 23:38:01
// Design Name: 
// Module Name: IDEX
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


module IDEX(input clk,input[31:0]read_data1,read_data2,immediate,pc_addr,input[4:0] IFID_REGRS,IFID_REGRT,IFID_REGRD,input [1:0]alu_op,input RegDst, AluSrc, MemtoReg,RegWrite,Memread, MemWrite, Branch,Jump,output [31:0]read_data1_out,read_data2_out,immediate_out,pc_addr_out,output [4:0] IFID_REGRS_out,IFID_REGRT_out,IFID_REGRD_out,output [1:0]alu_op_out,output RegDst_out, AluSrc_out, MemtoReg_out,RegWrite_out,Memread_out, MemWrite_out, Branch_out,Jump_out);
reg [31:0]read_data1_reg,read_data2_reg,immediate_reg,pc_addr_reg;
reg [4:0] IFID_REGRS_reg,IFID_REGRT_reg,IFID_REGRD_reg;
reg [1:0] alu_op_reg;
reg RegDst_reg, AluSrc_reg, MemtoReg_reg,RegWrite_reg,Memread_reg, MemWrite_reg, Branch_reg,Jump_reg;
initial {read_data1_reg,read_data2_reg,immediate_reg,pc_addr_reg,IFID_REGRS_reg,IFID_REGRT_reg,alu_op_reg,RegDst_reg, AluSrc_reg, MemtoReg_reg,RegWrite_reg,Memread_reg, MemWrite_reg, Branch_reg,Jump_reg,IFID_REGRD_reg}=0;
always@(posedge clk) begin
{read_data1_reg,read_data2_reg,immediate_reg,pc_addr_reg,IFID_REGRS_reg,IFID_REGRT_reg,alu_op_reg,RegDst_reg, AluSrc_reg, MemtoReg_reg,RegWrite_reg,Memread_reg, MemWrite_reg, Branch_reg,Jump_reg,IFID_REGRD_reg}<={read_data1,read_data2,immediate,pc_addr,IFID_REGRS,IFID_REGRT,alu_op,RegDst, AluSrc, MemtoReg,RegWrite,Memread, MemWrite, Branch,Jump,IFID_REGRD};
end
assign {read_data1_out,read_data2_out,immediate_out,pc_addr_out,IFID_REGRS_out,IFID_REGRT_out,IFID_REGRD_out,alu_op_out,RegDst_out, AluSrc_out, MemtoReg_out,RegWrite_out,Memread_out, MemWrite_out, Branch_out,Jump_out}={read_data1_reg,read_data2_reg,immediate_reg,pc_addr_reg,IFID_REGRS_reg,IFID_REGRT_reg,IFID_REGRD_reg,alu_op_reg,RegDst_reg, AluSrc_reg, MemtoReg_reg,RegWrite_reg,Memread_reg, MemWrite_reg, Branch_reg,Jump_reg};
endmodule
