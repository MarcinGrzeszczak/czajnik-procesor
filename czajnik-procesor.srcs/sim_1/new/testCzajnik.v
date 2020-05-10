`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.05.2020 14:55:12
// Design Name: 
// Module Name: testCzajnik
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


module testCzajnik;

localparam tempDelta = 7'b0000001;

reg clk_100Mhz = 0;
reg CLK_1MHZ = 0;
reg [6:0] temperatureSensorData = 0;
reg[15:0] temperature = 0;
wire rst;
wire reset_therm;
wire BUS_OW;
reg RST_OW;
wire BUS_IN;
wire BUS_OUT;
wire checkTemperature;


reg [6:0] settedTemp;
reg start;
reg enableMaintain;
wire [6:0] outputTemp;
wire enableHeater;

assign rst = RST_OW & reset_therm; 

bufif0(BUS_OW,1'b0,BUS_OUT);
assign BUS_IN = BUS_OW === 1'bZ ? 1'b1 : 1'b0;

initial begin
    RST_OW = 1;
    start = 0;
    enableMaintain = 0;
    settedTemp = 7'b0110010;
    #10 RST_OW = 0;
    #530 RST_OW = 1;
    #600 start = 1;
   // #650 start = 0;
end


always
    #5 clk_100Mhz = ~clk_100Mhz;

always
    #500 CLK_1MHZ = ~CLK_1MHZ;

always @(posedge clk_100Mhz) begin
    if(enableHeater)
       #5000000 temperatureSensorData = temperatureSensorData + tempDelta;
    else if ( temperatureSensorData > 0)
       #5000000 temperatureSensorData = temperatureSensorData - tempDelta;     
 end
 
  always @(posedge checkTemperature) begin
    temperature <= {5'b00000,temperatureSensorData,4'd0000} ;
 end

 DS18B20Mock sensorMock(CLK_1MHZ, rst, temperature , BUS_IN, BUS_OUT, checkTemperature);

 czajnik czajnik1(clk_100Mhz,BUS_OW,RST_OW,settedTemp,start,enableMaintain,reset_therm,outputTemp,enableHeater);
    /*
      input clk_100MHz,
      inout BUS_OW,
      input RESET_OW,
      input [6:0] settedTemp,
      input start,
      input enableMaintain,
      output reset_therm,
      output [6:0]currTemp,
      output enableHeater
    */
endmodule
