`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2019 18:59:37
// Design Name: 
// Module Name: ButtonHandler
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


module ButtonHandler(
        input increaseHeatButton,
        input changeButtonSetting,
        input reset,
        output[6:0] settedTemperature,
        output reg enable =0
       );
       
       wire[6:0] currentTemperature;
       localparam temperatureDelta = 7'b0011001; //25
       localparam maxTemeprature = 7'b1100100; //100
       assign settedTemperature = currentTemperature;
       
       IncreaseTemperature increaseTemp(increaseHeatButton, reset, temperatureDelta, maxTemeprature, currentTemperature);
       
       always @(currentTemperature[6:0])
          if(currentTemperature[6:0] == 0 | changeButtonSetting)
            enable <= 0;
          else
            enable <= 1;
       
        
endmodule
