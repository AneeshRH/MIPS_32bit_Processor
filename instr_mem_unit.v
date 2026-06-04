`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2026 23:15:27
// Design Name: 
// Module Name: instr_mem_unit
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

module instr_mem_unit(
    input [31:0] fetch_addr_in,
    output [31:0] fetched_instr_out
);

reg [31:0] imem_array [31:0];
reg [31:0] unused_instr_reg;
integer idx_loop;

initial begin
    for(idx_loop = 0; idx_loop < 256; idx_loop = idx_loop + 1) begin
        imem_array[idx_loop] = 32'b0;
    end
end

//initial begin
//imem_array[0]=32'b00000000001000110001000000100010;   // sub $2, $1, $3      --> $2 = $1 - $3
//imem_array[1]=32'b00000000010001010110000000100100;  //and $12, $2, $5     --> $12 = $2 & $5
//imem_array[2]=32'b00000001111011110111000000100000;   //add $14, $15, $15     --> $14 = $15 + $15
//imem_array[3]=32'b0000001110011100110100000100000; //add $13,$14,$14 -->     $13 = $14 + $14
//imem_array[4]=32'b10101100010011110000000001100100;     // sw $15, 100($2)     --> Memory[$2 + 100] = $15
//end

//initial begin
//imem_array[0]=32'b10001100001010100000000000010100;  //  lw $10, 20($1)     --> $10 = Memory[$1 + 20]
//imem_array[1]=32'b00000000010000110101100000100010; // sub $11, $2, $3    --> $11 = $2 - $3
//imem_array[2]=32'b00000000011001000110000000100000; //add $12, $3, $4    --> $12 = $3 + $4
//imem_array[3]=32'b10001100001011010000000000011000;   // lw $13, 24($1)     --> $13 = Memory[$1 + 24]
//end

//initial imem_array[0] =32'b00010001001010100000000000000100; //beq $t1, $t2, 4

assign fetched_instr_out = imem_array[fetch_addr_in[31:2]];

endmodule
