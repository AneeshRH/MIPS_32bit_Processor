`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2026 21:41:41
// Design Name: 
// Module Name: arithmetic_logic_core
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

module arithmetic_logic_core(
    input [3:0] ctrl_operation,
    input [31:0] src_a, src_b,
    output [31:0] result_val,
    output is_zero_flag
);
    
    reg [31:0] calc_result;  

    always @(*) begin
        case(ctrl_operation)
            4'b0000: calc_result = src_a & src_b;
            4'b0001: calc_result = src_a | src_b;
            4'b0010: calc_result = src_a + src_b;
            4'b0110: calc_result = src_a - src_b;
            4'b0111: calc_result = src_a > src_b;
            4'b1100: calc_result = ~(src_a | src_b);
            default: calc_result = src_a + src_b;
        endcase
    end
 
    assign result_val = calc_result;
    assign is_zero_flag = (result_val == 32'b0);

endmodule
