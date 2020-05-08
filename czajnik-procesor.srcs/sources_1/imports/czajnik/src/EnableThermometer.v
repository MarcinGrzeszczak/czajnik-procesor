`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2019 21:15:04
// Design Name: 
// Module Name: EnableThermometer
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


module EnableThermometer(
        input clk,
        input trigger,
        output reg start = 1
    );
    
    reg isTriggered = 0;
    
    always @(posedge trigger)
            isTriggered <= 1;
            
    always @(posedge clk)
            if(isTriggered) begin
                start <=0;
                isTriggered <= 0;
            end
            else
                start <= 1;
endmodule
