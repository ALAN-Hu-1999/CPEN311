//this Clock divider is slightly modified from the submitted files of LAB1
//change "out_sig <= (Count < (clk_count)) ? 1'b1 : 1'b0;" to "out_sig <= (Count < (clk_count/2'd2)) ? 1'b1 : 1'b0;"
//so the input clock count matches the original signal istead of half of the original
//the logic was complied and tested in LAB1
module clk_divider (
	input clk, 
	input [31:0] clk_count, 
	output logic out_sig
);

	logic [31:0] Count =32'b0;

	always @(posedge clk) begin
		Count <= Count + 32'd1;
		if(Count >= clk_count)
			Count <= 32'b0;
		out_sig <= (Count < (clk_count/2'd2)) ? 1'b1 : 1'b0;
	end
endmodule