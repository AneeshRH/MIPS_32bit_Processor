`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2026 23:38:01
// Design Name: 
// Module Name: pipeline_reg_id_ex
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

module pipeline_reg_id_ex(
    input clock_sig,
    input [31:0] val_rs, val_rt, imm_ext, prog_cnt,
    input [4:0] id_rs_idx, id_rt_idx, id_rd_idx,
    input [1:0] ctrl_alu_op,
    input c_reg_dst, c_alu_src, c_mem2reg, c_reg_wr, c_mem_rd, c_mem_wr, c_br, c_jmp,
    output [31:0] val_rs_ex, val_rt_ex, imm_ext_ex, prog_cnt_ex,
    output [4:0] id_rs_idx_ex, id_rt_idx_ex, id_rd_idx_ex,
    output [1:0] ctrl_alu_op_ex,
    output c_reg_dst_ex, c_alu_src_ex, c_mem2reg_ex, c_reg_wr_ex, c_mem_rd_ex, c_mem_wr_ex, c_br_ex, c_jmp_ex
);

reg [31:0] val_rs_ff, val_rt_ff, imm_ext_ff, prog_cnt_ff;
reg [4:0] id_rs_idx_ff, id_rt_idx_ff, id_rd_idx_ff;
reg [1:0] ctrl_alu_op_ff;
reg c_reg_dst_ff, c_alu_src_ff, c_mem2reg_ff, c_reg_wr_ff, c_mem_rd_ff, c_mem_wr_ff, c_br_ff, c_jmp_ff;

initial begin
    {val_rs_ff, val_rt_ff, imm_ext_ff, prog_cnt_ff, id_rs_idx_ff, id_rt_idx_ff, ctrl_alu_op_ff, c_reg_dst_ff, c_alu_src_ff, c_mem2reg_ff, c_reg_wr_ff, c_mem_rd_ff, c_mem_wr_ff, c_br_ff, c_jmp_ff, id_rd_idx_ff} = 0;
end

always @(posedge clock_sig) begin
    {val_rs_ff, val_rt_ff, imm_ext_ff, prog_cnt_ff, id_rs_idx_ff, id_rt_idx_ff, ctrl_alu_op_ff, c_reg_dst_ff, c_alu_src_ff, c_mem2reg_ff, c_reg_wr_ff, c_mem_rd_ff, c_mem_wr_ff, c_br_ff, c_jmp_ff, id_rd_idx_ff} <= 
    {val_rs, val_rt, imm_ext, prog_cnt, id_rs_idx, id_rt_idx, ctrl_alu_op, c_reg_dst, c_alu_src, c_mem2reg, c_reg_wr, c_mem_rd, c_mem_wr, c_br, c_jmp, id_rd_idx};
end

assign {val_rs_ex, val_rt_ex, imm_ext_ex, prog_cnt_ex, id_rs_idx_ex, id_rt_idx_ex, id_rd_idx_ex, ctrl_alu_op_ex, c_reg_dst_ex, c_alu_src_ex, c_mem2reg_ex, c_reg_wr_ex, c_mem_rd_ex, c_mem_wr_ex, c_br_ex, c_jmp_ex} = 
       {val_rs_ff, val_rt_ff, imm_ext_ff, prog_cnt_ff, id_rs_idx_ff, id_rt_idx_ff, id_rd_idx_ff, ctrl_alu_op_ff, c_reg_dst_ff, c_alu_src_ff, c_mem2reg_ff, c_reg_wr_ff, c_mem_rd_ff, c_mem_wr_ff, c_br_ff, c_jmp_ff};

endmodule
