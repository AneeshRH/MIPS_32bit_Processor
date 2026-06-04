`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2026 19:46:12
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
    
    reg clock_sig;
    
    wire [31:0] probe_write_data, probe_alu_out, probe_data_mem_req;
    wire [31:0] probe_reg_req1, probe_reg_req2, probe_reg_req3, probe_reg_req4;
    wire [31:0] probe_rd_addr, probe_tb_writedata;
    wire [4:0] probe_rd_writereg;
    wire [29:0] probe_chk_addr;

    // Instantiating the updated top module (processor_top)
    processor_top dut(
        .clock(clock_sig), 
        .dbg_reg_mem_req4(probe_reg_req4), 
        .dbg_write_data_chk(probe_write_data), 
        .dbg_chk_addr(probe_chk_addr),  
        .dbg_data_mem_req(probe_data_mem_req),
        .dbg_reg_mem_req1(probe_reg_req1),
        .dbg_reg_mem_req2(probe_reg_req2),
        .dbg_reg_mem_req3(probe_reg_req3),
        .dbg_alu_out(probe_alu_out), 
        .dbg_rd_addr(probe_rd_addr),
        .dbg_tb_writedata(probe_tb_writedata), 
        .dbg_rd_writereg(probe_rd_writereg)
    );

    initial begin
        clock_sig = 0;
    end
    
    initial begin
        #200 $finish;
    end
    
    always begin
        #5 clock_sig = ~clock_sig;
    end

endmodule
