`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2025 21:36:46
// Design Name: 
// Module Name: top
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


module top(input clk ,output [31:0]reg_mem_req_output4, write_data_check,output [29:0] check_addr,output [31:0]  data_mem_req_output,reg_mem_req_output1,reg_mem_req_output2,reg_mem_req_output3,output [31:0]alu_out_check, rd_addr,tb_writedata, output [4:0] rd_writereg);
reg [31:0] PC;
wire [31:0] PC_in;
wire [31:0] PC_out;
wire [31:0] instruction;
wire [31:0] PC_nex,PC_branch;
wire [31:0] write_data;
wire [5:0] op;
initial PC=0;
wire PCSrc;
wire [31:0] ins_reg_ifid,pc_reg_ifid;
wire [5:0] funct;
assign PC_nex = PC_out+4;
assign PC_out = PC;
assign PC_in = PCSrc?PC_branch:PC_nex;
wire [4:0] read_reg1,read_reg2,write_reg, EXMEM_write_reg_in,register_dest_out_EXMEM,Dest_out_MEMWB;
wire [4:0] IFID_REGRS,IFID_REGRT,IFID_REGRD;
wire[31:0] read_data1,read_data2, EXMEM_branching_in,read_data_data_mem;
wire RegDest,AluSrc, MemtoReg,RegWrite,Memread, MemWrite, Branch,Jump;
wire [31:0]read_data1_out_IDEX,read_data2_out_IDEX,immediate_out_IDEX,pc_addr_out_IDEX, ALU_OUT,add_result_out_EXMEM,alu_result_out_EXMEM,read_data_2_out_EXMEM,read_data_out_MEMWB,alu_result_out_MEMWB;
wire [4:0] IFID_REGRS_out_IDEX,IFID_REGRT_out_IDEX,IFID_REGRD_out_IDEX;
wire [1:0]alu_op_out_IDEX;
wire RegDst_out_IDEX, AluSrc_out_IDEX, MemtoReg_out_IDEX,RegWrite_out_IDEX,Memread_out_IDEX, MemWrite_out_IDEX, Branch_out_IDEX,Jump_out_IDEX,MemtoReg_out_EXMEM,RegWrite_out_EXMEM,MemRead_out_EXMEM,MemWrite_out_EXMEM,Branch_out_EXMEM,zero_out_EXMEM,RegWrite_out_MEMWB,Jump_out_MEMWB,MemtoReg_out_MEMWB;
wire [1:0] AluOp, ForwardA, ForwardB;
wire [15:0] imm;
assign imm =  ins_reg_ifid[15:0];
wire [5:0] funct_idex;
wire[3:0] Alu_control;
wire zero_reg;
wire [31:0] immediate;
reg [31:0]OPERAND1_fd,OPERAND2_fd;
wire [31:0] OP1,OP2;
assign immediate = {{16{imm[15]}},imm};
assign read_reg1 = ins_reg_ifid[25:21];
assign read_reg2=ins_reg_ifid[20:16];

assign rd_writereg=write_reg;

assign tb_writedata=write_data;


assign funct_idex = immediate_out_IDEX[5:0];
assign op = ins_reg_ifid[31:26];
assign funct=ins_reg_ifid[5:0];
assign IFID_REGRS = read_reg1;
assign IFID_REGRT = read_reg2;
assign IFID_REGRD = ins_reg_ifid[15:11];
always@(posedge clk) PC<=PC_in;
ins_memory i1(.read_adress(PC_out),.instruction(instruction));
IFID_reg reg1(.instruction_memory(instruction),.pc_next(PC_nex),.clk(clk),.instruction_out(ins_reg_ifid),.pc_out(pc_reg_ifid));
registers r1(.reg_mem_req_output4(reg_mem_req_output4),.clk(clk),.read_reg1(read_reg1),.read_reg2(read_reg2),.write_reg(write_reg),.write_data(write_data),.read_data1(read_data1),.read_data2(read_data2),.RegWrite(RegWrite_out_MEMWB),.reg_mem_req_output1(reg_mem_req_output1),.reg_mem_req_output2(reg_mem_req_output2),.reg_mem_req_output3(reg_mem_req_output3));
control_unit c1(.op(op),.RegDst(RegDst),.AluSrc(AluSrc),.MemtoReg(MemtoReg),.RegWrite(RegWrite),.Memread(Memread),.MemWrite(MemWrite),.Branch(Branch),.Jump(Jump),.AluOp(AluOp));
IDEX reg2(.clk(clk),.read_data1(read_data1),.read_data2(read_data2),.pc_addr(PC_nex),.immediate(immediate),.IFID_REGRS(IFID_REGRS),.IFID_REGRT(IFID_REGRT),.IFID_REGRD(IFID_REGRD),.alu_op(AluOp),.RegDst(RegDst), .AluSrc(AluSrc), .MemtoReg(MemtoReg),.RegWrite(RegWrite),.Memread(Memread), .MemWrite(MemWrite), .Branch(Branch),.Jump(Jump),.read_data1_out(read_data1_out_IDEX),.read_data2_out(read_data2_out_IDEX),.immediate_out(immediate_out_IDEX),.pc_addr_out(pc_addr_out_IDEX),.IFID_REGRS_out(IFID_REGRS_out_IDEX),.IFID_REGRT_out(IFID_REGRT_out_IDEX),.IFID_REGRD_out(IFID_REGRD_out_IDEX),.alu_op_out(alu_op_out_IDEX),.RegDst_out(RegDst_out_IDEX), .AluSrc_out(AluSrc_out_IDEX), .MemtoReg_out(MemtoReg_out_IDEX),.RegWrite_out(RegWrite_out_IDEX),.Memread_out(Memread_out_IDEX), .MemWrite_out(MemWrite_out_IDEX), .Branch_out(Branch_out_IDEX),.Jump_out(Jump_out_IDEX));
assign EXMEM_write_reg_in=(RegDst_out_IDEX?IFID_REGRD_out_IDEX:IFID_REGRT_out_IDEX);
assign EXMEM_branching_in=pc_addr_out_IDEX+{immediate_out_IDEX[29:0],2'b0};
alu_control al(.AluOp(alu_op_out_IDEX),.funct(funct_idex),.Alu_control(Alu_control));
ALU_unit ALU(.alu_op(Alu_control),.operand_1(OP1),.operand_2(OP2),.out(ALU_OUT),.zero(zero_reg));
EXMEM_reg reg3(.MemtoReg(MemtoReg_out_IDEX),.RegWrite(RegWrite_out_IDEX),.MemRead(Memread_out_IDEX),.MemWrite(MemWrite_out_IDEX),.Branch(Branch_out_IDEX),.zero(zero_reg),.clk(clk),.add_result(EXMEM_branching_in),.alu_result(ALU_OUT),.read_data_2(read_data2_out_IDEX),.register_dest(EXMEM_write_reg_in),.MemtoReg_out(MemtoReg_out_EXMEM),.RegWrite_out(RegWrite_out_EXMEM),.MemRead_out(MemRead_out_EXMEM),.MemWrite_out(MemWrite_out_EXMEM),.Branch_out(Branch_out_EXMEM),.zero_out(zero_out_EXMEM),.add_result_out(add_result_out_EXMEM),.alu_result_out(alu_result_out_EXMEM),.read_data_2_out(read_data_2_out_EXMEM),.register_dest_out(register_dest_out_EXMEM));
data_mem dm(.clk(clk),.check_addr(check_addr),.addr(alu_result_out_EXMEM),.write_data(read_data_2_out_EXMEM),.read_data(read_data_data_mem),.MemRead(MemRead_out_EXMEM), .MemWrite(MemWrite_out_EXMEM),.data_mem_req_output(data_mem_req_output));
assign PCSrc=Branch_out_EXMEM && zero_out_EXMEM;
assign PC_branch=add_result_out_EXMEM;
MEMWB reg4(.clk(clk),.read_data(read_data_data_mem),.alu_result(alu_result_out_EXMEM),.Dest(register_dest_out_EXMEM),.RegWrite(RegWrite_out_EXMEM),.MemtoReg(MemtoReg_out_EXMEM),.read_data_out(read_data_out_MEMWB),.alu_result_out(alu_result_out_MEMWB),.Dest_out(Dest_out_MEMWB),.RegWrite_out(RegWrite_out_MEMWB),.Jump_out(Jump_out_MEMWB),.MemtoReg_out(MemtoReg_out_MEMWB));
assign write_data=MemtoReg_out_MEMWB?read_data_out_MEMWB:alu_result_out_MEMWB;
forwarding_unit fd(.IDEX_RegRs(IFID_REGRS_out_IDEX), .IDEX_RegRt(IFID_REGRT_out_IDEX),.EXMEM_RegRd(register_dest_out_EXMEM),.MEMWB_RegRd(Dest_out_MEMWB),.EXMEM_RegWrite(RegWrite_out_EXMEM),.MEMWB_RegWrite(RegWrite_out_MEMWB),.ForwardA(ForwardA),.ForwardB(ForwardB));
always@(*) begin
case(ForwardA)
2'b00:OPERAND1_fd=read_data1_out_IDEX;
2'b10:OPERAND1_fd=alu_result_out_EXMEM;
2'b01:OPERAND1_fd=write_data;
default:OPERAND1_fd=read_data1_out_IDEX;
endcase
case(ForwardB)
2'b00:OPERAND2_fd=AluSrc_out_IDEX?immediate_out_IDEX:read_data2_out_IDEX;
2'b10:OPERAND2_fd=alu_result_out_EXMEM;
2'b01:OPERAND2_fd=write_data;
default:OPERAND2_fd=AluSrc_out_IDEX?immediate_out_IDEX:read_data2_out_IDEX;
endcase
end
assign OP1 = OPERAND1_fd;
assign OP2 = OPERAND2_fd;
assign write_reg = Dest_out_MEMWB;
assign rd_addr = PC_out;

assign alu_out_check = ALU_OUT;
assign write_data_check = read_data_2_out_EXMEM;

endmodule
