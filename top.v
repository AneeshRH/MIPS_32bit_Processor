`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2026 21:36:46
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

module top(
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

ins_memory i1(
    .read_adress(prog_c_out), 
    .instruction(instr)
);

IFID_reg reg1(
    .instruction_memory(instr), 
    .pc_next(prog_c_next), 
    .clk(clock), 
    .instruction_out(ifid_instr), 
    .pc_out(ifid_pc)
);

registers r1(
    .reg_mem_req_output4(dbg_reg_mem_req4), 
    .clk(clock), 
    .read_reg1(rd_reg1), 
    .read_reg2(rd_reg2), 
    .write_reg(wr_reg), 
    .write_data(wr_data), 
    .read_data1(rd_data1), 
    .read_data2(rd_data2), 
    .RegWrite(reg_wr_memwb), 
    .reg_mem_req_output1(dbg_reg_mem_req1), 
    .reg_mem_req_output2(dbg_reg_mem_req2), 
    .reg_mem_req_output3(dbg_reg_mem_req3)
);

control_unit c1(
    .op(opcode), 
    .RegDst(ctrl_reg_dst), 
    .AluSrc(ctrl_alu_src), 
    .MemtoReg(ctrl_mem_to_reg), 
    .RegWrite(ctrl_reg_wr), 
    .Memread(ctrl_mem_rd), 
    .MemWrite(ctrl_mem_wr), 
    .Branch(ctrl_branch), 
    .Jump(ctrl_jump), 
    .AluOp(alu_op_ctrl)
);

IDEX reg2(
    .clk(clock), 
    .read_data1(rd_data1), 
    .read_data2(rd_data2), 
    .pc_addr(prog_c_next), 
    .immediate(ext_imm), 
    .IFID_REGRS(ifid_rs), 
    .IFID_REGRT(ifid_rt), 
    .IFID_REGRD(ifid_rd), 
    .alu_op(alu_op_ctrl), 
    .RegDst(ctrl_reg_dst), 
    .AluSrc(ctrl_alu_src), 
    .MemtoReg(ctrl_mem_to_reg), 
    .RegWrite(ctrl_reg_wr), 
    .Memread(ctrl_mem_rd), 
    .MemWrite(ctrl_mem_wr), 
    .Branch(ctrl_branch), 
    .Jump(ctrl_jump), 
    .read_data1_out(rd_data1_idex), 
    .read_data2_out(rd_data2_idex), 
    .immediate_out(imm_idex), 
    .pc_addr_out(pc_addr_idex), 
    .IFID_REGRS_out(ifid_rs_idex), 
    .IFID_REGRT_out(ifid_rt_idex), 
    .IFID_REGRD_out(ifid_rd_idex), 
    .alu_op_out(alu_op_idex), 
    .RegDst_out(reg_dst_idex), 
    .AluSrc_out(alu_src_idex), 
    .MemtoReg_out(mem_to_reg_idex), 
    .RegWrite_out(reg_wr_idex), 
    .Memread_out(mem_rd_idex), 
    .MemWrite_out(mem_wr_idex), 
    .Branch_out(branch_idex), 
    .Jump_out(jump_idex)
);

assign exmem_wr_reg_in = (reg_dst_idex ? ifid_rd_idex : ifid_rt_idex);
assign exmem_br_in = pc_addr_idex + {imm_idex[29:0], 2'b00};

alu_control al(
    .AluOp(alu_op_idex), 
    .funct(func_idex), 
    .Alu_control(alu_ctrl_sig)
);

ALU_unit ALU(
    .alu_op(alu_ctrl_sig), 
    .operand_1(operand_a), 
    .operand_2(operand_b), 
    .out(alu_result), 
    .zero(z_flag)
);

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

data_mem dm(
    .clk(clock), 
    .check_addr(dbg_chk_addr), 
    .addr(alu_res_exmem), 
    .write_data(rd_data2_exmem), 
    .read_data(dmem_rd_data), 
    .MemRead(mem_rd_exmem), 
    .MemWrite(mem_wr_exmem), 
    .data_mem_req_output(dbg_data_mem_req)
);

assign pc_source = branch_exmem && z_exmem;
assign prog_c_br = add_res_exmem;

MEMWB reg4(
    .clk(clock), 
    .read_data(dmem_rd_data), 
    .alu_result(alu_res_exmem), 
    .Dest(exmem_reg_dst_out), 
    .RegWrite(reg_wr_exmem), 
    .MemtoReg(mem_to_reg_exmem), 
    .read_data_out(rd_data_memwb), 
    .alu_result_out(alu_res_memwb), 
    .Dest_out(memwb_dst_out), 
    .RegWrite_out(reg_wr_memwb), 
    .Jump_out(jump_memwb), 
    .MemtoReg_out(mem_to_reg_memwb)
);

assign wr_data = mem_to_reg_memwb ? rd_data_memwb : alu_res_memwb;

forwarding_unit fd(
    .IDEX_RegRs(ifid_rs_idex), 
    .IDEX_RegRt(ifid_rt_idex), 
    .EXMEM_RegRd(exmem_reg_dst_out), 
    .MEMWB_RegRd(memwb_dst_out), 
    .EXMEM_RegWrite(reg_wr_exmem), 
    .MEMWB_RegWrite(reg_wr_memwb), 
    .ForwardA(fwd_a), 
    .ForwardB(fwd_b)
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
