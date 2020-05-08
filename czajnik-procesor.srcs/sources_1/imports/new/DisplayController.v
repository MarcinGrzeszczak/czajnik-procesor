`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2019 00:10:39
// Design Name: 
// Module Name: DisplayController
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


module DisplayController(
    input clk_10kHz,
    input [11:0] data,
    output reg [2:0] displayNumber,
    output reg [6:0] ledsOutput
    );
    
    reg [1:0] refreshCnt;
    reg [3:0] number;
    
    always @(posedge clk_10kHz)
    if(refreshCnt < 2'b11)
        refreshCnt <= refreshCnt+1;
    else 
        refreshCnt <= 0;  
    
    always @(refreshCnt)
        begin
            if(refreshCnt == 2'b00)
                begin
                    number <= data[11:8];
                    displayNumber <= 3'b110;
                end
            
            if (refreshCnt == 2'b01)
                begin
                    number <= data[7:4];
                    displayNumber <= 3'b101;
                end
            
            if (refreshCnt == 2'b10)
                begin
                    number <= data[3:0];
                    displayNumber <= 3'b011;
                end
                
     end
    
       always @(number)
        begin
            case(number)
                4'b0000 : ledsOutput <= 7'b1000000; //0
                4'b0001 : ledsOutput <= 7'b1111001; //1
                4'b0010 : ledsOutput <= 7'b0100100; //2
                4'b0011 : ledsOutput <= 7'b0110000; //3
                4'b0100 : ledsOutput <= 7'b0011001; //4
                4'b0101 : ledsOutput <= 7'b0010010; //5
                4'b0110 : ledsOutput <= 7'b0000010; //6
                4'b0111 : ledsOutput <=7'b1111000; //7
                4'b1000 : ledsOutput <= 7'b0000000; //8
                4'b1001 : ledsOutput <= 7'b0010000; //9
                default : ledsOutput <= 7'b0111111;
            endcase
        end
endmodule
