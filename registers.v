`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2025 23:15:27
// Design Name: 
// Module Name: registers
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


module registers(input clk,input [4:0] read_reg1,read_reg2,write_reg,input RegWrite,input[31:0] write_data,output [31:0] read_data1,read_data2,output [31:0] reg_mem_req_output1,reg_mem_req_output2,reg_mem_req_output3,reg_mem_req_output4);
reg [31:0] read_data1_reg,read_data2_reg;
reg [31:0] mem [31:0];
integer i;
initial begin
for(i=0;i<31;i=i+1) begin
if(i!=1 && i!=3 && i!=13 && i!=5 && i!=6 && i!=15 && i!=2 && i!=4) begin
mem[i] =32'b0;
end
else if (i==1)begin
mem [1] = 32'd16;
end
else if (i==3)begin
mem [3] = 32'd6;
end
else if (i==13)begin
mem [13] = 32'd18;
end
else if (i==5)begin
mem [5] = 32'd33;
end
else if (i==6)begin
mem [6] = 32'd5;
end
else if (i==15)begin
mem [15] = 32'd3566;
end
else if (i==2)begin
mem [2] = 32'd16;
end
else if (i==4)begin
mem [4] = 32'd256;
end
end
end
always@(posedge clk)
begin
if(RegWrite) mem[write_reg]<=write_data;
end
assign read_data1=mem[read_reg1];
assign read_data2=mem[read_reg2];
//assign reg_mem_req_output2 = mem[12];
//assign reg_mem_req_output1 = mem[2];
//assign reg_mem_req_output3 = mem[13];
//assign reg_mem_req_output4 = mem[14];
assign reg_mem_req_output1 = mem[10];
assign reg_mem_req_output2 = mem[11];
assign reg_mem_req_output3 = mem[12];
assign reg_mem_req_output4 = mem[13];
endmodule
