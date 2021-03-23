module tone_SW_sel_tb;
	logic [3:0] SW_tb;
	logic [31:0] clk_count_tb;
	logic [23:0] ChA_tb, ChB_tb;
	logic [15:0] HEX_tb;
		
	tone_SW_sel tb(SW_tb, clk_count_tb, ChA_tb, ChB_tb, HEX_tb);

	initial begin
		SW_tb[0] = 1'b1;	//enable audio out, should be shown in ChB
		SW_tb[3:1] = 3'b000; #10;	//Testing every input, see if the outputs are expected
		SW_tb[3:1] = 3'b001; #10;
		SW_tb[3:1] = 3'b010; #10;
		SW_tb[3:1] = 3'b011; #10;
		SW_tb[3:1] = 3'b100; #10;
		SW_tb[3:1] = 3'b101; #10;
		SW_tb[3:1] = 3'b110; #10;
		SW_tb[3:1] = 3'b111; #10;
		SW_tb[0] = 1'b0;     #10;	//disable audio output, clk_count would still have values (there wout be audio output since 0 is assigned to audio data if SW[0] is off)
		$stop;
	end
endmodule
