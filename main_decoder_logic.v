`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2026 16:02:28
// Design Name: 
// Module Name: main_decoder_logic
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

module main_decoder_logic(
    input [5:0] opcode_in,
    output reg dst_reg_sel, src_alu_sel, mem_to_reg_sel, reg_we, mem_re, mem_we, is_branch, is_jump,
    output reg [1:0] alu_mode 
);
 
always @(*) begin
    case(opcode_in)
        6'd0:  {dst_reg_sel, src_alu_sel, mem_to_reg_sel, reg_we, mem_re, mem_we, is_branch, is_jump, alu_mode} = 10'b1001000010;
        6'd35: {dst_reg_sel, src_alu_sel, mem_to_reg_sel, reg_we, mem_re, mem_we, is_branch, is_jump, alu_mode} = 10'b0111100000;
        6'd43: {dst_reg_sel, src_alu_sel, mem_to_reg_sel, reg_we, mem_re, mem_we, is_branch, is_jump, alu_mode} = 10'b0100010000;
        6'd4:  {dst_reg_sel, src_alu_sel, mem_to_reg_sel, reg_we, mem_re, mem_we, is_branch, is_jump, alu_mode} = 10'b0000001001;
        6'd2:  {dst_reg_sel, src_alu_sel, mem_to_reg_sel, reg_we, mem_re, mem_we, is_branch, is_jump, alu_mode} = 10'b0000000100;
        default: {dst_reg_sel, src_alu_sel, mem_to_reg_sel, reg_we, mem_re, mem_we, is_branch, is_jump, alu_mode} = 10'd0;
    endcase
end        
     
endmodule
