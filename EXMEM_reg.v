`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2025 17:33:03
// Design Name: 
// Module Name: EXMEM_reg
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


module EXMEM_reg(
input MemtoReg,RegWrite,MemRead,MemWrite,Branch,zero,clk,
input [31:0] add_result,alu_result,read_data_2, 
input[4:0] register_dest,

output MemtoReg_out,RegWrite_out,MemRead_out,MemWrite_out,Branch_out,zero_out,
output[31:0]add_result_out,alu_result_out,read_data_2_out,
output[4:0] register_dest_out
    );
reg[5:0] a;
reg[31:0] b,c,d;
reg[4:0] e; 
initial {a,b,c,d,e} = 107'b0;   
always@(posedge clk)begin
a<={MemtoReg,RegWrite,MemRead,MemWrite,Branch,zero};
b<=add_result;
c<=alu_result;
d<=read_data_2;
e<=register_dest;
end
assign {MemtoReg_out,RegWrite_out,MemRead_out,MemWrite_out,Branch_out,zero_out}=a;
assign add_result_out=b;
assign alu_result_out=c;
assign read_data_2_out=d;
assign register_dest_out=e;
endmodule
