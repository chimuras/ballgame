module vga_sig(clock, reset, hsyncb, vsyncb, enable, xaddr, yaddr);
   input        clock;
   input        reset;
   output       hsyncb;
   reg          hsyncb;
   output       vsyncb;
   reg          vsyncb;
   output       enable;
   reg          enable;
   output [9:0] xaddr;
   reg [9:0]    xaddr;
   output [9:0] yaddr;
   reg [9:0]    yaddr;
   
   reg [9:0]    hcnt;
   reg [9:0]    vcnt;
   parameter    h_pixels = 640;
   parameter    h_front = 16;
   parameter    h_back = 48;
   parameter    h_synctime = 96;
   parameter    h_period = h_synctime + h_pixels + h_front + h_back;
   parameter    v_lines = 480;
   parameter    v_front = 10;
   parameter    v_back = 33;
   parameter    v_synctime = 2;
   parameter    v_period = v_synctime + v_lines + v_front + v_back;
   
   always @(posedge clock or posedge reset)
   begin: a
      if (reset == 1'b1)
         hcnt <= 10'b0000000001;
      else 
      begin
         if (hcnt < h_period)
            hcnt <= hcnt + 1;
         else
            hcnt <= 10'b0000000001;
      end
   end
   
   always @(posedge clock or posedge reset)
   begin: b
      if (reset == 1'b1)
         vcnt <= 10'b0000000001;
      else 
      begin
         if (vcnt < v_period & hcnt == h_period)
            vcnt <= vcnt + 1;
         else if (vcnt == v_period & hcnt == h_period)
            vcnt <= 10'b0000000001;
      end
   end
   
   always @(posedge clock or posedge reset)
   begin: c
      if (reset == 1'b1)
         hsyncb <= 1'b1;
      else 
      begin
         if ((hcnt >= h_pixels + h_front) & (hcnt < h_pixels + h_synctime + h_front))
            hsyncb <= 1'b0;
         else
            hsyncb <= 1'b1;
      end
   end
   
   always @(posedge clock or posedge reset)
   begin: d
      if (reset == 1'b1)
         vsyncb <= 1'b1;
      else 
      begin
         if ((vcnt >= v_lines + v_front) & (vcnt < v_lines + v_synctime + v_front))
            vsyncb <= 1'b0;
         else
            vsyncb <= 1'b1;
      end
   end
   
   always @(posedge clock)
   begin: e
      
      begin
         if (hcnt >= h_pixels | vcnt >= v_lines)
            enable <= 1'b0;
         else
            enable <= 1'b1;
      end
   end
   
   always @(posedge clock or posedge reset)
   begin: f
      if (reset == 1'b1)
      begin
         xaddr <= 10'b0000000001;
         yaddr <= 10'b0000000001;
      end
      else 
      begin
         if (hcnt < h_pixels)
            xaddr <= hcnt;
         if (vcnt < v_lines)
            yaddr <= vcnt;
      end
   end
   
endmodule
