`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2019 21:35:30
// Design Name: 
// Module Name: BuzzerHandler
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


module BuzzerHandler #(beepsAmount = 3) (
        input clk,
        input start,
        output reg enableBuzzer = 0
    );
    
    reg isStarted = 0;
    integer counter = 0;
    always @(posedge start) isStarted <= 1;
    
    always @(clk) begin
        
        if(isStarted) begin
            enableBuzzer <= clk;
        end
        
        if (counter >= beepsAmount) begin
            counter <= 0;
            isStarted <= 0;
            enableBuzzer <= 0;
        end
    end
    
    always @(clk) begin 
        if(isStarted & counter < beepsAmount)
            counter <= counter + 1;
    end
    
    
endmodule
