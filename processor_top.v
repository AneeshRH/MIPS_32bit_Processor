`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2026 21:36:46
// Design Name: 
// Module Name: processor_top
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

module processor_top(
    input clock, 
    output [31:0] dbg_reg_mem_req4, dbg_write_data_chk,
    output [29:0] dbg_chk_addr,
    output [31:0] dbg_data_mem_req, dbg_reg_mem_req1, dbg_reg_mem_req2, dbg_reg_mem_req3,
    output [31:0] dbg_alu_out, dbg_rd_addr, dbg_tb_writedata, 
    output [4:0] dbg_rd_writereg
);

reg [31:0] prog_c;
wire [31:0] prog_c_in;
wire [31:0] prog_c_out;
wire [31:0] instr;
wire [31:0] prog_c_next, prog_c_br;
wire [31:0] wr_data;
wire [5:0] opcode;

initial prog_c = 0;

wire pc_source;
wire [31:0] ifid_instr, ifid_pc;
wire [5:0] func_code;

assign prog_c_next = prog_c_out + 4;
assign prog_c_out = prog_c;
assign prog_c_in = pc_source ? prog_c_br : prog_c_next;

wire [4:0] rd_reg1, rd_reg2, wr_reg, exmem_wr_reg_in, exmem_reg_dst_out, memwb_dst_out;
wire [4:0] ifid_rs, ifid_rt, ifid_rd;
wire [31:0] rd_data1, rd_data2, exmem_br_in, dmem_rd_data;
wire ctrl_reg_dst, ctrl_alu_src, ctrl_mem_to_reg, ctrl_reg_wr, ctrl_mem_rd, ctrl_mem_wr, ctrl_branch, ctrl_jump;

wire [31:0] rd_data1_idex, rd_data2_idex, imm_idex, pc_addr_idex, alu_result, add_res_exmem, alu_res_exmem, rd_data2_exmem, rd_data_memwb, alu_res_memwb;
wire [4:0] ifid_rs_idex, ifid_rt_idex, ifid_rd_idex;
wire [1:0] alu_op_idex;
wire reg_dst_idex, alu_src_idex, mem_to_reg_idex, reg_wr_idex, mem_rd_idex, mem_wr_idex, branch_idex, jump_idex, mem_to_reg_exmem, reg_wr_exmem, mem_rd_exmem, mem_wr_exmem, branch_exmem, z_exmem, reg_wr_memwb, jump_memwb, mem_to_reg_memwb;

wire [1:0] alu_op_ctrl, fwd_a, fwd_b;
wire [15:0] imm_val;

assign imm_val = ifid_instr[15:0];
wire [5:0] func_idex;
wire [3:0] alu_ctrl_sig;
wire z_flag;
wire [31:0] ext_imm;
reg [31:0] op1_fwd, op2_fwd;
wire [31:0] operand_a, operand_b;

assign ext_imm = {{16{imm_val[15]}}, imm_val};
assign rd_reg1 = ifid_instr[25:21];
assign rd_reg2 = ifid_instr[20:16];

assign dbg_rd_writereg = wr_reg;
assign dbg_tb_writedata = wr_data;

assign func_idex = imm_idex[5:0];
assign opcode = ifid_instr[31:26];
assign func_code = ifid_instr[5:0];
assign ifid_rs = rd_reg1;
assign ifid_rt = rd_reg2;
assign ifid_rd = ifid_instr[15:11];

always @(posedge clock) prog_c <= prog_c_in;

// Updated to use instr_mem_unit
instr_mem_unit i1(
    .fetch_addr_in(prog_c_out), 
    .fetched_instr_out(instr)
);

// Updated to use pipeline_reg_if_id
pipeline_reg_if_id reg1(
    .mem_instr_in(instr), 
    .next_pc_in(prog_c_next), 
    .clk_signal(clock), 
    .instr_fwd_out(ifid_instr), 
    .pc_fwd_out(ifid_pc)
);

// Updated to use register_bank
register_bank r1(
    .probe_val4(dbg_reg_mem_req4), 
    .clock(clock), 
    .rd_addr_a(rd_reg1), 
    .rd_addr_b(rd_reg2), 
    .wr_addr(wr_reg), 
    .wr_data_in(wr_data), 
    .rd_data_a(rd_data1), 
    .rd_data_b(rd_data2), 
    .we_ctrl(reg_wr_memwb), 
    .probe_val1(dbg_reg_mem_req1), 
    .probe_val2(dbg_reg_mem_req2), 
    .probe_val3(dbg_reg_mem_req3)
);

// Updated to use main_decoder_logic
main_decoder_logic c1(
    .opcode_in(opcode), 
    .dst_reg_sel(ctrl_reg_dst), 
    .src_alu_sel(ctrl_alu_src), 
    .mem_to_reg_sel(ctrl_mem_to_reg), 
    .reg_we(ctrl_reg_wr), 
    .mem_re(ctrl_mem_rd), 
    .mem_we(ctrl_mem_wr), 
    .is_branch(ctrl_branch), 
    .is_jump(ctrl_jump), 
    .alu_mode(alu_op_ctrl)
);

// Updated to use pipeline_reg_id_ex
pipeline_reg_id_ex reg2(
    .clock_sig(clock), 
    .val_rs(rd_data1), 
    .val_rt(rd_data2), 
    .prog_cnt(prog_c_next), 
    .imm_ext(ext_imm), 
    .id_rs_idx(ifid_rs), 
    .id_rt_idx(ifid_rt), 
    .id_rd_idx(ifid_rd), 
    .ctrl_alu_op(alu_op_ctrl), 
    .c_reg_dst(ctrl_reg_dst), 
    .c_alu_src(ctrl_alu_src), 
    .c_mem2reg(ctrl_mem_to_reg), 
    .c_reg_wr(ctrl_reg_wr), 
    .c_mem_rd(ctrl_mem_rd), 
    .c_mem_wr(ctrl_mem_wr), 
    .c_br(ctrl_branch), 
    .c_jmp(ctrl_jump), 
    .val_rs_ex(rd_data1_idex), 
    .val_rt_ex(rd_data2_idex), 
    .imm_ext_ex(imm_idex), 
    .prog_cnt_ex(pc_addr_idex), 
    .id_rs_idx_ex(ifid_rs_idex), 
    .id_rt_idx_ex(ifid_rt_idex), 
    .id_rd_idx_ex(ifid_rd_idex), 
    .ctrl_alu_op_ex(alu_op_idex), 
    .c_reg_dst_ex(reg_dst_idex), 
    .c_alu_src_ex(alu_src_idex), 
    .c_mem2reg_ex(mem_to_reg_idex), 
    .c_reg_wr_ex(reg_wr_idex), 
    .c_mem_rd_ex(mem_rd_idex), 
    .c_mem_wr_ex(mem_wr_idex), 
    .c_br_ex(branch_idex), 
    .c_jmp_ex(jump_idex)
);

assign exmem_wr_reg_in = (reg_dst_idex ? ifid_rd_idex : ifid_rt_idex);
assign exmem_br_in = pc_addr_idex + {imm_idex[29:0], 2'b00};

// Updated to use arithmetic_ctrl_unit
arithmetic_ctrl_unit al(
    .op_code_ctrl(alu_op_idex), 
    .function_field(func_idex), 
    .alu_cmd_out(alu_ctrl_sig)
);

// Updated to use arithmetic_logic_core
arithmetic_logic_core ALU(
    .ctrl_operation(alu_ctrl_sig), 
    .src_a(operand_a), 
    .src_b(operand_b), 
    .result_val(alu_result), 
    .is_zero_flag(z_flag)
);

// Note: EXMEM_reg was never provided for renaming, so its native ports are used
EXMEM_reg reg3(
    .MemtoReg(mem_to_reg_idex), 
    .RegWrite(reg_wr_idex), 
    .MemRead(mem_rd_idex), 
    .MemWrite(mem_wr_idex), 
    .Branch(branch_idex), 
    .zero(z_flag), 
    .clk(clock), 
    .add_result(exmem_br_in), 
    .alu_result(alu_result), 
    .read_data_2(rd_data2_idex), 
    .register_dest(exmem_wr_reg_in), 
    .MemtoReg_out(mem_to_reg_exmem), 
    .RegWrite_out(reg_wr_exmem), 
    .MemRead_out(mem_rd_exmem), 
    .MemWrite_out(mem_wr_exmem), 
    .Branch_out(branch_exmem), 
    .zero_out(z_exmem), 
    .add_result_out(add_res_exmem), 
    .alu_result_out(alu_res_exmem), 
    .read_data_2_out(rd_data2_exmem), 
    .register_dest_out(exmem_reg_dst_out)
);

// Updated to use data_memory_unit
data_memory_unit dm(
    .clock_sig(clock), 
    .probe_word_addr(dbg_chk_addr), 
    .mem_addr_in(alu_res_exmem), 
    .mem_write_data(rd_data2_exmem), 
    .mem_read_data(dmem_rd_data), 
    .ctrl_mem_rd(mem_rd_exmem), 
    .ctrl_mem_wr(mem_wr_exmem), 
    .probe_mem_data(dbg_data_mem_req)
);

assign pc_source = branch_exmem && z_exmem;
assign prog_c_br = add_res_exmem;

// Updated to use pipeline_reg_mem_wb (ctrl_jump_in tied to 0 as it was missing previously)
pipeline_reg_mem_wb reg4(
    .clock_in(clock), 
    .mem_rd_data(dmem_rd_data), 
    .alu_res_in(alu_res_exmem), 
    .dest_reg_addr(exmem_reg_dst_out), 
    .ctrl_reg_wr_in(reg_wr_exmem),
    .ctrl_jump_in(1'b0),
    .ctrl_mem2reg_in(mem_to_reg_exmem), 
    .mem_rd_data_out(rd_data_memwb), 
    .alu_res_out(alu_res_memwb), 
    .dest_reg_addr_out(memwb_dst_out), 
    .ctrl_reg_wr_out(reg_wr_memwb), 
    .ctrl_jump_out(jump_memwb), 
    .ctrl_mem2reg_out(mem_to_reg_memwb)
);

assign wr_data = mem_to_reg_memwb ? rd_data_memwb : alu_res_memwb;

// Updated to use data_forward_ctrl
data_forward_ctrl fd(
    .id_ex_rs_addr(ifid_rs_idex), 
    .id_ex_rt_addr(ifid_rt_idex), 
    .ex_mem_rd_addr(exmem_reg_dst_out), 
    .mem_wb_rd_addr(memwb_dst_out), 
    .ex_mem_we(reg_wr_exmem), 
    .mem_wb_we(reg_wr_memwb), 
    .fwd_mux_a(fwd_a), 
    .fwd_mux_b(fwd_b)
);

always @(*) begin
    case(fwd_a)
        2'b00: op1_fwd = rd_data1_idex;
        2'b10: op1_fwd = alu_res_exmem;
        2'b01: op1_fwd = wr_data;
        default: op1_fwd = rd_data1_idex;
    endcase
    case(fwd_b)
        2'b00: op2_fwd = alu_src_idex ? imm_idex : rd_data2_idex;
        2'b10: op2_fwd = alu_res_exmem;
        2'b01: op2_fwd = wr_data;
        default: op2_fwd = alu_src_idex ? imm_idex : rd_data2_idex;
    endcase
end

assign operand_a = op1_fwd;
assign operand_b = op2_fwd;
assign wr_reg = memwb_dst_out;
assign dbg_rd_addr = prog_c_out;

assign dbg_alu_out = alu_result;
assign dbg_write_data_chk = rd_data2_exmem;

endmodule
