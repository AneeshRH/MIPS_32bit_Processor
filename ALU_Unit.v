`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2025 21:41:41
// Design Name: 
// Module Name: ALU_unit
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


module ALU_unit(
   input [3:0] alu_op,
   input [31:0] operand_1,operand_2,
   output [31:0] out,
   output zero
    );
    
   reg [31:0] out_d;  

   
 always@(*)begin
 case(alu_op)
 4'b0000: out_d=operand_1& operand_2;
 4'b0001: out_d=operand_1|operand_2;
 4'b0010: out_d=operand_1+ operand_2;
 4'b0110: out_d=operand_1-operand_2;
 4'b0111: out_d=operand_1>operand_2;
 4'b1100: out_d=~(operand_1|operand_2);
 default:out_d=operand_1+ operand_2;
 endcase
 end
 
 assign out=out_d;
 assign zero=(out==32'b0);
endmodule
