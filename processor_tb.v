`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2026 21:36:46
// Design Name: 
// Module Name: processor_tb
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

module processor_tb();
    
    // Matched exact names from the waveform screenshot
    reg clk;
    
    wire [31:0] write_data_check, alu_out_check, data_mem_req_output;
    wire [31:0] reg_mem_req_output1, reg_mem_req_output2, reg_mem_req_output3, reg_mem_req_output4;
    wire [31:0] rd_addr, tb_writedata;
    wire [4:0] rd_writereg;
    wire [29:0] check_addr;

    // Instantiating the updated top module, bridging new port names to your original waveform signals
    processor_top dut(
        .clock(clk), 
        .dbg_reg_mem_req4(reg_mem_req_output4), 
        .dbg_write_data_chk(write_data_check), 
        .dbg_chk_addr(check_addr),  
        .dbg_data_mem_req(data_mem_req_output),
        .dbg_reg_mem_req1(reg_mem_req_output1),
        .dbg_reg_mem_req2(reg_mem_req_output2),
        .dbg_reg_mem_req3(reg_mem_req_output3),
        .dbg_alu_out(alu_out_check), 
        .dbg_rd_addr(rd_addr),
        .dbg_tb_writedata(tb_writedata), 
        .dbg_rd_writereg(rd_writereg)
    );

    initial begin
        clk = 0;
    end
    
    initial begin
        #200 $finish;
    end
    
    always begin
        #5 clk = ~clk;
    end

endmodule
