`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2025 18:02:50
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit(
input[4:0] IDEX_RegRs, IDEX_RegRt,EXMEM_RegRd,MEMWB_RegRd,
input EXMEM_RegWrite,MEMWB_RegWrite,
output reg [1:0]ForwardA,ForwardB
    );
always@(*)begin
ForwardA=2'b00;
ForwardB=2'b00;
//EX Hazard
if(EXMEM_RegWrite && EXMEM_RegRd!=0 && EXMEM_RegRd==IDEX_RegRs) ForwardA=2'b10;
else if(MEMWB_RegWrite && MEMWB_RegRd!=0 && ~(EXMEM_RegWrite && (EXMEM_RegRd!=0) && (EXMEM_RegRd!=IDEX_RegRs)) &&
MEMWB_RegRd==IDEX_RegRs) ForwardA=2'b01;
//else ForwardA=2'b00;
if(EXMEM_RegWrite && EXMEM_RegRd!=0 && EXMEM_RegRd==IDEX_RegRt) ForwardB=2'b10;
else if(MEMWB_RegWrite && MEMWB_RegRd!=0 && ~(EXMEM_RegWrite && (EXMEM_RegRd!=0) && (EXMEM_RegRd!=IDEX_RegRs)) &&
MEMWB_RegRd==IDEX_RegRt) ForwardB=2'b01;
//ForwardB=2'b00;

//WB hazard

//else ForwardA=2'b00;

//else ForwardB=2'b00;
end
endmodule
