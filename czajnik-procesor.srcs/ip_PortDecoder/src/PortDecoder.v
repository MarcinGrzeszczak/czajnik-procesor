`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.05.2020 23:44:22
// Design Name: 
// Module Name: PortDecoder
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


module PortDecoder(
       input clk,
       input rst,
       input [7:0] portId,
       input readStrobe,
       output enTemp,
       output enControl,
       output enDisplay
    );
    
    reg enTemp_reg, enControl_reg, enDisplay_reg;
    reg [2:0]O;
    
    always @(*) begin 
        case(portId[1:0]) 
            2'b00: O <= 3'b001;
            2'b01: O <= 3'b010;
            2'b10: O <= 3'b100;
            default: O <= 3'bxxx;
        endcase
    end
    
    always @(posedge clk) begin
        if(rst) begin
           O <= 3'b000;
        end

        enTemp_reg <= O[0];
        enControl_reg <= O[1];
        enDisplay_reg <= O[2];

    end
    
    and a1(enTemp, enTemp_reg, readStrobe);
    and a2(enControl, enControl_reg, readStrobe);
    and a3(enDisplay, enDisplay_reg, readStrobe);
      
endmodule
