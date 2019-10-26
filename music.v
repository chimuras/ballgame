module music(
	clock,
	speaker);
	
	input		clock;
	output		speaker;
	
	reg			clk_6m=0;
	reg	[1:0]	cnt_6m=0;

	//	parameters HALFDIV  3;      //£¨50m/6m=8. 333 333  8/2-1=3£©
	always @(posedge clock)begin
		if(cnt_6m<3)
			cnt_6m<=cnt_6m+1;            
		else begin
			cnt_6m<=0;
			clk_6m<=~clk_6m;
		end
	end

	reg[23:0] cnt_4hz;
	reg  clk_4hz=0;
	always @(posedge clock)begin
		if(cnt_4hz<12499999)
			cnt_4hz<=cnt_4hz+1;  // (50m/4hz=12500000,cnt<[12 500 000/2-1=12499999£©
		else begin
			cnt_4hz<=0;
			clk_4hz<=~clk_4hz;
		end
	end 	
		
	reg [3:0]high,med,low;
	reg [13:0]divider,origin;
	reg [7:0]counter;
	reg speaker;
	wire carry;
	assign carry=(divider==16383);

	parameter L1 =12'b000000000001,			  		
			  L2 =12'b000000000010,				
			  L3 =12'b000000000011,		 		
			  L4 =12'b000000000100,	   		
			  L5 =12'b000000000101,	 
			  L6 =12'b000000000110,    			 	
			  L7 =12'b000000000111,			   	
			  M1 =12'b000000010000,		 		 			 		
			  M2 =12'b000000100000,
			  M3 =12'b000000110000,
			  M4 =12'b000001000000,
			  M5 =12'b000001010000,	
			  M6 =12'b000001100000,	
			  M7 =12'b000001110000,	
			  H1 =12'b000100000000,	
			  H2 =12'b001000000000,		
			  H3 =12'b001100000000,
			  H4 =12'b010000000000,	
			  H5 =12'b010100000000,
			  H6 =12'b011000000000,		
			  H7 =12'b011100000000, 
			  E0 =12'b000000000000;

		



	always @(posedge clk_6m)
		begin if(carry) divider<=origin;
		else  divider<=divider+1;
		end
	always @(posedge carry)
		begin speaker<=~speaker;
	end
	always @(posedge clk_4hz)
		begin 
			case({high,med,low})
			L1:origin<=4933;
			L2:origin<=6179;
			L3:origin<=7292;
			L4:origin<=7787;
			L5:origin<=8730;
			L6:origin<=9565;
			L7:origin<=10310;
			M1:origin<=10647;
			M2:origin<=11272;
			M3:origin<=11831;
			M4:origin<=12085;
			M5:origin<=12556;
			M6:origin<=12974;
			M7:origin<=13347;
			H1:origin<=13515;
			H2:origin<=13830;
			H3:origin<=14107;
			H4:origin<=14236;
			H5:origin<=14470;
			H6:origin<=14678;
			H7:origin<=14858;
			E0:origin<=16383;
			endcase
	end
	always @(posedge clk_4hz)begin
		if(counter==167)
			counter<=0;
		else counter<=counter+1;
			case(counter)
			0: {high,med,low}<=M6;
			1: {high,med,low}<=M7;
			2: {high,med,low}<=M1;
			3: {high,med,low}<=M7;
			4: {high,med,low}<=M1;
			5: {high,med,low}<=H3;
			6: {high,med,low}<=M7;
			7: {high,med,low}<=L7;///
			8: {high,med,low}<=L3;
			9: {high,med,low}<=M6;
			10:{high,med,low}<=M5;
			11:{high,med,low}<=M6;
			12:{high,med,low}<=H1;
			13:{high,med,low}<=M5;
			14:{high,med,low}<=M5;
			15:{high,med,low}<=E0;///
			16:{high,med,low}<=M3;
			17:{high,med,low}<=M4;
			18:{high,med,low}<=M3;
			19:{high,med,low}<=M3;//
			20:{high,med,low}<=H1;
			21:{high,med,low}<=M3;
			22:{high,med,low}<=L3;
			23:{high,med,low}<=E0;///
			24:{high,med,low}<=H1;
			25:{high,med,low}<=H1;
			26:{high,med,low}<=H1;
			27:{high,med,low}<=M7;
			28:{high,med,low}<=M4;
			29:{high,med,low}<=M7;
			30:{high,med,low}<=M7;
			31:{high,med,low}<=E0;///
			32:{high,med,low}<=M6;
			33:{high,med,low}<=M7;
			34:{high,med,low}<=M1;
			35:{high,med,low}<=M7;
			36:{high,med,low}<=M1;
			37:{high,med,low}<=H3;
			38:{high,med,low}<=M7;
			39:{high,med,low}<=E0;///
			40:{high,med,low}<=L3;
			41:{high,med,low}<=H6;
			42:{high,med,low}<=M5;
			43:{high,med,low}<=M6;
			44:{high,med,low}<=H1;
			45:{high,med,low}<=M5;
			46:{high,med,low}<=L5;
			47:{high,med,low}<=E0;///
			48:{high,med,low}<=M3;
			49:{high,med,low}<=M4;
			50: {high,med,low}<=M1;
			51: {high,med,low}<=M7;
			52: {high,med,low}<=L1;
			53: {high,med,low}<=M2;
			54: {high,med,low}<=M2;
			55: {high,med,low}<=M3;
			56: {high,med,low}<=M1;
			57: {high,med,low}<=E0;///
			58: {high,med,low}<=H1;
			59: {high,med,low}<=M7;
			60:{high,med,low}<=M6;
			61:{high,med,low}<=M7;
			62:{high,med,low}<=M5;
			63:{high,med,low}<=M6;
			64:{high,med,low}<=E0;///
			65:{high,med,low}<=M1;
			66:{high,med,low}<=M2;
			67:{high,med,low}<=M3;
			68:{high,med,low}<=M2;
			69:{high,med,low}<=M3;
			70:{high,med,low}<=M5;
			71:{high,med,low}<=M2;
			72:{high,med,low}<=E0;///
			73:{high,med,low}<=M5;
			74:{high,med,low}<=H1;
			75:{high,med,low}<=M7;
			76:{high,med,low}<=H1;
			77:{high,med,low}<=M3;
			78:{high,med,low}<=M3;
			79:{high,med,low}<=L3;///
			80:{high,med,low}<=M6;
			81:{high,med,low}<=M7;
			82:{high,med,low}<=M1;
			83:{high,med,low}<=M7;
			84:{high,med,low}<=M1;
			85:{high,med,low}<=M2;
			86:{high,med,low}<=M1;
			87:{high,med,low}<=M5;
			88:{high,med,low}<=M5;
			89:{high,med,low}<=L5;///
			90:{high,med,low}<=H4;
			91:{high,med,low}<=H3;
			92:{high,med,low}<=H2;
			93:{high,med,low}<=H1;
			94:{high,med,low}<=H3;
			95:{high,med,low}<=M3;//
			96:{high,med,low}<=M3;
			97:{high,med,low}<=H6;
			98:{high,med,low}<=H6;
			99:{high,med,low}<=M5;
			100:{high,med,low}<=M5;
			101:{high,med,low}<=M3;
			102:{high,med,low}<=M2;
			103:{high,med,low}<=M1;///
			104:{high,med,low}<=H1;
			105:{high,med,low}<=H2;
			106:{high,med,low}<=H1;
			107:{high,med,low}<=H2;
			108:{high,med,low}<=H5;
			109:{high,med,low}<=H3;
			110:{high,med,low}<=E0;///
			111:{high,med,low}<=M3;
			112:{high,med,low}<=H6;
			113:{high,med,low}<=H6;  
			114:{high,med,low}<=H5;
			115:{high,med,low}<=H5;
			116:{high,med,low}<=H3;  
			117:{high,med,low}<=H2;
			118:{high,med,low}<=H1;///
			119:{high,med,low}<=H1;  
			120:{high,med,low}<=H2;
			121:{high,med,low}<=H1;
			122:{high,med,low}<=H2; 
			123:{high,med,low}<=H5;
			124:{high,med,low}<=H3;///
			125:{high,med,low}<=M3;  
			126:{high,med,low}<=M6;
			127:{high,med,low}<=M6;
			128:{high,med,low}<=M5;  
			129:{high,med,low}<=M5;
			130:{high,med,low}<=M3;
			131:{high,med,low}<=M2;   
			132:{high,med,low}<=M1;///
			133:{high,med,low}<=M1;
			134:{high,med,low}<=M2;  
			135:{high,med,low}<=M1;
			136:{high,med,low}<=M2;
			137:{high,med,low}<=M7;
			138:{high,med,low}<=M6;  ///
			139:{high,med,low}<=M6;
			140:{high,med,low}<=M7;
			141:{high,med,low}<=M1;  
			142:{high,med,low}<=M7;
			143:{high,med,low}<=M1;
			144:{high,med,low}<=H3;
			145:{high,med,low}<=M7;///
			146:{high,med,low}<=M3; 
			147:{high,med,low}<=M6;
			148:{high,med,low}<=M5;
			149:{high,med,low}<=M6;
			150:{high,med,low}<=H1;
			151:{high,med,low}<=M5;///
			152:{high,med,low}<=M3;
			153:{high,med,low}<=M4;
			154:{high,med,low}<=M1;
			155:{high,med,low}<=M7;
			156:{high,med,low}<=M1;
			157:{high,med,low}<=M2;
			158:{high,med,low}<=M3;
			159:{high,med,low}<=M1;///
			160:{high,med,low}<=M1;
			161:{high,med,low}<=M7;
			162:{high,med,low}<=M6;
			163:{high,med,low}<=M7;
			164:{high,med,low}<=M5; 
			165:{high,med,low}<=M6;
			166:{high,med,low}<=L6;
			167:{high,med,low}<=E0;  //      
	endcase
	end
endmodule


