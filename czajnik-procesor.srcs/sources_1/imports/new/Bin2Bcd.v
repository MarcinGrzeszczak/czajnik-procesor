`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2019 15:09:15
// Design Name: 
// Module Name: Bin2Bcd
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


module Bin2Bcd(
        input clk,
        input [6:0] binaryNumber,
        output reg [11:0] bcdNumber
    );
    
    reg [18:0] shiftReg = 0;
    reg [3:0] iter = 0;
    reg [6:0] currentBinNumber = 0;
    
    reg [3:0] tmpHundreds = 0;
    reg [3:0] tmpTens = 0;
    reg [3:0] tmpOnes = 0;
    
    always @(posedge clk) begin
        if (iter == 0 & currentBinNumber != binaryNumber) begin
            bcdNumber = 12'b000000000000;
            currentBinNumber = binaryNumber;
            shiftReg = {bcdNumber, currentBinNumber};
            
            iter = iter + 1;
        end
        
        if(iter > 0 & iter < 8) begin
            tmpHundreds = shiftReg[18:15];
            tmpTens = shiftReg[14:11];
            tmpOnes = shiftReg[10:7];
            
            if(tmpHundreds >= 5) tmpHundreds = tmpHundreds + 3;
            if(tmpTens >= 5) tmpTens = tmpTens + 3;
            if(tmpOnes >= 5) tmpOnes = tmpOnes + 3;
            
            shiftReg[18:7] = {tmpHundreds, tmpTens, tmpOnes};
            shiftReg = shiftReg << 1;
            iter = iter + 1; 
        end
       
       if(iter >= 8) begin
            bcdNumber = shiftReg[18:7];
            iter = 0;
       end                
    end
    
    endmodule
