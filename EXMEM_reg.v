`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2026 17:33:03
// Design Name: 
// Module Name: pipeline_reg_ex_mem
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

module pipeline_reg_ex_mem(
    input ctrl_mem2reg_in, ctrl_reg_wr_in, ctrl_mem_rd_in, ctrl_mem_wr_in, ctrl_branch_in, alu_zero_in, clock_sig,
    input [31:0] br_target_in, alu_res_in, val_rt_in, 
    input [4:0] dest_reg_idx_in,

    output ctrl_mem2reg_out, ctrl_reg_wr_out, ctrl_mem_rd_out, ctrl_mem_wr_out, ctrl_branch_out, alu_zero_out,
    output [31:0] br_target_out, alu_res_out, val_rt_out,
    output [4:0] dest_reg_idx_out
);

reg [5:0] ctrl_sigs_ff;
reg [31:0] br_target_ff, alu_res_ff, val_rt_ff;
reg [4:0] dest_reg_idx_ff; 

initial {ctrl_sigs_ff, br_target_ff, alu_res_ff, val_rt_ff, dest_reg_idx_ff} = 107'b0;   

always @(posedge clock_sig) begin
    ctrl_sigs_ff <= {ctrl_mem2reg_in, ctrl_reg_wr_in, ctrl_mem_rd_in, ctrl_mem_wr_in, ctrl_branch_in, alu_zero_in};
    br_target_ff <= br_target_in;
    alu_res_ff <= alu_res_in;
    val_rt_ff <= val_rt_in;
    dest_reg_idx_ff <= dest_reg_idx_in;
end

assign {ctrl_mem2reg_out, ctrl_reg_wr_out, ctrl_mem_rd_out, ctrl_mem_wr_out, ctrl_branch_out, alu_zero_out} = ctrl_sigs_ff;
assign br_target_out = br_target_ff;
assign alu_res_out = alu_res_ff;
assign val_rt_out = val_rt_ff;
assign dest_reg_idx_out = dest_reg_idx_ff;

endmodule
