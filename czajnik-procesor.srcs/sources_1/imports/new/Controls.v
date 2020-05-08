`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2019 19:28:14
// Design Name: 
// Module Name: Controls
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


module Controls(
        input clk_1Hz,
        input increaseHeatButton,
        input heatMaintainButton,
        input reset,
        output displayRequired,
        output [6:0] settedTemperature,
        output start
    );
    
    wire changeButtonSignal;
    wire enableTimer;
    wire resetTimer;
    wire heatMaintainSignal;
    wire finishedHeatngMeaintain;
    wire enableHeatMaintainTimer;
    wire startSignal;
    wire resetAll;
    
    buf resetTimerBuf(resetTimer, increaseHeatButton);
    buf changeButtonSignalBuf(changeButtonSignal, startSignal);
    buf(start, startSignal);
    
    buf(resetAll, finishedHeatngMeaintain);
    bufif0(resetAll, reset, heatMaintainSignal);
    
    and (enableHeatMaintainTimer, reset, heatMaintainSignal);
    and (displayRequired,enableTimer, ~startSignal);
    
    EnableHeatMaintain enableHeatMaintain(heatMaintainButton, resetAll, heatMaintainSignal);
    ButtonHandler increaseHeatButtonController(increaseHeatButton, changeButtonSignal, resetAll, settedTemperature, enableTimer);
    /*
      input increaseHeatButton,
        input changeButtonSetting,
        input reset,
        output[6:0] settedTemperature,
        output reg enable =0
    */
    
    SecondsCounter #(2) enableTimer_2s(clk_1Hz, enableTimer, resetTimer, startSignal);
    SecondsCounter #(2) heatMaintainTimer(clk_1Hz, enableHeatMaintainTimer, ,finishedHeatngMeaintain);
    /*
           input clk_1Hz,
        input enable,
        input reset,
        output reg done = 0
    */
endmodule
