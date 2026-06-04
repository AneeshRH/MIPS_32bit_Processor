`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2025 23:17:13
// Design Name: 
// Module Name: IFID_reg
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


module IFID_reg(
input [31:0] instruction_memory, pc_next,
input clk,
output [31:0] instruction_out, pc_out
    );
reg [31:0] a,b;
initial {a,b} = 64'b0;
always@(posedge clk) begin
a<=instruction_memory;
b<=pc_next;
end
assign instruction_out=a;
assign pc_out=b;
endmodule
