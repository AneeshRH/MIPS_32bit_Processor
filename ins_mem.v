`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2025 23:15:27
// Design Name: 
// Module Name: ins_memory
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


module ins_memory(input[31:0]read_adress,output [31:0]instruction);
reg [31:0] mem [31:0];
reg [31:0] ins;
integer i;
initial begin
for(i=0;i<256;i=i+1)
begin
mem [i] =32'b0;
end
end
//initial begin
//mem[0]=32'b00000000001000110001000000100010;   // sub $2, $1, $3      --> $2 = $1 - $3
//mem[1]=32'b00000000010001010110000000100100;  //and $12, $2, $5     --> $12 = $2 & $5
//mem[2]=32'b00000001111011110111000000100000;   //add $14, $15, $15     --> $14 = $15 + $15
//mem[3]=32'b0000001110011100110100000100000; //add $13,$14,$14 -->     $13 = $14 + $14
//mem[4]=32'b10101100010011110000000001100100;     // sw $15, 100($2)     --> Memory[$2 + 100] = $15
//end
//initial begin
//mem[0]=32'b10001100001010100000000000010100;  //  lw $10, 20($1)     --> $10 = Memory[$1 + 20]
//mem[1]=32'b00000000010000110101100000100010; // sub $11, $2, $3    --> $11 = $2 - $3
//mem[2]=32'b00000000011001000110000000100000; //add $12, $3, $4    --> $12 = $3 + $4
//mem[3]=32'b10001100001011010000000000011000;   // lw $13, 24($1)     --> $13 = Memory[$1 + 24]
//end
//initial mem[0] =32'b00010001001010100000000000000100; //beq $t1, $t2, 4


assign instruction =mem[read_adress[31:2]];

endmodule
