`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2019 19:05:21
// Design Name: 
// Module Name: EnableHeatMaintain
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


module EnableHeatMaintain(
        input switchSignal,
        input reset,
        output reg enable = 0
    );
      
    always @(posedge switchSignal or posedge reset)
        if(reset)
            enable <= 0;
        else
            enable <= ~enable;
        
endmodule
