module led_tb;
	logic clk_tb;
	logic [7:0] out_tb;
	
	Led tb(clk_tb, out_tb);
	
	//set up clk cycle
	//In this simulation, we need to see if the states and outputs matches the expected values
	initial forever begin
		clk_tb = 0; #10;
		clk_tb = 1; #10;
	end
endmodule
