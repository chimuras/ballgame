module sys_top(
		input			CLOCK_50,				//	50 MHz
		input	[17:0]	SW,					//	KEY
		// Declare your inputs and outputs here
		// Do not change the following outputs
		input			PS2_CLK,
		input			PS2_DAT,
		output	[6:0]	HEX1,
		output	[6:0]	HEX0,
		output			VGA_CLK,   				//	VGA Clock
		output			VGA_HS,					//	VGA H_SYNC
		output			VGA_VS,					//	VGA V_SYNC
		output			VGA_BLANK_N,				//	VGA BLANK
		output			VGA_SYNC_N,				//	VGA SYNC
		output	[7:0]	VGA_R,   				//	VGA Red[9:0]
		output	[7:0]	VGA_G,	 				//	VGA Green[9:0]
		output	[7:0]	VGA_B,   				//	VGA Blue[9:0]

/////////////////Audio IO////////////////////////////////		
		input			AUD_ADCDAT,
		// Bidirectionals
		inout			AUD_BCLK,
		inout			AUD_ADCLRCK,
		inout			AUD_DACLRCK,
		inout			FPGA_I2C_SDAT,
		// Outputs
		output			AUD_XCK,
		output			AUD_DACDAT,
		output			FPGA_I2C_SCLK
	);

	wire [9:0]      hloc;
	wire [9:0]      vloc;
	wire			enable_start;
	reg				sysclk=0;
	wire 		    rr;
	wire 		    gg;
	wire 		    bb;

	wire	[9:0] 	xaddr;
	wire	[9:0] 	yaddr;
	wire	[9:0] 	ball_xaddr;
	wire	[9:0] 	ball_yaddr;
	wire	[9:0] 	user1_xaddr;
	wire	[9:0] 	user1_yaddr;
	wire	[9:0] 	user2_xaddr;
	wire	[9:0] 	user2_yaddr;
	wire	[9:0] 	block1_xaddr;
	wire	[9:0] 	block1_yaddr;
	wire	[9:0] 	block2_xaddr;
	wire	[9:0] 	block2_yaddr;
	wire	[9:0] 	block3_xaddr;
	wire	[9:0] 	block3_yaddr;

	wire			key_start;
	wire			user1_left;
	wire			user1_right;
	wire			user2_left;
	wire			user2_right;
	wire			music_en;
	wire	[3:0] 	score_user1;
	wire	[3:0] 	score_user2;
	
	always@(posedge CLOCK_50)begin
		sysclk<=~sysclk;
	end
	
	assign VGA_CLK	= sysclk;
	assign VGA_SYNC_N = 1'b0;
	assign VGA_BLANK_N= VGA_VS & VGA_HS;
   
vga_sig u0(
	.clock(sysclk),
	.reset(0),
	.hsyncb(VGA_HS),
	.vsyncb(VGA_VS),
	.enable(enable_start),
	.xaddr(hloc),
	.yaddr(vloc));
	
keyboard u1(
	.kb_data(PS2_DAT),
	.kb_clk(PS2_CLK),
	.clk(sysclk),
	.reset(1),
	.key_start(key_start),
	.user1_left(user1_left),
	.user1_right(user1_right),
	.user2_left(user2_left),
	.user2_right(user2_right),
	.data(),
	.data_ready());
	
SEG7_LUT u2(
	.num_ten(score_user1),
	.led_ten_hex1(HEX1),
	.num_one(score_user2),
	.led_one_hex0(HEX0));

FSM u3(
	.clk(sysclk),
	.xaddr(hloc),
	.yaddr(vloc),
	.key_start(key_start),
	.user1_left(user1_left),
	.user1_right(user1_right),
	.user2_left(user2_left),
	.user2_right(user2_right),
	.disp_sel(disp_sel),
	.music_en(music_en),
	.score_user1(score_user1),
	.score_user2(score_user2),
	.ball_xaddr(ball_xaddr),
	.ball_yaddr(ball_yaddr),
	.user1_xaddr(user1_xaddr),
	.user1_yaddr(user1_yaddr),
	.user2_xaddr(user2_xaddr),
	.user2_yaddr(user2_yaddr),
	.block1_xaddr(block1_xaddr),
	.block1_yaddr(block1_yaddr),
	.block2_xaddr(block2_xaddr),
	.block2_yaddr(block2_yaddr),
	.block3_xaddr(block3_xaddr),
	.block3_yaddr(block3_yaddr)
);

	
vga_disp u4(
	.clk(sysclk),
	.xaddr(hloc),
	.yaddr(vloc),
	.disp_sel(disp_sel),
	.ball_xaddr(ball_xaddr),
	.ball_yaddr(ball_yaddr),
	.user1_xaddr(user1_xaddr),
	.user1_yaddr(user1_yaddr),
	.user2_xaddr(user2_xaddr),
	.user2_yaddr(user2_yaddr),
	.block1_xaddr(block1_xaddr),
	.block1_yaddr(block1_yaddr),
	.block2_xaddr(block2_xaddr),
	.block2_yaddr(block2_yaddr),
	.block3_xaddr(block3_xaddr),
	.block3_yaddr(block3_yaddr),
	.rgb({rr,gg,bb}));
	
	assign VGA_R={8{rr}};
	assign VGA_G={8{gg}};
	assign VGA_B={8{bb}};


music_paly u5(
	// Inputs
	.CLOCK_50(CLOCK_50),
	.en(music_en),
	.AUD_ADCDAT(AUD_ADCDAT),
	.AUD_BCLK(AUD_BCLK),
	.AUD_ADCLRCK(AUD_ADCLRCK),
	.AUD_DACLRCK(AUD_DACLRCK),
	.I2C_SDAT(FPGA_I2C_SDAT),
	.AUD_XCK(AUD_XCK),
	.AUD_DACDAT(AUD_DACDAT),
	.I2C_SCLK(FPGA_I2C_SCLK)	
);
    
endmodule
