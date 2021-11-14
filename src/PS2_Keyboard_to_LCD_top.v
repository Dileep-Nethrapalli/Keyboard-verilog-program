`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date: 10.07.2020 17:42:43
// Design Name: 
// Module Name: Keyboard_top
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


module PS2_Keyboard_to_LCD_top(
         output [7:4] LCD_DB,
         output LCD_E, LCD_RS, LCD_RW, 
         output Caps_Lock, Shift_on,         
         input  PS2_CLK, PS2_DAT,
         input  Clock_100MHz, Reset_n);          
         
         wire [5:0] char_count;
         wire [7:0] ascii; 
         wire [127:0] line_1, line_2;
         
         
  PS2_Keyboard keyboard_DUT(
     .ASCII(ascii), .Char_count(char_count),
     .PS2_CLK(PS2_CLK), .PS2_DAT(PS2_DAT), 
     .caps_lock_on(Caps_Lock), .shift_on(Shift_on),
     .Reset_n(Reset_n)); 
     
   
  ASCII_to_LCD_lines lcd_lines_DUT(
    .Line_1(line_1), .Line_2(line_2),
    .ASCII(ascii), .Char_count(char_count), 
    .Clock_100MHz(Clock_100MHz), .Reset_n(Reset_n)); 
  
  
  LCD_controller_16x2 lcd_for_keyboard_DUT(
     .LCD_DB(LCD_DB), .LCD_E(LCD_E), .LCD_RS(LCD_RS), 
     .LCD_RW(LCD_RW), .Line_1(line_1), .Line_2(line_2),
     .Clock_100MHz(Clock_100MHz), .Clear_n(Reset_n));   
                      
endmodule
