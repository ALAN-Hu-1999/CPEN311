module divider_tb;
	logic clk_50;
	logic out_sig_tb;
	logic [31:0] clk_count;
	
	clk_divider tb1(clk_50, clk_count, out_sig_tb);

	//set up base clk cycle
	initial forever begin
		clk_50 = 0; #1;
		clk_50 = 1; #1;
	end
	
	//test divider with 3 different clk_divider values
	//the period of the output signals are expected to be 2*clk_count
	initial begin
		clk_count = 32'd1200;
		#12000;
		clk_count = 32'd2200;
		#22000;
		clk_count = 32'd3200;
		#32000;
		$stop;
	end
endmodule
