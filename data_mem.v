`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2025 23:15:27
// Design Name: 
// Module Name: data_mem
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


module data_mem(
   input [31:0] addr,
   input [31:0] write_data,
   output [31:0] read_data,
   input MemRead, MemWrite,clk,output [31:0] data_mem_req_output,output [29:0]check_addr
    );
    integer i;
  reg [31:0] mem [31:0];
  initial begin
for(i=0;i<31;i=i+1) begin
if(i!=9 && i!=10) begin
mem[i] =32'b0;
end
else if(i==9) mem[9] = 32'd18;
else if(i==10) mem[10] = 32'd118;
end
end
  //reg [31:0]read_d;
  always@(posedge clk)begin
  //if(MemRead) read_d<=mem[addr[31:2]];
  if(MemWrite) mem[addr[31:2]]<=write_data;
  end
  assign read_data = MemRead?mem[addr[31:2]]:0;
  //assign read_data=read_d;
 // assign data_mem_req_output = mem[26];
 assign data_mem_req_output = mem[10];
  assign check_addr = addr[31:2];
endmodule
