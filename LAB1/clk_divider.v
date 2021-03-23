module clk_divider (input clk,
		    input [31:0] clk_count,
		    output reg out_sig);

	reg [31:0] Count =32'b0;

	//since counter only count at posedge of the clk sigal
	//expect counter to take 2*clk_divider clk cycles to finish counting
	always @(posedge clk) begin
		if(Count >= clk_count)
			Count <= 32'b0;	//reseet count to 0 when counter counts more than/equals to "clk_divider"
		else
			Count <= Count + 1'b1;
		out_sig <= (Count < clk_count/2) ? 1'b1: 1'b0;	//set output signal to 1 when counting the first half, to 0 when counting the second half
	end
endmodule