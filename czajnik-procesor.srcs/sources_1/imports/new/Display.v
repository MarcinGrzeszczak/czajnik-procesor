`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2019 13:24:36
// Design Name: 
// Module Name: Display
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


module Display(
    input clk_100Mhz,
    input [6:0] number,
    output [2:0] displayNumber,
    output [6:0] ledsOutput
    );
    
    wire [11:0] bcdNumber;
    wire clk_10kHz;
    
    Bin2Bcd bin2BcdConverter(clk_100Mhz, number, bcdNumber);
    ClockDivider #(10000) clockDivider_10kHz(clk_100Mhz, clk_10kHz);
    
    DisplayController displayController(clk_10kHz, bcdNumber, displayNumber, ledsOutput);
        
endmodule
