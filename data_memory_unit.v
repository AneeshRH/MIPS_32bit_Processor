`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2026 23:15:27
// Design Name: 
// Module Name: data_memory_unit
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

module data_memory_unit(
    input [31:0] mem_addr_in,
    input [31:0] mem_write_data,
    output [31:0] mem_read_data,
    input ctrl_mem_rd, ctrl_mem_wr, clock_sig,
    output [31:0] probe_mem_data,
    output [29:0] probe_word_addr
);

    integer iter_idx;
    reg [31:0] dmem_array [31:0];
    
    initial begin
        for(iter_idx = 0; iter_idx < 31; iter_idx = iter_idx + 1) begin
            if(iter_idx != 9 && iter_idx != 10) begin
                dmem_array[iter_idx] = 32'b0;
            end
            else if(iter_idx == 9) 
                dmem_array[9] = 32'd18;
            else if(iter_idx == 10) 
                dmem_array[10] = 32'd118;
        end
    end

    //reg [31:0] read_d_ff;
    always @(posedge clock_sig) begin
        //if(ctrl_mem_rd) read_d_ff <= dmem_array[mem_addr_in[31:2]];
        if(ctrl_mem_wr) dmem_array[mem_addr_in[31:2]] <= mem_write_data;
    end
    
    assign mem_read_data = ctrl_mem_rd ? dmem_array[mem_addr_in[31:2]] : 32'b0;
    
    //assign mem_read_data = read_d_ff;
    //assign probe_mem_data = dmem_array[26];
    assign probe_mem_data = dmem_array[10];
    assign probe_word_addr = mem_addr_in[31:2];

endmodule
