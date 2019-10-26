module SEG7_LUT (
//**********************************************************/		
//******************input & output**************************/
//**********************************************************/	
  input      [3:0] num_ten,
  output reg [6:0] led_ten_hex1,
  input      [3:0] num_one,
  output reg [6:0] led_one_hex0
);


//the 7-segment Displays the ten of the number in HEX1
always@(num_ten) 
begin
  case(num_ten)
    4'h0: led_ten_hex1 = 7'b1000000;
    4'h1: led_ten_hex1 = 7'b1111001;  
    4'h2: led_ten_hex1 = 7'b0100100;  
    4'h3: led_ten_hex1 = 7'b0110000;  
    4'h4: led_ten_hex1 = 7'b0011001; 
    4'h5: led_ten_hex1 = 7'b0010010; 
    4'h6: led_ten_hex1 = 7'b0000010;  
    4'h7: led_ten_hex1 = 7'b1111000; 
    4'h8: led_ten_hex1 = 7'b0000000;  
    4'h9: led_ten_hex1 = 7'b0010000;  
    4'ha: led_ten_hex1 = 7'b1111111;
    4'hb: led_ten_hex1 =  7'b1111111;  
    4'hc: led_ten_hex1 =  7'b1111111;  
    4'hd: led_ten_hex1 =  7'b1111111;  
    4'he: led_ten_hex1 =  7'b1111111;  
    4'hf: led_ten_hex1 =  7'b1111111;  
    default: led_ten_hex1 = 7'b1111111;  
  endcase                     
end 
//the 7-segment Displays the one of the number in HEX2                         
always@(num_one) 
begin
  case(num_one)
    4'h0: led_one_hex0 = 7'b1000000;
    4'h1: led_one_hex0 = 7'b1111001;  
    4'h2: led_one_hex0 = 7'b0100100;  
    4'h3: led_one_hex0 = 7'b0110000;  
    4'h4: led_one_hex0 = 7'b0011001; 
    4'h5: led_one_hex0 = 7'b0010010; 
    4'h6: led_one_hex0 = 7'b0000010;  
    4'h7: led_one_hex0 = 7'b1111000; 
    4'h8: led_one_hex0 = 7'b0000000;  
    4'h9: led_one_hex0 = 7'b0010000;  
    4'ha: led_one_hex0 = 7'b1111111;
    4'hb: led_one_hex0 =  7'b1111111;  
    4'hc: led_one_hex0 =  7'b1111111;  
    4'hd: led_one_hex0 =  7'b1111111;  
    4'he: led_one_hex0 =  7'b1111111;  
    4'hf: led_one_hex0 =  7'b1111111;  
    default: led_one_hex0 = 7'b1111111;  
  endcase                     
end      
                              
endmodule