`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2026 17:46:47
// Design Name: 
// Module Name: pipeline_reg_mem_wb
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

module pipeline_reg_mem_wb(
    input clock_in,
    input [31:0] mem_rd_data, alu_res_in,
    input [4:0] dest_reg_addr,
    input ctrl_reg_wr_in, ctrl_jump_in, ctrl_mem2reg_in,
    output [31:0] mem_rd_data_out, alu_res_out,
    output [4:0] dest_reg_addr_out,
    output ctrl_reg_wr_out, ctrl_jump_out, ctrl_mem2reg_out
);

reg [31:0] mem_rd_data_ff, alu_res_ff;
reg [4:0] dest_reg_addr_ff;
reg ctrl_reg_wr_ff, ctrl_jump_ff, ctrl_mem2reg_ff;

initial begin
    {mem_rd_data_ff, alu_res_ff, dest_reg_addr_ff, ctrl_reg_wr_ff, ctrl_jump_ff, ctrl_mem2reg_ff} = 0;
end

always @(posedge clock_in) begin
    {mem_rd_data_ff, alu_res_ff, dest_reg_addr_ff, ctrl_reg_wr_ff, ctrl_jump_ff, ctrl_mem2reg_ff} <= 
    {mem_rd_data, alu_res_in, dest_reg_addr, ctrl_reg_wr_in, ctrl_jump_in, ctrl_mem2reg_in};
end

assign {mem_rd_data_out, alu_res_out, dest_reg_addr_out, ctrl_reg_wr_out, ctrl_jump_out, ctrl_mem2reg_out} = 
       {mem_rd_data_ff, alu_res_ff, dest_reg_addr_ff, ctrl_reg_wr_ff, ctrl_jump_ff, ctrl_mem2reg_ff};

endmodule
