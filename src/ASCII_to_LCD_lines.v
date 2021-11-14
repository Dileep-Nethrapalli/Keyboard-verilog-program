`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date:    15:12:35 10/08/2021 
// Design Name: 
// Module Name:    Scancode_to_ASCII 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ASCII_to_LCD_lines(
         output reg [127:0] Line_1, Line_2,
         input  [7:0] ASCII,
         input  [5:0] Char_count,
         input  Clock_100MHz, Reset_n);


 // Enter keyboard output to be displayed on LCD in 
  // strings Line_1 and Line_2.
  always@(negedge Clock_100MHz, negedge Reset_n)
    if(!Reset_n)             
       begin  // Line 1
         Line_1 <= {(16){8'h20}}; 
         Line_2 <= {(16){8'h20}}; 
       end  
    else        
      case(Char_count)       
       1: begin  // Line 1
            Line_1 <= {ASCII, {(15){8'h20}}}; 
            Line_2 <= {(16){8'h20}}; 
          end  
       2: begin 
            Line_1 <= {Line_1[127:120], ASCII, {(14){8'h20}}};
            Line_2 <= {(16){8'h20}}; 
          end 
       3: begin
            Line_1 <= {Line_1[127:112], ASCII, {(13){8'h20}}}; 
            Line_2 <= {(16){8'h20}}; 
          end 
       4: begin 
            Line_1 <= {Line_1[127:104], ASCII, {(12){8'h20}}}; 
            Line_2 <= {(16){8'h20}}; 
          end 
       5: begin 
            Line_1 <= {Line_1[127:96],  ASCII, {(11){8'h20}}}; 
            Line_2 <= {(16){8'h20}}; 
          end 
       6: begin 
            Line_1 <= {Line_1[127:88],  ASCII, {(10){8'h20}}}; 
            Line_2 <= {(16){8'h20}}; 
          end 
       7: begin 
            Line_1 <= {Line_1[127:80],  ASCII, {(9){8'h20}}};  
            Line_2 <= {(16){8'h20}}; 
          end 
       8: begin 
            Line_1 <= {Line_1[127:72],  ASCII, {(8){8'h20}}};  
            Line_2 <= {(16){8'h20}}; 
          end 
       9: begin 
            Line_1 <= {Line_1[127:64],  ASCII, {(7){8'h20}}};  
            Line_2 <= {(16){8'h20}}; 
          end 
      10: begin 
            Line_1 <= {Line_1[127:56],  ASCII, {(6){8'h20}}};  
            Line_2 <= {(16){8'h20}}; 
          end 
      11: begin 
            Line_1 <= {Line_1[127:48],  ASCII, {(5){8'h20}}};  
            Line_2 <= {(16){8'h20}}; 
          end 
      12: begin 
            Line_1 <= {Line_1[127:40],  ASCII, {(4){8'h20}}};  
            Line_2 <= {(16){8'h20}}; 
          end 
      13: begin 
            Line_1 <= {Line_1[127:32],  ASCII, {(3){8'h20}}};  
            Line_2 <= {(16){8'h20}}; 
          end 
      14: begin 
            Line_1 <= {Line_1[127:24],  ASCII, {(2){8'h20}}}; 
            Line_2 <= {(16){8'h20}}; 
          end 
      15: begin 
            Line_1 <= {Line_1[127:16],  ASCII, {(1){8'h20}}};  
            Line_2 <= {(16){8'h20}}; 
          end 
      16: begin 
            Line_1 <= {Line_1[127:8],   ASCII};                
            Line_2 <= {(16){8'h20}}; 
          end       
      17: begin // Line 2
            Line_2 <= {ASCII, {(15){8'h20}}}; 
            Line_1 <= Line_1;
          end  
      18: begin 
            Line_2 <= {Line_2[127:120], ASCII, {(14){8'h20}}}; 
            Line_1 <= Line_1; 
          end 
      19: begin 
            Line_2 <= {Line_2[127:112], ASCII, {(13){8'h20}}}; 
            Line_1 <= Line_1; 
          end 
      20: begin 
            Line_2 <= {Line_2[127:104], ASCII, {(12){8'h20}}}; 
            Line_1 <= Line_1; 
          end 
      21: begin 
            Line_2 <= {Line_2[127:96],  ASCII, {(11){8'h20}}}; 
            Line_1 <= Line_1; 
          end 
      22: begin 
            Line_2 <= {Line_2[127:88],  ASCII, {(10){8'h20}}}; 
            Line_1 <= Line_1; 
          end 
      23: begin 
            Line_2 <= {Line_2[127:80],  ASCII, {(9){8'h20}}};  
            Line_1 <= Line_1; 
          end 
      24: begin 
            Line_2 <= {Line_2[127:72],  ASCII, {(8){8'h20}}};  
            Line_1 <= Line_1; 
          end 
      25: begin 
            Line_2 <= {Line_2[127:64],  ASCII, {(7){8'h20}}};  
            Line_1 <= Line_1; 
          end 
      26: begin 
            Line_2 <= {Line_2[127:56],  ASCII, {(6){8'h20}}};  
            Line_1 <= Line_1; 
          end 
      27: begin 
            Line_2 <= {Line_2[127:48],  ASCII, {(5){8'h20}}};  
            Line_1 <= Line_1; 
          end 
      28: begin 
            Line_2 <= {Line_2[127:40],  ASCII, {(4){8'h20}}};  
            Line_1 <= Line_1; 
          end 
      29: begin 
            Line_2 <= {Line_2[127:32],  ASCII, {(3){8'h20}}};  
            Line_1 <= Line_1; 
          end 
      30: begin 
            Line_2 <= {Line_2[127:24],  ASCII, {(2){8'h20}}};  
            Line_1 <= Line_1; 
          end 
      31: begin 
            Line_2 <= {Line_2[127:16],  ASCII, {(1){8'h20}}};  
            Line_1 <= Line_1; 
          end 
      32: begin 
            Line_2 <= {Line_2[127:8],   ASCII};                
            Line_1 <= Line_1; 
          end
      default: 
        begin 
          Line_1 <= {(16){8'h20}}; 
          Line_2 <= {(16){8'h20}}; 
        end 
     endcase

endmodule
