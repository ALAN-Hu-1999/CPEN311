module Led(input clk, 
	   output reg [9:0] out);

	logic [3:0] cur_state, next_state;	//initialize current state so that led starts blinking from LED0

	//This LED controller is a simple FSM
	//LED lights up in order: 0 -> 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 7 ->
	//			  6 -> 5 -> 4 -> 3 -> 2 -> reset to 0
	//every order coresponds to a state, thus there are 14 states in total
	always @(posedge clk) begin
		case(cur_state)
			4'b0000: begin next_state <= 4'b00001; out <= 8'b0000_0001; end
			4'b0001: begin next_state <= 4'b00010; out <= 8'b0000_0010; end
			4'b0010: begin next_state <= 4'b00011; out <= 8'b0000_0100; end
			4'b0011: begin next_state <= 4'b00100; out <= 8'b0000_1000; end
			4'b0100: begin next_state <= 4'b00101; out <= 8'b0001_0000; end	//5
			4'b0101: begin next_state <= 4'b00110; out <= 8'b0010_0000; end
			4'b0110: begin next_state <= 4'b00111; out <= 8'b0100_0000; end
			4'b0111: begin next_state <= 4'b01000; out <= 8'b1000_0000; end
			4'b1000: begin next_state <= 4'b01001; out <= 8'b0100_0000; end
			4'b1001: begin next_state <= 4'b01010; out <= 8'b0010_0000; end	//10
			4'b1010: begin next_state <= 4'b01011; out <= 8'b0001_0000; end
			4'b1011: begin next_state <= 4'b01100; out <= 8'b0000_1000; end
			4'b1100: begin next_state <= 4'b01101; out <= 8'b0000_0100; end
			4'b1101: begin next_state <= 4'b00000; out <= 8'b0000_0010; end	//14
			default: begin next_state <= 4'b00000; out <= 8'b0000_0000; end	//if unexpected state detected, reset to state 0000
		endcase
	end
	assign cur_state = next_state;	//transition to next state
endmodule
