module tb();
reg clk;
wire [31:0] write_data_check,alu_out_check, data_mem_req_output,reg_mem_req_output1,reg_mem_req_output2,reg_mem_req_output3,rd_addr,tb_writedata;
wire[4:0]rd_writereg;
wire [31:0] reg_mem_req_output4;
wire [29:0] check_addr;
top dut(.clk(clk) ,.reg_mem_req_output4(reg_mem_req_output4), .write_data_check(write_data_check), .check_addr(check_addr),  .data_mem_req_output(data_mem_req_output),.reg_mem_req_output1(reg_mem_req_output1),.reg_mem_req_output2(reg_mem_req_output2),.reg_mem_req_output3(reg_mem_req_output3),.alu_out_check(alu_out_check), .rd_addr(rd_addr),.tb_writedata(tb_writedata), .rd_writereg(rd_writereg));
initial
clk=0;
initial 
#200 $finish;
always
#5 clk=~clk;
endmodule
