`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.06.2019 18:36:27
// Design Name: 
// Module Name: VirtualDS18B20Sensor
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


module DS18B20Mock(
        input CLK_1MHZ,
         input reset,
         input[15:0] temperature,
        input BUS_IN,
        output BUS_OUT,
        output reg checkTemperature
    );
    
    integer  counter = 0;
    reg [3:0]st = 0;
    
    wire timerDone;
    wire readDone;
    wire writeDone;
    
    reg enableTimer;
    reg enableRead;
    reg enableWrite;
    wire enableTimerWire;
    
    wire enableTimerRead;
    wire enableTimerWrite;
    wire[6:0] timerDataWire;
    
    reg busOut = 1'b1;
    wire busOutWrite;
    wire busOutRead;
    
    reg [7:0] writeData;
    reg [6:0] timerData;
    wire [7:0] readData;
    wire [6:0] timerDataRead;
    wire [6:0] timerDataWrite;
    reg reset_ow;
    reg resetRead = 1;
    wire resetReadWire = resetRead & reset;
    //reg [15:0] temperature= 16'b0000011111010000;
    
    
    assign enableTimerWire = enableTimer | enableTimerRead | enableTimerWrite;
    assign timerDataWire = timerData | timerDataRead | timerDataWrite;
    assign BUS_OUT = busOut & busOutWrite & busOutRead;
    
    wire c;
    reg [2:0] byteCounter = 0;
    reg writing2byte;
    
    reg [7:0] temperatureConversionDone = 8'b00000001;
    reg [7:0] emptyByte = 8'b11111111;
    reg [7:0]CRC;
    
    task crcCalc(input [7:0] data);
        integer i;
        reg in_CRC;
       
        begin
            for(i=0;i<8;i=i+1) begin
              in_CRC=data[i]^CRC[0];
              CRC ={in_CRC,CRC[7],CRC[6],CRC[5],CRC[4]^in_CRC,CRC[3]^in_CRC,CRC[2],CRC[1]};
            end
        end    
    endtask
             
    TIMER owTimer(timerDataWire ,enableTimerWire, CLK_1MHZ, timerDone);
     /*
    input [6:0] DATA,
             input LD,
             CLK,
             output reg Z
    */
    
    OW_READ read(CLK_1MHZ, resetReadWire, enableRead,timerDone, BUS_IN, , ,readDone, enableTimerRead, busOutRead, , readData, timerDataRead);
    /*
    input CLK,RST,RX_ACT,Z,BUS_IN,CRC_RST,CRC_EN,
               output reg DONE,LD,
               output BUS_OUT,
               output reg [7:0] CRC,DATA,
               output [6:0] TIME_C);
    */

    OW_WRITE write(CLK_1MHZ, reset, enableWrite, timerDone, writeDone, enableTimerWrite, busOutWrite, writeData, timerDataWrite);
    /*
    input CLK,RST,TX_ACT,Z,
                output reg DONE,LD,
                output BUS_OUT,
                input [7:0] DATA,
                output [6:0] TIME_C
    */
    
    always @(posedge CLK_1MHZ) begin

        if(~BUS_IN ) begin
            counter <= counter + 1;
        end
        else if(counter >= 600) begin
            counter <= 0;
            st <= 4'd1;       
        end
        
        if(BUS_IN)
            counter <= 0;
    end
    
    always @(posedge CLK_1MHZ) begin
        
        case (st)
        4'd0: begin
         resetRead <= 1;
            checkTemperature <= 0; 
            CRC <= 8'b00000000;
            timerData <=0;
            enableTimer <=0;
            enableWrite<=0;
            enableRead <= 0;
            writing2byte <=0;
            busOut <= 1;
        end
        
        4'd1: begin
            timerData <= 7'd6;
            enableTimer <= 1'b1;
            
            if(timerDone)
                st <=  4'd2;
        end
        
       4'd2: begin
            enableTimer <= 1'b0;
            busOut <= 1'b0;
            st <= 4'd3;
            end
        
        4'd3: begin
            timerData <= 7'd20;
            enableTimer <= 1'b1;
            
          if(timerDone)
                st <=  4'd5;
        end
        
        4'd5: begin
            enableTimer <= 1'b0;
            busOut <= 1'b1;
            st <= 4'd6; 
        end
        
        4'd6: begin
            if(~BUS_IN)
              st <= 4'd7;   
       end  
       
        4'd7: begin
            timerData<=0;
            enableRead <= 1;
            if(readDone) begin
            enableRead <= 0;
            checkTemperature <= 1; 
           
                case(readData)
                  8'h44: begin
                        writeData <= temperatureConversionDone;
                        resetRead <= 0;
                        st<= 4'd11;
                    end
                  8'hbe: begin
                        writeData <= temperature[15:8];
                        st<= 4'd8;
                        resetRead <= 0;
                  end
                endcase
            end 
        end
        4'd8: begin
           resetRead <= 1; 
           enableWrite <=1;
           if(writeDone && writing2byte) begin
                crcCalc(writeData);
                enableWrite<=0;         
                st <= 4'd10;
           end
           else  if(writeDone) begin
                enableWrite<=0;
                st <= 4'd9;    
           end  
        
        end
        4'd9: begin
            crcCalc(writeData);
            writing2byte <= 1;
            writeData <= temperature[7:0];
            st<= 4'd8;   
        end
        
         4'd10: begin
           writeData <= emptyByte;
           enableWrite <=1;
           
           if(writeDone) begin
                byteCounter <= byteCounter + 1;
                crcCalc(writeData);
                enableWrite <= 0;
           end
           
           if(writeDone & byteCounter == 3'b101) begin
                st<=4'd11;
                 writeData <= CRC;
           end
         end
         4'd11: begin
            resetRead <= 0;
            byteCounter <= 0;
            enableWrite <=1;
            if(writeDone) begin
                enableWrite<=0;
                st <= 4'd0;
            end    
        end
        endcase
        
                 
    end

endmodule
