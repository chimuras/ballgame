module vga_disp(
	input clk,
	input disp_sel,
	input [9:0] xaddr,
	input [9:0] yaddr,
	input [9:0] ball_xaddr,
	input [9:0] ball_yaddr,
	input [9:0] user1_xaddr,
	input [9:0] user1_yaddr,
	input [9:0] user2_xaddr,
	input [9:0] user2_yaddr,
	input [9:0] block1_xaddr,
	input [9:0] block1_yaddr,
	input [9:0] block2_xaddr,
	input [9:0] block2_yaddr,
	input [9:0] block3_xaddr,
	input [9:0] block3_yaddr,
	output reg [2:0] rgb
);

	parameter    HIGH_block = 40;
	parameter    WIDTH_block = 100;

	parameter    HIGH_user = 20;
	parameter    WIDTH_user = 100;

	wire	[0:1151] game_over;
	assign game_over[0:71]		= 72'b000000000000000000000000000000000000000000000000000000000000000000000000;
	assign game_over[72:143]	= 72'b000000000000000000000000000000000000000000000000000000000000000000000000;
	assign game_over[144:215]	= 72'b001111000001000011000011111111100000000001111100110000111111111011111100;
	assign game_over[216:287]	= 72'b011001100011100011100111011001100000000011000110110000110110011001100110;
	assign game_over[288:359]	= 72'b110000100110110011111111011000100000000011000110110000110110001001100110;
	assign game_over[360:431]	= 72'b110000001100011011111111011010000000000011000110110000110110100001100110;
	assign game_over[432:503]	= 72'b110000001100011011011011011110000000000011000110110000110111100001111100;
	assign game_over[504:575]	= 72'b110111101111111011000011011010000000000011000110110000110110100001101100;
	assign game_over[576:647]	= 72'b110001101100011011000011011000000000000011000110110000110110000001100110;
	assign game_over[648:719]	= 72'b110001101100011011000011011000100000000011000110011001100110001001100110;
	assign game_over[720:791]	= 72'b011001101100011011000011011001100000000011000110001111000110011001100110;
	assign game_over[792:863]	= 72'b001110101100011011000011111111100000000001111100000110001111111011100110;
	assign game_over[864:935]	= 72'b000000000000000000000000000000000000000000000000000000000000000000000000;
	assign game_over[936:1007]	= 72'b000000000000000000000000000000000000000000000000000000000000000000000000;
	assign game_over[1008:1079]	= 72'b000000000000000000000000000000000000000000000000000000000000000000000000;
	assign game_over[1080:1151]	= 72'b000000000000000000000000000000000000000000000000000000000000000000000000;


always@(posedge clk)begin
	if(xaddr<640 && yaddr<480)begin
		if(disp_sel==0)begin
			if(xaddr>=5 && xaddr<10 && yaddr>=5 && yaddr<=475)
				rgb<=3'b111;
			else if(xaddr<=635 && xaddr>630 && yaddr>=5 && yaddr<=475)
				rgb<=3'b111;
			else if(xaddr>=5 && xaddr<=635 && yaddr>=5 && yaddr<10)
				rgb<=3'b111;
			else if(xaddr>=5 && xaddr<=635 && yaddr<=475 && yaddr>470)
				rgb<=3'b111;			
			else if(xaddr>=user1_xaddr-WIDTH_user/2 && xaddr<=user1_xaddr+WIDTH_user/2 && yaddr>=user1_yaddr-HIGH_user/2 && yaddr<=user1_yaddr+HIGH_user/2)
				rgb<=3'b111;
			else if(xaddr>=user2_xaddr-WIDTH_user/2 && xaddr<=user2_xaddr+WIDTH_user/2 && yaddr>=user2_yaddr-HIGH_user/2 && yaddr<=user2_yaddr+HIGH_user/2)
				rgb<=3'b111;
			else if(xaddr>=block1_xaddr-WIDTH_block/2 && xaddr<=block1_xaddr+WIDTH_block/2 && yaddr>=block1_yaddr-HIGH_block/2 && yaddr<=block1_yaddr+HIGH_block/2)
				rgb<=3'b100;
			else if(xaddr>=block2_xaddr-WIDTH_block/2 && xaddr<=block2_xaddr+WIDTH_block/2 && yaddr>=block2_yaddr-HIGH_block/2 && yaddr<=block2_yaddr+HIGH_block/2)
				rgb<=3'b100;
			else if(xaddr>=block3_xaddr-WIDTH_block/2 && xaddr<=block3_xaddr+WIDTH_block/2 && yaddr>=block3_yaddr-HIGH_block/2 && yaddr<=block3_yaddr+HIGH_block/2)
				rgb<=3'b100;
			else if((xaddr-ball_xaddr)*(xaddr-ball_xaddr)+(yaddr-ball_yaddr)*(yaddr-ball_yaddr)<100)
				rgb<=3'b010;
			else
				rgb<=3'b000;
		end
		else begin
			if((xaddr>=176 && xaddr<464) && (yaddr>=208 && yaddr<272))begin
				if((game_over[(yaddr[9:2]-52)*72+xaddr[9:2]-44]==1))
					rgb<=3'b111;
				else
					rgb<=3'b000;
			end
			else
				rgb<=3'b000;
		end
	end
end


endmodule 						
        