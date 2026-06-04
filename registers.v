`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2026 23:15:27
// Design Name: 
// Module Name: register_bank
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

module register_bank(
    input clock,
    input [4:0] rd_addr_a, rd_addr_b, wr_addr,
    input we_ctrl,
    input [31:0] wr_data_in,
    output [31:0] rd_data_a, rd_data_b,
    output [31:0] probe_val1, probe_val2, probe_val3, probe_val4
);

reg [31:0] rd_val_a_reg, rd_val_b_reg;
reg [31:0] reg_array [31:0];
integer idx;

initial begin
    for(idx=0; idx<31; idx=idx+1) begin
        if(idx!=1 && idx!=3 && idx!=13 && idx!=5 && idx!=6 && idx!=15 && idx!=2 && idx!=4) begin
            reg_array[idx] = 32'b0;
        end
        else if (idx==1)begin
            reg_array[1] = 32'd16;
        end
        else if (idx==3)begin
            reg_array[3] = 32'd6;
        end
        else if (idx==13)begin
            reg_array[13] = 32'd18;
        end
        else if (idx==5)begin
            reg_array[5] = 32'd33;
        end
        else if (idx==6)begin
            reg_array[6] = 32'd5;
        end
        else if (idx==15)begin
            reg_array[15] = 32'd3566;
        end
        else if (idx==2)begin
            reg_array[2] = 32'd16;
        end
        else if (idx==4)begin
            reg_array[4] = 32'd256;
        end
    end
end

always @(posedge clock) begin
    if(we_ctrl) reg_array[wr_addr] <= wr_data_in;
end

assign rd_data_a = reg_array[rd_addr_a];
assign rd_data_b = reg_array[rd_addr_b];

//assign probe_val2 = reg_array[12];
//assign probe_val1 = reg_array[2];
//assign probe_val3 = reg_array[13];
//assign probe_val4 = reg_array[14];

assign probe_val1 = reg_array[10];
assign probe_val2 = reg_array[11];
assign probe_val3 = reg_array[12];
assign probe_val4 = reg_array[13];

endmodule
