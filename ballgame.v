module ballgame(startn, resetn, kb_data, kb_clk,leftn, rightn, clk, 
					vga_clk, vga_blank_n, vga_sync_n, r, g, b, hs, vs,
					led_one_hex0,led_ten_hex1,led1,led0);
   input           startn;
   input           resetn;
   input           leftn;
   input           rightn;
   input           clk;
	input 			 kb_data;
	input 			 kb_clk;
   output          vga_clk;
   output          vga_blank_n;
   output          vga_sync_n;
   output          r;
   output          g;
   output          b;
   output          hs;
   output          vs;
  output [6:0] led_ten_hex1;

  output [6:0] led_one_hex0;
  output			led1,led0;
  
   parameter [9:0] board_x0 = 10'b0001101100;
   parameter [9:0] board_y0 = 10'b0110101110;
	
	parameter [9:0] board_x1 = 10'b0001101100;
   parameter [9:0] board_y1 = 10'h31;
   
   parameter       pl = 40;
   parameter       ph = 10;
   parameter [9:0] ballx0 = 10'b0001101100;
   parameter [9:0] bally0 = 10'b0110011110;
	

   
   parameter       ballc = 16;
   parameter       brickc = 32;
//   parameter  [15:0]    ballmap[15:0] = {16'b0000000000000000, 16'b0000011111100000, 16'b0001111111111000, 16'b0011111100011100,
//														16'b0011111111001100, 16'b0111111111100110, 16'b0111111111100110, 16'b0111111111100110,
//														16'b0111111111100110, 16'b0111111111111110, 16'b0111111111111110, 16'b0011111111111100, 
//														16'b0011111111111100, 16'b0001111111111000, 16'b0000011111100000, 16'b0000000000000000};
   parameter [9:0] brickx0 = 10'b0001011001;
   parameter [9:0] bricky0 = 10'hec;
   
   parameter [9:0] brickx1 = 10'b0100001110;
   parameter [9:0] bricky1 = 10'hec;
   
   parameter [9:0] brickx2 = 10'b0111000011;
   parameter [9:0] bricky2 = 10'hec;
   
   parameter       brickl = 80;
   parameter       brickh = 35;
   parameter       board_step = 2;
   wire [9:0]      hloc;
   wire [9:0]      vloc;
   wire            hsyncb;
   wire            vsyncb;
   reg [9:0]       ballx;
   reg [9:0]       bally;
   reg [9:0]       board_x;
   reg [9:0]       board_y;
	reg [9:0]       board_xx;
   reg [9:0]       board_yy;
   wire [3:0]      ball_cnt_x,brick_cnt_x;
   wire [3:0]      ball_cnt_y,brick_cnt_y;
	reg [15:0]		 ball_color_r,brick_color_r;
   wire            ball_color,brick_color_0,brick_color_1;
   wire            border_color;
   wire            brick_color_2;
   wire            brick_color_x1;
   wire            brick_color_y1;
	wire            brick_color_x2;
   wire            brick_color_y2;
   wire            board_color_x;
   wire            board_color_y;
   wire            board_color;
	 wire            board_color_xx;
   wire            board_color_yy;
   wire            board_color_xxyy;
   wire            border_up;
   wire            border_down;
   wire            border_left11;
   wire            border_right11;
   wire            update;
   wire            enable;
	
	wire [7:0]      data_in;
   wire            data_ready;
	
   reg             sysclk;
	reg	[2:0]		numA,numB;
   integer       i;
   integer       j;
   wire            reset;
   wire            start;
   wire            left11;
   wire            right11;		 
	reg            left12;
   reg            right12;
	reg 				num_ctrl;
	wire 				enable_done;
	wire 				enable_start;
	//wire [2:0]     rgb;
	//reg  				push_reset;
   function integer intval;
      input [9:0]     val;
      //input           _val;
      reg [9:0]  valv;
		reg [3:0]	m;
      integer         sum;
      //integer         _val;
   begin
      valv = val;
		sum = 0;
      for (m = 0; m <= 9; m = m + 1)
         if (valv[m] == 1'b1)
            sum = sum + (2 ** m);
         else
            ;
      intval = sum;
   end
   endfunction
   
	assign start = (~(startn));
   assign reset = (~(resetn));
   assign left11 = (~(leftn));
   assign right11 = (~(rightn));
   assign vga_clk = sysclk;
   assign vga_sync_n = 1'b0;
   assign vga_blank_n = vs & hs;
	assign led1 = (numA == 5) ? 1:0;
	assign led0 = (numB == 5) ? 1:0;
	assign enable = enable_start&(~led1)&(~led0);
	assign enable_done= led1 | led0;
//	assign rgb = {r,g,b};

   assign ball_cnt_x = (hloc >= ballx & hloc <= ballx + ballc) ? intval(hloc - ballx) : 0;
   assign ball_cnt_y = (vloc >= bally & vloc <= bally + ballc) ? intval(vloc - bally) : 0;
	
   assign ball_color = ball_color_r[ball_cnt_x];
	
	assign brick_color_x0 = ((hloc >= brickx0 & hloc <= brickx0 + brickl)) ? 1'b1 : 1'b0;
   assign brick_color_y0 = ((vloc >= bricky0 & vloc <= bricky0 + brickh)) ? 1'b1 : 1'b0;
   assign brick_color_0 = brick_color_x0 & brick_color_y0;
	
	assign brick_color_x1 = ((hloc >= brickx1 & hloc <= brickx1 + brickl)) ? 1'b1 : 1'b0;
   assign brick_color_y1 = ((vloc >= bricky1 & vloc <= bricky1 + brickh)) ? 1'b1 : 1'b0;
   assign brick_color_1 = brick_color_x1 & brick_color_y1;
	
	assign brick_color_x2 = ((hloc >= brickx2 & hloc <= brickx2 + brickl)) ? 1'b1 : 1'b0;
   assign brick_color_y2 = ((vloc >= bricky2 & vloc <= bricky2 + brickh)) ? 1'b1 : 1'b0;
   assign brick_color_2 = brick_color_x2 & brick_color_y2;
   
   assign board_color_x = (hloc >= board_x & hloc <= board_x + pl) ? 1'b1 : 
                          1'b0;
	assign board_color_xx = (hloc >= board_xx & hloc <= board_xx + pl) ? 1'b1 : 
                          1'b0;
   assign board_color_y = (vloc >= board_y & vloc <= board_y + ph) ? 1'b1 : 
                          1'b0;
	assign board_color_yy = (vloc <= board_yy & vloc >= board_yy - ph) ? 1'b1 : 
                          1'b0;
								  
   assign board_color = board_color_x & board_color_y;
	assign board_color_xxyy = board_color_xx & board_color_yy;
   
   assign border_up = (hloc[9:3] == 7'b0000000) ? 1'b1 : 
                      1'b0;
   assign border_down = (hloc[9:3] == 7'b1001111) ? 1'b1 : 
                        1'b0;
   assign border_left11 = (vloc[9:3] == 7'b0000000) ? 1'b1 : 
                          1'b0;
   assign border_right11 = (vloc[9:3] == 7'b0111011) ? 1'b1 : 
                           1'b0;
   assign border_color = border_up | border_down | border_left11 | border_right11;
   assign hs = hsyncb;
   assign vs = vsyncb;
   assign r = enable ? (border_color | board_color | brick_color_0|brick_color_1|brick_color_2| board_color_xxyy):rr;
   assign g = enable ? (border_color | board_color | ball_color| board_color_xxyy):gg;
   assign b = enable ? (border_color | board_color | ball_color| board_color_xxyy):bb;
   assign update = (hloc == 11'b00000000001 & vloc == 10'b0000000001) ? 1'b1 : 
                   1'b0;
	
vga_sig u0(.clock(sysclk), .reset(reset), .hsyncb(hsyncb), .vsyncb(vsyncb), .enable(enable_start), .xaddr(hloc), .yaddr(vloc));
keyboard u1(.kb_data(kb_data), .kb_clk(kb_clk), .clk(sysclk), .reset(resetn), .data(data_in), .data_ready(data_ready));
SEG7_LUT u3(.num_ten(numA),.led_ten_hex1(led_ten_hex1), .num_one(numB),.led_one_hex0(led_one_hex0));
done_game u4(.clk(sysclk),.reset(reset),.enable(enable_done), .vcnt11(vloc),.hcnt11(hloc),.rgb({rr,gg,bb}));
   
 always @(posedge clk or posedge reset)
   begin: divclk
      if (reset == 1'b1)
         sysclk <= 1'b0;
      else 
         sysclk <= (~sysclk);
   end
   
always @(posedge clk or negedge resetn )
		if(resetn == 0) begin
			left12<= 0;
			right12<= 0;
		
		end
    else  if (data_ready == 1'b1)
         case (data_in)
          //  8'h5A :
           //    start <= 1'b0;
          //  8'h2D :
           //    push_reset <= 1'b0;
				8'h6B:
				   left12<= 1'b1;
				8'h74:
				   right12<= 1'b1;
					
            default :begin
				left12<= 0;
		     	right12<= 0;
				end
                    endcase
      else
      begin
        // start <= 1'b1;
       //  push_reset <= 1'b1;
      end
		

	always@(ball_cnt_x or ball_cnt_y ) begin
			case(ball_cnt_y)
			     4'b0000:ball_color_r = 16'b0000000000000000;
				  4'b0001:ball_color_r = 16'b0000011111100000;
				  4'b0010:ball_color_r = 16'b0001111111111000;
				  4'b0011:ball_color_r = 16'b0011111111111100;
				  
				  4'b0100:ball_color_r = 16'b0011111111111100;
				  4'b0101:ball_color_r = 16'b0111111111111110;
				  4'b0110:ball_color_r = 16'b0111111111111110;
				  4'b0111:ball_color_r = 16'b0111111111100110;
				  
				  4'b1000:ball_color_r = 16'b0111111111100110;
				  4'b1001:ball_color_r = 16'b0111111111100110;
				  4'b1010:ball_color_r = 16'b0111111111100110;
				  4'b1011:ball_color_r = 16'b0011111111001100;
				  
				  4'b1100:ball_color_r = 16'b0011111100011100;
				  4'b1101:ball_color_r = 16'b0001111111111000;
				  4'b1110:ball_color_r = 16'b0000011111100000;
				  4'b1111:ball_color_r = 16'b0000000000000000;
				  default: begin end
				  endcase
	
	end
	
 

   
   always @(posedge sysclk or posedge reset )
   begin: ball_collision
      if (reset == 1'b1)
      begin
         j <= 0;
         i <= 0;
			numA <= 0;
			numB <= 0;
      end
      else 
      begin
         if (start == 1'b1)
         begin
            i <= 1;
            j <= -1;
				num_ctrl <= 1;
         end
         else if (ballx == 10'b0000000111 | 
			(ballx == board_x + pl & bally < board_y + ph & bally > board_y - ballc) | 
			(ballx == board_xx + pl & bally > board_yy - ph & bally < board_yy + ballc) |
			(ballx == brickx0 + brickl & bally < bricky0 + brickh & bally > bricky0 - ballc) | 
			(ballx == brickx1 + brickl & bally < bricky0 + brickh & bally > bricky0 - ballc) | 
			(ballx == brickx2 + brickl & bally < bricky0 + brickh & bally > bricky0 - ballc))
            i <= 1;
         else if (ballx == 10'b1001101000 | 
			(ballx == board_x - ballc & bally < board_y + ph & bally > board_y - ballc) | 
			(ballx == board_xx - ballc & bally > board_yy - ph & bally < board_yy + ballc) |
			(ballx == brickx0 - ballc & bally < bricky0 + brickh & bally > bricky0 - ballc) | 
			(ballx == brickx1 - ballc & bally < bricky0 + brickh & bally > bricky0 - ballc) | 
			(ballx == brickx2 - ballc & bally < bricky0 + brickh & bally > bricky0 - ballc))
            i <= -1;
         else if (//bally == 10'b0000000111 | 
			(bally == board_y1 & ballx >= board_xx - ballc & ballx <= board_xx + pl & (i == 1 | i == -1)) |
			(bally == bricky0 + brickh & ((ballx >= brickx0 - ballc & ballx <= brickx0 + brickl) | 
			(ballx >= brickx1 - ballc & ballx <= brickx1 + brickl) | 
			(ballx >= brickx2 - ballc & ballx <= brickx2 + brickl))))
            j <= 1;
         else if ((bally == board_y0 - ballc & ballx >= board_x - ballc & ballx <= board_x + pl & (i == 1 | i == -1)) | 
			(bally == bricky0 - ballc & ((ballx >= brickx0 - ballc & ballx <= brickx0 + brickl) | 
			(ballx >= brickx1 - ballc & ballx <= brickx1 + brickl) | 
			(ballx >= brickx2 - ballc & ballx <= brickx2 + brickl))))
            j <= -1;
		     else if (bally >= 10'b0111011000)
         begin
            i <= 0;
            j <= 0;
				if(num_ctrl == 1) begin
				numB <= numB +1;
				num_ctrl<= 0;
				end
				else
				numB<= numB;
         end
			else if (bally <= 10'b0000000000)
         begin
//            i <= 0;
//            j <= 0;
				if(num_ctrl == 1) begin
				numA <= numA +1;
				num_ctrl <= 0;
				end
				else
				numA<= numA;
         end
      end
   end
   
   always @(posedge sysclk or posedge reset)
   begin: board_control
      if (reset == 1'b1)
      begin
         ballx <= ballx0;
         bally <= bally0;
         board_x <= board_x0;
         board_y <= board_y0;
      end
      else 
      begin
         if (start == 1'b1)
         begin
            board_x <= board_x;
            board_y <= board_y;
            ballx <= board_x;
            bally <= bally0;
         end
         if (update == 1'b1)
         begin
            if (left11 == 1'b1 & board_x > 10'b0000000111)
               board_x <= board_x - board_step;
            if (right11 == 1'b1 & board_x < 10'b1001010000)
               board_x <= board_x + board_step;
            ballx <= ballx + i;
            bally <= bally + j;
         end
      end
   end
	
	 always @(posedge sysclk or posedge reset)
   begin: board_2_control
      if (reset == 1'b1)
      begin
//         ballx <= ballx0;
//         bally <= bally0;
         board_xx <= board_x1;
         board_yy <= board_y1;
      end
      else 
      begin
         if (start == 1'b1)
         begin
            board_xx <= board_xx;
            board_yy <= board_yy;
            //ballx <= board_x;
           // bally <= bally0;
         end
         if (update == 1'b1)
         begin
            if (left12 == 1'b1 & board_xx > 10'b0000000111)
               board_xx <= board_xx - board_step;
            if (right12 == 1'b1 & board_xx < 10'b1001010000)
               board_xx <= board_xx + board_step;
//            ballxx <= ballxx + i;
//            ballyy <= ballyy + j;
         end
      end
   end
   
endmodule
