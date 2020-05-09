`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.05.2020 01:54:08
// Design Name: 
// Module Name: MuxIn
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


module MuxIn(
    input CLK_50MHz,
    input rst,
    input [1:0] port_id,
    input l_0,
    input l_1,
    input l_2,
    input [6:0] l_3,
    output [7:0] port_out
);

wire CLK_50Mhz,rst,l_0,l_1,l_2;
wire [1:0] port_id;
wire [6:0] l_3;
reg [7:0] mux_out, port_out;

always @(*) begin
    case (port_id[1:0])
        0: mux_out = {7'bxxxxxx,l_0};
        1: mux_out = {7'bxxxxxx,l_1};
        2: mux_out = {7'bxxxxxx,l_2};
        3: mux_out = {1'bx,l_3};
        default: mux_out = 8'bxxxxxxxx;
    endcase
end

always @(posedge CLK_50MHz) begin
    if(rst) begin
        port_out <= 8'b00000000;
    end 
    else begin
        port_out <= mux_out;
    end
end

endmodule
