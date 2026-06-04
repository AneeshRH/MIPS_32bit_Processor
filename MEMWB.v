`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2025 17:46:47
// Design Name: 
// Module Name: MEMWB
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


module MEMWB(input clk,input [31:0] read_data,alu_result,input[4:0] Dest,input RegWrite,Jump,MemtoReg,output [31:0] read_data_out,alu_result_out,output [4:0] Dest_out,output RegWrite_out,Jump_out,MemtoReg_out);
reg [31:0] read_data_reg,alu_result_reg;
reg [4:0] Dest_reg;
reg RegWrite_reg,Jump_reg,MemtoReg_reg;
initial {read_data_reg,alu_result_reg,Dest_reg,RegWrite_reg,Jump_reg,MemtoReg_reg} = 0;
always@(posedge clk)
begin
{read_data_reg,alu_result_reg,Dest_reg,RegWrite_reg,Jump_reg,MemtoReg_reg}<={read_data,alu_result,Dest, RegWrite,Jump,MemtoReg};
end
assign {read_data_out,alu_result_out,Dest_out,RegWrite_out,Jump_out,MemtoReg_out} = {read_data_reg,alu_result_reg,Dest_reg,RegWrite_reg,Jump_reg,MemtoReg_reg};
endmodule
