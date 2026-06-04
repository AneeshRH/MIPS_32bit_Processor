`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2026 18:02:50
// Design Name: 
// Module Name: data_forward_ctrl
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

module data_forward_ctrl(
    input [4:0] id_ex_rs_addr, id_ex_rt_addr, ex_mem_rd_addr, mem_wb_rd_addr,
    input ex_mem_we, mem_wb_we,
    output reg [1:0] fwd_mux_a, fwd_mux_b
);

always @(*) begin
    fwd_mux_a = 2'b00;
    fwd_mux_b = 2'b00;
    
    // EX Hazard
    if (ex_mem_we && ex_mem_rd_addr != 0 && ex_mem_rd_addr == id_ex_rs_addr) 
        fwd_mux_a = 2'b10;
    else if (mem_wb_we && mem_wb_rd_addr != 0 && ~(ex_mem_we && (ex_mem_rd_addr != 0) && (ex_mem_rd_addr != id_ex_rs_addr)) && mem_wb_rd_addr == id_ex_rs_addr) 
        fwd_mux_a = 2'b01;
        
    if (ex_mem_we && ex_mem_rd_addr != 0 && ex_mem_rd_addr == id_ex_rt_addr) 
        fwd_mux_b = 2'b10;
    else if (mem_wb_we && mem_wb_rd_addr != 0 && ~(ex_mem_we && (ex_mem_rd_addr != 0) && (ex_mem_rd_addr != id_ex_rs_addr)) && mem_wb_rd_addr == id_ex_rt_addr) 
        fwd_mux_b = 2'b01;

end

endmodule
