`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2019 17:10:48
// Design Name: 
// Module Name: ClockDivider
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


module ClockDivider #(parameter desiredFrequency= 1000)(
        input clk,
        output dividedClk
    );
    
    reg dividedClk = 0;
    
    localparam clkFrequency = 100000000; // 100MHz
    localparam divValue = (clkFrequency / (2*desiredFrequency))-1;
    integer counter = 0;
    
    always @(posedge clk) begin
        if(counter == divValue) begin
           counter <= 0;
           dividedClk <= ~dividedClk;
        end
        else
            counter <= counter + 1;
       
    end
    endmodule
