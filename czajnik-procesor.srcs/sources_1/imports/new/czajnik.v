`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2019 13:10:34
// Design Name: 
// Module Name: top
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


module czajnik(
      input clk_100MHz,
      inout BUS_OW,
      input RESET_OW,
      input [6:0] settedTemp,
      input start,
      input enableMaintain,
      output reset_therm,
      output[3:0] currTempONES,
      output[3:0] currTempTENS,
      output[3:0] currTempHUNDREDS,
      output enableHeater
    );
    
    wire clk_1Hz;
    wire clk_1MHz;
    
    wire resetDS18B20;
    wire BUS_IN;
    wire BUS_OUT;
    wire ACK_reading;
    wire RDY_reading;
    
    wire [15:0] sensorData;
    wire [6:0] currentTemperature;
    wire [11:0] bcdCurrentTemperature;
    wire reset;
    wire temperatureHandlerFinished;
   
   assign currTempONES = bcdCurrentTemperature[3:0];
   assign currTempTENS = bcdCurrentTemperature[7:3];
   assign currTempHUNDREDS = bcdCurrentTemperature[11:7];
   
   assign reset = resetDS18B20 & RESET_OW;
   bufif0(BUS_OW,1'b0,BUS_OUT);
   assign BUS_IN = BUS_OW === 1'bZ ? 1'b1 : 1'b0;
   assign reset_therm = reset; 
   
    ClockDivider #(1) clockDivider_1Hz (clk_100MHz, clk_1Hz);
    ClockDivider #(1000000) clockDivider_1Mhz(clk_100MHz, clk_1MHz);
      
    DS18B20 t_controller(clk_100MHz, clk_1MHz, reset, BUS_IN, , BUS_OUT, , RDY_reading, sensorData[15:8], sensorData[7:0]);
    EnableThermometer enableThermometer(clk_100MHz, ACK_reading, resetDS18B20);
    /*
    input CLK,
    input CLK_1MHZ,
    input RST,
    input BUS_IN,
    input ACK,
    output BUS_OUT,
    output OW_RST_STAT,
    output reg RDY,
    output reg [7:0] BYTE0,
    output reg [7:0] BYTE1
    */
    FD tempFd (sensorData[10:4], RDY_reading, currentTemperature);
    TemperatureHandler temperatureHandler(clk_100MHz, start, RDY_reading, settedTemp, currentTemperature, ACK_reading, temperatureHandlerFinished, enableHeater);
    /*
        input clk,
        input enable,
        input temperatureReady,
        input[6:0] settedTemperature,
        input[6:0] tempratureSensorData,
        output reg comparingFinished,
        output reg finished = 0,
        output reg buzzerEnable = 0,
        output reg heaterEnable = 0
    */
    
    
    Bin2Bcd bcd(clk_100MHz,currentTemperature, bcdCurrentTemperature);
    /*
        input clk,
        input [6:0] binaryNumber,
        output reg [11:0] bcdNumber
    */
    
endmodule
