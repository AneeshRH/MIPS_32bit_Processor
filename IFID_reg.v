`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2026 23:17:13
// Design Name: 
// Module Name: pipeline_reg_if_id
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

module pipeline_reg_if_id(
    input [31:0] mem_instr_in, next_pc_in,
    input clk_signal,
    output [31:0] instr_fwd_out, pc_fwd_out
);

reg [31:0] reg_instr, reg_pc;

initial {reg_instr, reg_pc} = 64'b0;

always @(posedge clk_signal) begin
    reg_instr <= mem_instr_in;
    reg_pc <= next_pc_in;
end

assign instr_fwd_out = reg_instr;
assign pc_fwd_out = reg_pc;

endmodule
