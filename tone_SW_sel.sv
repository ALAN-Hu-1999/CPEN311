//this module is part of the Basic_Organ_Solution.v. Extracted out for testing purpose 
module tone_SW_sel(input [3:0] SW, 
		   output reg [31:0] clk_count,
		   output reg [23:0] ChA, ChB,
		   output reg [15:0] HEX);

//character parameters are placed here in order to avoid errors
parameter character_0 =8'h30;
parameter character_1 =8'h31;
parameter character_2 =8'h32;
parameter character_3 =8'h33;
parameter character_4 =8'h34;
parameter character_5 =8'h35;
parameter character_6 =8'h36;
parameter character_7 =8'h37;
parameter character_8 =8'h38;
parameter character_9 =8'h39;


//Uppercase Letters
parameter character_A =8'h41;
parameter character_B =8'h42;
parameter character_C =8'h43;
parameter character_D =8'h44;
parameter character_E =8'h45;
parameter character_F =8'h46;
parameter character_G =8'h47;
parameter character_H =8'h48;
parameter character_I =8'h49;
parameter character_J =8'h4A;
parameter character_K =8'h4B;
parameter character_L =8'h4C;
parameter character_M =8'h4D;
parameter character_N =8'h4E;
parameter character_O =8'h4F;
parameter character_P =8'h50;
parameter character_Q =8'h51;
parameter character_R =8'h52;
parameter character_S =8'h53;
parameter character_T =8'h54;
parameter character_U =8'h55;
parameter character_V =8'h56;
parameter character_W =8'h57;
parameter character_X =8'h58;
parameter character_Y =8'h59;
parameter character_Z =8'h5A;

//Lowercase Letters
parameter character_lowercase_a= 8'h61;
parameter character_lowercase_b= 8'h62;
parameter character_lowercase_c= 8'h63;
parameter character_lowercase_d= 8'h64;
parameter character_lowercase_e= 8'h65;
parameter character_lowercase_f= 8'h66;
parameter character_lowercase_g= 8'h67;
parameter character_lowercase_h= 8'h68;
parameter character_lowercase_i= 8'h69;
parameter character_lowercase_j= 8'h6A;
parameter character_lowercase_k= 8'h6B;
parameter character_lowercase_l= 8'h6C;
parameter character_lowercase_m= 8'h6D;
parameter character_lowercase_n= 8'h6E;
parameter character_lowercase_o= 8'h6F;
parameter character_lowercase_p= 8'h70;
parameter character_lowercase_q= 8'h71;
parameter character_lowercase_r= 8'h72;
parameter character_lowercase_s= 8'h73;
parameter character_lowercase_t= 8'h74;
parameter character_lowercase_u= 8'h75;
parameter character_lowercase_v= 8'h76;
parameter character_lowercase_w= 8'h77;
parameter character_lowercase_x= 8'h78;
parameter character_lowercase_y= 8'h79;
parameter character_lowercase_z= 8'h7A;

//Other Characters
parameter character_colon = 8'h3A;          //':'
parameter character_stop = 8'h2E;           //'.'
parameter character_semi_colon = 8'h3B;   //';'
parameter character_minus = 8'h2D;         //'-'
parameter character_divide = 8'h2F;         //'/'
parameter character_plus = 8'h2B;          //'+'
parameter character_comma = 8'h2C;          // ','
parameter character_less_than = 8'h3C;    //'<'
parameter character_greater_than = 8'h3E; //'>'
parameter character_equals = 8'h3D;         //'='
parameter character_question = 8'h3F;      //'?'
parameter character_dollar = 8'h24;         //'$'
parameter character_space=8'h20;           //' '     
parameter character_exclaim=8'h21;          //''!

	//binary MUX with 8 x 3 buses
	//clk_count coresponds to half of the clk count of desired frequency (Do:95602, Re: 85178,....)
	//HEX is last four digits that will be displayed on line 2 of the LCD, showing the frequency of the current signal
	//ChA is characters that will be displayed on info section of Channel A, showing description of the current signal
	always @(*) 
		case(SW[3:1])
			3'b000:	begin 
					clk_count = 32'd47800;	//DO 
					HEX = 16'h523;
					ChA = {character_D,character_lowercase_o};
				end
			3'b001:	begin 
					clk_count = 32'd42590;	//RE
					HEX = 16'h587;
					ChA = {character_R,character_lowercase_e};
				end
			3'b010:	begin 
					clk_count = 32'd37936;	//MI
					HEX = 16'h659;
					ChA = {character_M,character_lowercase_i};
				end
			3'b011:	begin 
					clk_count = 32'd35812;	//FA
					HEX = 16'h698;
					ChA = {character_F,character_lowercase_a};
				end
			3'b100:	begin 
					clk_count = 32'd31928;	//SO
					HEX = 16'h783;
					ChA = {character_S,character_lowercase_o};
				end
			3'b101:	begin 
					clk_count = 32'd28408;	//LA
					HEX = 16'h880;
					ChA = {character_L,character_lowercase_a};
				end
			3'b110:	begin 
					clk_count = 32'd25330;	//SI
					HEX = 16'h987;
					ChA = {character_S,character_lowercase_i};
				end
			3'b111:	begin 
					clk_count = 32'd23900;	//#DO
					HEX = 16'h1046;
					ChA = {character_D,character_lowercase_o,character_plus};
				end
			default: begin 
					clk_count = 32'dx;	
					HEX = 16'hx;
					ChA = {character_question};
				end			
		endcase
	//ChB is characters that will be displayed on info section of Channel B, showing the "On/Off" state of the speaker
	assign ChB = SW[0] ? {character_O,character_lowercase_n}:{character_O,character_lowercase_f,character_lowercase_f};
endmodule
