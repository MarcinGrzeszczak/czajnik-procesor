`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2019 16:39:34
// Design Name: 
// Module Name: IncreaseTemperature
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


module IncreaseTemperature(
        input increaseSignal,
        input reset,
        input[6:0] increaseDelta,
        input[6:0] maxTemperature,
        output reg[6:0] currentTemperature = 0
    );
    
    always @(posedge increaseSignal or posedge reset) begin
        if(currentTemperature >= maxTemperature | reset)
            currentTemperature <= 0;
        else
            currentTemperature <= currentTemperature + increaseDelta;
    end
endmodule
