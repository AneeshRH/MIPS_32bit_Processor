`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2026 16:12:46
// Design Name: 
// Module Name: arithmetic_ctrl_unit
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

module arithmetic_ctrl_unit(
    input [1:0] op_code_ctrl,
    input [5:0] function_field,
    output reg [3:0] alu_cmd_out
);

always @(*) begin
    casex({op_code_ctrl, function_field})
        8'b00xxxxxx: alu_cmd_out = 4'b0010;
        8'b01xxxxxx: alu_cmd_out = 4'b0110;
        8'b10100000: alu_cmd_out = 4'b0010;
        8'b10100010: alu_cmd_out = 4'b0110;
        8'b10100100: alu_cmd_out = 4'b0000;
        8'b10100101: alu_cmd_out = 4'b0001;
        8'b10101010: alu_cmd_out = 4'b0111;
        default: alu_cmd_out = 4'b1111;
    endcase
end

endmodule
