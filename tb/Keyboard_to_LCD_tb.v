`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:27:46 12/31/2020
// Design Name:   Keyboard_top
// Module Name:   D:/Dileep/Keyboard_to_LCD_Test2/run/lcd/Keyboard_LCD_tb.v
// Project Name:  lcd
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Keyboard_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Keyboard_to_LCD_tb;

	// Inputs
	reg PS2_CLK;
	reg PS2_DAT;
	reg Clock_100MHz;
	reg Reset_n;

	// Outputs
	wire [7:4] LCD_DB;
	wire LCD_E;
	wire LCD_RS;
	wire LCD_RW;
	wire Caps_Lock;
	wire Shift_on;

	// Instantiate the Unit Under Test (UUT)
	Keyboard_to_LCD_top uut (
		.LCD_DB(LCD_DB), 
		.LCD_E(LCD_E), 
		.LCD_RS(LCD_RS), 
		.LCD_RW(LCD_RW), 
		.Caps_Lock(Caps_Lock), 
		.Shift_on(Shift_on), 
		.PS2_CLK(PS2_CLK), 
		.PS2_DAT(PS2_DAT), 
		.Clock_100MHz(Clock_100MHz), 
		.Reset_n(Reset_n)
	);
   
   initial Clock_100MHz = 0;
   always #5 Clock_100MHz = ~Clock_100MHz;
   
  // 5000 = 1_0011_1000_1000b 
   reg [12:0] count_5000;
   
   always@(posedge Clock_100MHz, negedge Reset_n)
     if(!Reset_n)
       begin
         count_5000 <= 0;
         PS2_CLK = 0;
       end
     else if(count_5000 == 5000)
       begin
         count_5000 <= 0;
         PS2_CLK <= ~PS2_CLK;
       end 
     else      
        count_5000 <= count_5000 + 1;
        
        
   always@(PS2_CLK,count_5000)      
     if((PS2_CLK == 0) && (count_5000 == 2500)) 
        PS2_DAT = $random;       
    

   wire [5:0]  present_state;
   wire [21:0] count_20ms; 
   
   assign present_state = uut.keyboard_DUT.present_state; 

	initial begin
		// Initialize Inputs
		PS2_CLK = 0;
		PS2_DAT = 0;		
		Reset_n = 0;

		// Wait 100 ns for global reset to finish
		#100;
       Reset_n = 1; 
		// Add stimulus here

	end
      
endmodule

