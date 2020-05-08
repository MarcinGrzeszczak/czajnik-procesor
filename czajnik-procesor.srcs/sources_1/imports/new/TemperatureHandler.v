`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2019 22:31:17
// Design Name: 
// Module Name: TemperatureHandler
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


module TemperatureHandler(
        input clk,
        input enable,
        input temperatureReady,
        input[6:0] settedTemperature,
        input[6:0] tempratureSensorData,
        output reg comparingFinished=0,
        output reg finished = 0,
        output reg buzzerEnable = 0,
        output reg heaterEnable = 0
    );
    
    reg [2:0]st;
    
    always @(posedge clk) begin
        if(enable)
            st <= 3'd1;
        else begin
            st<= 0;
            heaterEnable <=0;
            finished <=0;
        end
    end
    
    always @(posedge clk) begin
        case (st)
            3'd1: begin
                comparingFinished <=0;
                buzzerEnable <=0;
                if(temperatureReady)
                    st<= 3'd2;
            end
            
            3'd2: begin
                if(tempratureSensorData < settedTemperature) begin
                    heaterEnable <= 1;
                    st<=3'd3;
                end  
                else if(tempratureSensorData >= settedTemperature)  begin
                    heaterEnable <= 0;
                    st<=3'd4;
                end
            end
            
            3'd3: begin
                comparingFinished <=1;
                st<=3'd1;
            end
            
            3'd4: begin
                  comparingFinished <=1;
                  if(finished)
                    st<=3'd1;
                  else
                    st<=3'd5;
            end
            
            3'd5: begin
                 buzzerEnable <= 1;
                 finished <=1;
                 st <= 3'd1;
            end
                
        endcase
    end
        
endmodule
