`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date: 10.07.2020 10:04:28
// Design Name: 
// Module Name: Keyboard
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


module PS2_Keyboard(
          output reg [7:0] ASCII,
          output reg [5:0] Char_count,
          output reg caps_lock_on, shift_on,
          input  PS2_CLK, PS2_DAT, Reset_n);
          
    
   reg [7:0] key_up_code, scan_code;

   
 // FSM for Keyboard    
   reg [5:0] present_state, next_state;
   
   parameter [5:0] 
     RESET = 6'd0,          KEY_UP_START = 6'd1,
     KEY_UP_0 = 6'd2,       KEY_UP_1 = 6'd3,  
     KEY_UP_2 = 6'd4,       KEY_UP_3 = 6'd5,    
     KEY_UP_4 = 6'd6,       KEY_UP_5 = 6'd7,
     KEY_UP_6 = 6'd8,       KEY_UP_7 = 6'd9, 
     KEY_UP_PARITY = 6'd10, KEY_UP_STOP = 6'd11,      
                   
     SCAN_CODE_START = 6'd12, 
     SCAN_CODE_0 = 6'd13, SCAN_CODE_1 = 6'd14,  
     SCAN_CODE_2 = 6'd15, SCAN_CODE_3 = 6'd16,  
     SCAN_CODE_4 = 6'd17, SCAN_CODE_5 = 6'd18,
     SCAN_CODE_6 = 6'd19, SCAN_CODE_7 = 6'd20,     
     SCAN_CODE_PARITY = 6'd21, 
     SCAN_CODE_STOP = 6'd23;
     
     
  // FSM registers
     always@(negedge PS2_CLK, negedge Reset_n)
       if(!Reset_n) 
          present_state <= RESET;
       else
          present_state <= next_state;
          
 // FSM Combinational block
  always@(present_state, PS2_DAT, key_up_code)
   case(present_state)
    RESET: next_state = KEY_UP_START; 
          
    KEY_UP_START:
       if(!PS2_DAT) 
          next_state = KEY_UP_0;                    
       else
          next_state = present_state; 
    KEY_UP_0: next_state = KEY_UP_1;             
    KEY_UP_1: next_state = KEY_UP_2;           
    KEY_UP_2: next_state = KEY_UP_3;             
    KEY_UP_3: next_state = KEY_UP_4;          
    KEY_UP_4: next_state = KEY_UP_5;             
    KEY_UP_5: next_state = KEY_UP_6;           
    KEY_UP_6: next_state = KEY_UP_7;              
    KEY_UP_7: next_state = KEY_UP_PARITY;          
    KEY_UP_PARITY: next_state = KEY_UP_STOP;              
    KEY_UP_STOP:   
       if(key_up_code == 8'hF0)  // F0 = Key up         
          next_state = SCAN_CODE_START;          
       else
          next_state = KEY_UP_START;       
             
    SCAN_CODE_START: 
        if(!PS2_DAT) 
           next_state = SCAN_CODE_0;                    
        else
           next_state = present_state; 
    SCAN_CODE_0: next_state = SCAN_CODE_1;             
    SCAN_CODE_1: next_state = SCAN_CODE_2;           
    SCAN_CODE_2: next_state = SCAN_CODE_3;             
    SCAN_CODE_3: next_state = SCAN_CODE_4;          
    SCAN_CODE_4: next_state = SCAN_CODE_5;             
    SCAN_CODE_5: next_state = SCAN_CODE_6;           
    SCAN_CODE_6: next_state = SCAN_CODE_7;              
    SCAN_CODE_7: next_state = SCAN_CODE_PARITY;          
    SCAN_CODE_PARITY: next_state = SCAN_CODE_STOP;        
    SCAN_CODE_STOP: next_state = KEY_UP_START;
        
    default: next_state = RESET; 
   endcase 
         
 
 //Capture Keyboard output data      
   always@(negedge PS2_CLK, negedge Reset_n)
    if(!Reset_n)
       begin
         key_up_code <= {8{1'b0}};
         scan_code   <= {8{1'b0}}; 
       end 
    else 
      case(present_state)
        KEY_UP_0: key_up_code[0] <= PS2_DAT;
        KEY_UP_1: key_up_code[1] <= PS2_DAT;
        KEY_UP_2: key_up_code[2] <= PS2_DAT;
        KEY_UP_3: key_up_code[3] <= PS2_DAT;
        KEY_UP_4: key_up_code[4] <= PS2_DAT;
        KEY_UP_5: key_up_code[5] <= PS2_DAT;
        KEY_UP_6: key_up_code[6] <= PS2_DAT;
        KEY_UP_7: key_up_code[7] <= PS2_DAT;          
      
        SCAN_CODE_0: scan_code[0] <= PS2_DAT; 
        SCAN_CODE_1: scan_code[1] <= PS2_DAT;
        SCAN_CODE_2: scan_code[2] <= PS2_DAT;
        SCAN_CODE_3: scan_code[3] <= PS2_DAT;
        SCAN_CODE_4: scan_code[4] <= PS2_DAT;
        SCAN_CODE_5: scan_code[5] <= PS2_DAT;
        SCAN_CODE_6: scan_code[6] <= PS2_DAT;
        SCAN_CODE_7: scan_code[7] <= PS2_DAT;
      endcase  
 
 /*
 // Generate shift on signal
  always@(posedge PS2_CLK, negedge Reset_n)
    if(!Reset_n)                
       shift_on <= 0; 
    else if((present_state == KEY_UP_PARITY) &&
            ((scan_code == 8'h12) || 
             (scan_code == 8'h59))) 
       shift_on <= 1;
    else if(present_state == SCAN_CODE_STOP)  
       shift_on <= 0;    
  */

 
 // Generate shift on signal
   always@(posedge PS2_CLK, negedge Reset_n)
     if(!Reset_n)                
        shift_on <= 0; 
     else if((present_state == SCAN_CODE_PARITY) &&
             ((scan_code == 8'h12) || 
              (scan_code == 8'h59))) 
        shift_on <= ~shift_on;
             
  
  // Generate caps lock on signal
    always@(posedge PS2_CLK, negedge Reset_n)
      if(!Reset_n)                
         caps_lock_on <= 0; 
      else if((present_state == SCAN_CODE_PARITY) &&
              (scan_code == 8'h58))
         caps_lock_on <= ~caps_lock_on;   
         
       
 // count number of characters entered      
  always@(posedge PS2_CLK, negedge Reset_n)
    if(!Reset_n)             
       Char_count <= 0; 
    else if(present_state == SCAN_CODE_PARITY)
      if(scan_code[7:0] == 8'h58) // caps lock on
         Char_count <= Char_count;   
      else if(scan_code[7:0] == 8'h66) // Back space
         Char_count <= Char_count - 1;           
      else if(Char_count == 32) // 32 characters enterd
         Char_count <= 1;                  
      else                        
         Char_count <= Char_count + 1;  


  // Convert keyboard generated scan code to 
   // ASCII code for LCD
 always@(posedge PS2_CLK, negedge Reset_n)
   if(!Reset_n)             
     ASCII <= 0; 
   else if(present_state == SCAN_CODE_PARITY)
    if(caps_lock_on && shift_on) 
     case(scan_code) 
      // scan code    // ASCII                  
       8'h0E: ASCII <= 8'h7E; // ~               
       8'h16: ASCII <= 8'h21; // !       
       8'h1E: ASCII <= 8'h40; // @       
       8'h26: ASCII <= 8'h23; // #       
       8'h25: ASCII <= 8'h24; // $       
       8'h2E: ASCII <= 8'h25; // %       
       8'h36: ASCII <= 8'h5E; // ^       
       8'h3D: ASCII <= 8'h26; // &       
       8'h3E: ASCII <= 8'h2A; // *       
       8'h46: ASCII <= 8'h28; // ( 
       8'h45: ASCII <= 8'h29; // ) 
       8'h4E: ASCII <= 8'h5F; // _ 
       8'h55: ASCII <= 8'h2B; // + 
       8'h5D: ASCII <= 8'h7C; // |          
       8'h15: ASCII <= 8'h71; // q               
       8'h1D: ASCII <= 8'h77; // w       
       8'h24: ASCII <= 8'h65; // e       
       8'h2D: ASCII <= 8'h72; // r       
       8'h2C: ASCII <= 8'h74; // t       
       8'h35: ASCII <= 8'h79; // y       
       8'h3C: ASCII <= 8'h75; // u      
       8'h43: ASCII <= 8'h69; // i       
       8'h44: ASCII <= 8'h6F; // o      
       8'h4D: ASCII <= 8'h70; // p
       8'h54: ASCII <= 8'h7B; // { 
       8'h5B: ASCII <= 8'h7D; // }           
       8'h1C: ASCII <= 8'h61; // a 
       8'h1B: ASCII <= 8'h73; // s              
       8'h23: ASCII <= 8'h64; // d      
       8'h2B: ASCII <= 8'h66; // f      
       8'h34: ASCII <= 8'h67; // g       
       8'h33: ASCII <= 8'h68; // h       
       8'h3B: ASCII <= 8'h6A; // j      
       8'h42: ASCII <= 8'h6B; // k     
       8'h4B: ASCII <= 8'h6C; // l     
       8'h4C: ASCII <= 8'h3A; // :     
       8'h52: ASCII <= 8'h22; // " 
       8'h1A: ASCII <= 8'h7A; // z
       8'h22: ASCII <= 8'h78; // x 
       8'h21: ASCII <= 8'h63; // c              
       8'h2A: ASCII <= 8'h76; // v      
       8'h32: ASCII <= 8'h62; // b      
       8'h31: ASCII <= 8'h6E; // n       
       8'h3A: ASCII <= 8'h6D; // m       
       8'h41: ASCII <= 8'h3C; // <      
       8'h49: ASCII <= 8'h3E; // >     
       8'h4A: ASCII <= 8'h3F; // ? 
       8'h29: ASCII <= 8'h20; // Space  
       8'h58: ASCII <= 8'h20; // Caps Lock
     endcase 
    else if(caps_lock_on)   
     case(scan_code) 
       8'h0E: ASCII <= 8'h60; // `               
       8'h16: ASCII <= 8'h31; // 1       
       8'h1E: ASCII <= 8'h32; // 2       
       8'h26: ASCII <= 8'h33; // 3       
       8'h25: ASCII <= 8'h34; // 4       
       8'h2E: ASCII <= 8'h35; // 5       
       8'h36: ASCII <= 8'h36; // 6       
       8'h3D: ASCII <= 8'h37; // 7       
       8'h3E: ASCII <= 8'h38; // 8       
       8'h46: ASCII <= 8'h39; // 9 
       8'h45: ASCII <= 8'h30; // 0 
       8'h4E: ASCII <= 8'hB0; // - 
       8'h55: ASCII <= 8'h3D; // = 
       8'h5D: ASCII <= 8'hA4; // \               
       8'h15: ASCII <= 8'h51; // Q              
       8'h1D: ASCII <= 8'h57; // W      
       8'h24: ASCII <= 8'h45; // E       
       8'h2D: ASCII <= 8'h52; // R       
       8'h2C: ASCII <= 8'h54; // T       
       8'h35: ASCII <= 8'h59; // Y       
       8'h3C: ASCII <= 8'h55; // U      
       8'h43: ASCII <= 8'h49; // I       
       8'h44: ASCII <= 8'h4F; // O      
       8'h4D: ASCII <= 8'h50; // P
       8'h54: ASCII <= 8'h5B; // [ 
       8'h5B: ASCII <= 8'h5D; // ] 
       8'h1C: ASCII <= 8'h41; // A 
       8'h1B: ASCII <= 8'h53; // S              
       8'h23: ASCII <= 8'h44; // D      
       8'h2B: ASCII <= 8'h46; // F      
       8'h34: ASCII <= 8'h47; // G      
       8'h33: ASCII <= 8'h48; // H       
       8'h3B: ASCII <= 8'h4A; // J      
       8'h42: ASCII <= 8'h4B; // K     
       8'h4B: ASCII <= 8'h4C; // L     
       8'h4C: ASCII <= 8'h3B; // ;     
       8'h52: ASCII <= 8'h27; // ' 
       8'h1A: ASCII <= 8'h5A; // Z
       8'h22: ASCII <= 8'h58; // X 
       8'h21: ASCII <= 8'h43; // C              
       8'h2A: ASCII <= 8'h56; // V      
       8'h32: ASCII <= 8'h42; // B      
       8'h31: ASCII <= 8'h4E; // N       
       8'h3A: ASCII <= 8'h4D; // M       
       8'h41: ASCII <= 8'h2C; // ,      
       8'h49: ASCII <= 8'h2E; // .     
       8'h4A: ASCII <= 8'h2F; // / 
       8'h29: ASCII <= 8'h20; // Space 
       8'h58: ASCII <= 8'h20; // Caps Lock
     endcase         
    else if(shift_on)  
     case(scan_code)         
       8'h0E: ASCII <= 8'h7E; // ~               
       8'h16: ASCII <= 8'h21; // !       
       8'h1E: ASCII <= 8'h40; // @       
       8'h26: ASCII <= 8'h23; // #       
       8'h25: ASCII <= 8'h24; // $       
       8'h2E: ASCII <= 8'h25; // %       
       8'h36: ASCII <= 8'h5E; // ^       
       8'h3D: ASCII <= 8'h26; // &       
       8'h3E: ASCII <= 8'h2A; // *       
       8'h46: ASCII <= 8'h28; // ( 
       8'h45: ASCII <= 8'h29; // ) 
       8'h4E: ASCII <= 8'h5F; // _ 
       8'h55: ASCII <= 8'h2B; // + 
       8'h5D: ASCII <= 8'h7C; // |          
       8'h15: ASCII <= 8'h51; // Q              
       8'h1D: ASCII <= 8'h57; // W      
       8'h24: ASCII <= 8'h45; // E       
       8'h2D: ASCII <= 8'h52; // R       
       8'h2C: ASCII <= 8'h54; // T       
       8'h35: ASCII <= 8'h59; // Y       
       8'h3C: ASCII <= 8'h55; // U      
       8'h43: ASCII <= 8'h49; // I       
       8'h44: ASCII <= 8'h4F; // O      
       8'h4D: ASCII <= 8'h50; // P
       8'h54: ASCII <= 8'h7B; // { 
       8'h5B: ASCII <= 8'h7D; // } 
       8'h1C: ASCII <= 8'h41; // A 
       8'h1B: ASCII <= 8'h53; // S              
       8'h23: ASCII <= 8'h44; // D      
       8'h2B: ASCII <= 8'h46; // F      
       8'h34: ASCII <= 8'h47; // G      
       8'h33: ASCII <= 8'h48; // H       
       8'h3B: ASCII <= 8'h4A; // J      
       8'h42: ASCII <= 8'h4B; // K     
       8'h4B: ASCII <= 8'h4C; // L     
       8'h4C: ASCII <= 8'h3A; // :     
       8'h52: ASCII <= 8'h22; // " 
       8'h1A: ASCII <= 8'h5A; // Z
       8'h22: ASCII <= 8'h58; // X 
       8'h21: ASCII <= 8'h43; // C              
       8'h2A: ASCII <= 8'h56; // V      
       8'h32: ASCII <= 8'h42; // B      
       8'h31: ASCII <= 8'h4E; // N       
       8'h3A: ASCII <= 8'h4D; // M       
       8'h41: ASCII <= 8'h3C; // <      
       8'h49: ASCII <= 8'h3E; // >     
       8'h4A: ASCII <= 8'h3F; // ? 
       8'h29: ASCII <= 8'h20; // Space  
       8'h58: ASCII <= 8'h20; // Caps Lock
     endcase 
    else  // caps lock off and shift off
     case(scan_code)           
       8'h0E: ASCII <= 8'h60; // `               
       8'h16: ASCII <= 8'h31; // 1       
       8'h1E: ASCII <= 8'h32; // 2       
       8'h26: ASCII <= 8'h33; // 3       
       8'h25: ASCII <= 8'h34; // 4       
       8'h2E: ASCII <= 8'h35; // 5       
       8'h36: ASCII <= 8'h36; // 6       
       8'h3D: ASCII <= 8'h37; // 7       
       8'h3E: ASCII <= 8'h38; // 8       
       8'h46: ASCII <= 8'h39; // 9 
       8'h45: ASCII <= 8'h30; // 0 
       8'h4E: ASCII <= 8'hB0; // - 
       8'h55: ASCII <= 8'h3D; // = 
       8'h5D: ASCII <= 8'hA4; // \
       8'h15: ASCII <= 8'h71; // q               
       8'h1D: ASCII <= 8'h77; // w       
       8'h24: ASCII <= 8'h65; // e       
       8'h2D: ASCII <= 8'h72; // r       
       8'h2C: ASCII <= 8'h74; // t       
       8'h35: ASCII <= 8'h79; // y       
       8'h3C: ASCII <= 8'h75; // u      
       8'h43: ASCII <= 8'h69; // i       
       8'h44: ASCII <= 8'h6F; // o      
       8'h4D: ASCII <= 8'h70; // p
       8'h54: ASCII <= 8'h5B; // [ 
       8'h5B: ASCII <= 8'h5D; // ] 
       8'h1C: ASCII <= 8'h61; // a 
       8'h1B: ASCII <= 8'h73; // s              
       8'h23: ASCII <= 8'h64; // d      
       8'h2B: ASCII <= 8'h66; // f      
       8'h34: ASCII <= 8'h67; // g       
       8'h33: ASCII <= 8'h68; // h       
       8'h3B: ASCII <= 8'h6A; // j      
       8'h42: ASCII <= 8'h6B; // k     
       8'h4B: ASCII <= 8'h6C; // l     
       8'h4C: ASCII <= 8'h3B; // ;     
       8'h52: ASCII <= 8'h27; // ' 
       8'h1A: ASCII <= 8'h7A; // z
       8'h22: ASCII <= 8'h78; // x 
       8'h21: ASCII <= 8'h63; // c              
       8'h2A: ASCII <= 8'h76; // v      
       8'h32: ASCII <= 8'h62; // b      
       8'h31: ASCII <= 8'h6E; // n       
       8'h3A: ASCII <= 8'h6D; // m       
       8'h41: ASCII <= 8'h2C; // ,      
       8'h49: ASCII <= 8'h2E; // .     
       8'h4A: ASCII <= 8'h2F; // /
       8'h29: ASCII <= 8'h20; // Space  
       8'h58: ASCII <= 8'h20; // Caps Lock
     endcase  
 
  endmodule
