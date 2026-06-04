`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2025 16:12:46
// Design Name: 
// Module Name: alu_control
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


module alu_control(input [1:0] AluOp,input [5:0] funct,output reg [3:0] Alu_control);
always@(*) begin
casex({AluOp,funct})
8'b00xxxxxx:Alu_control = 4'b0010;
8'b01xxxxxx:Alu_control = 4'b0110;
8'b10100000:Alu_control = 4'b0010;
8'b10100010:Alu_control = 4'b0110;
8'b10100100:Alu_control = 4'b0000;
8'b10100101:Alu_control = 4'b0001;
8'b10101010:Alu_control = 4'b0111;
default:Alu_control = 4'b1111;
endcase
end
endmodule
