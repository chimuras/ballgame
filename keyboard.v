module keyboard(
	kb_data,
	kb_clk,
	clk,
	reset,
	key_start,
	user1_left,
	user1_right,
	user2_left,
	user2_right,
	data,
	data_ready);
	
	input		kb_data;
	input		kb_clk;
	input		clk;
	input		reset;

	output		key_start;
	output		user1_left;
	output		user1_right;
	output		user2_left;
	output		user2_right;  
	output [7:0]data;
	reg [7:0]	data;
	output		data_ready;
   
   
   reg [9:0]        master;
   reg [9:0]        slave;
   reg              clk_in;
   
   parameter [1:0]  status_s0 = 0,
                    status_makecode = 1;
   reg [1:0]        state;
   
   reg [3:0]        counter;
   reg              data_in;
   reg              data_in_delay;
   
   
   always @(posedge clk or negedge reset)
      if (reset == 1'b0)
         clk_in <= 1'b0;
      else 
         clk_in <= kb_clk;
   
   
   always @(negedge clk_in or negedge reset)
   begin: masterp
      if (reset == 1'b0)
         master <= 10'b0000000000;
      else 
         master <= {kb_data, slave[9:1]};
   end
   
   
   always @(negedge reset or posedge clk_in)
   begin: slavep
      if (reset == 1'b0)
         slave <= 10'b0000000000;
      else 
         slave <= master;
   end
   
   
   always @(negedge reset or negedge clk_in)
   begin: xhdl0
      reg [3:0]        counter_in;
      if (reset == 1'b0)
         counter_in = 0;
      else 
      begin
         if (master[9:2] == 8'hF0)
            counter_in = 10;
         else if (counter_in == 11)
            counter_in = 1;
         else
            counter_in = counter_in + 1;
      end
      counter <= counter_in;
   end
   
   
   always @(posedge clk_in or negedge reset)
      if (reset == 1'b0)
      begin
         state <= status_makecode;
         data <= 8'b00000000;
         data_in <= 1'b0;
      end
      else 
      begin
         if (counter == 10)
            case (state)
               status_makecode :
                  if (master[8:1] == 8'hF0)
                     state <= status_s0;
                  else
                  begin
                     data <= master[8:1];
                     data_in <= 1'b1;
                  end
               status_s0 :
                  state <= status_makecode;
            endcase
         else
            data_in <= 1'b0;
      end
   
   assign data_ready = data_in & ((~data_in_delay));
   
   always @(posedge clk or negedge reset)
      if (reset == 1'b0)
         data_in_delay <= 1'b0;
      else 
         data_in_delay <= data_in;
         

	assign user1_left	=(data==8'h15) ? data_ready : 1'b0;
	assign user1_right	=(data==8'h1D) ? data_ready : 1'b0;
	assign user2_left	=(data==8'h44) ? data_ready : 1'b0;
	assign user2_right	=(data==8'h4D) ? data_ready : 1'b0;
	assign key_start	=(data==8'h5A) ? data_ready : 1'b0;
   
endmodule


