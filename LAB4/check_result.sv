//parameter wait_2_check  = 5'b00001;
parameter check_byte    = 5'b00010;
parameter next_byte     = 5'b00100;
parameter try_new_key   = 5'b01000;
parameter we_found_key  = 5'b10000;
module check_result#(
    parameter MESSAGE_LENGTH = 32)(
    input clk, k_flag, 
    input [7:0] data,   // the data that is about to be writen to k memory
    output reg key_found, next_key, checked_byte
);
    logic [4:0] count;
    logic [4:0] state; 
    initial begin
        count = 5'b0;
    end

    always_ff @( posedge clk ) begin 
        case(state)     //  first check if result is ready (k_flag)    
                        //  if yes go check current byte (starting with 0), else wait
                        //  if current byte is lowcase acsii character or spacebar, go to next byte, else try next key
                        //  if all bytes are checked without going to next key, then the current key is the secret key :)
        check_byte:     state <= k_flag ? ((count == MESSAGE_LENGTH - 1) ? we_found_key : ((data == 8'd32) | ((data >= 8'd97) & (data <= 8'd122)) ? next_byte : try_new_key)) : check_byte;
        next_byte:      begin 
                state <= check_byte;
                count <= count + 1'b1;
            end
        try_new_key:    begin
                state <= check_byte;
                count <= 5'b0;
            end
        we_found_key:   state <= we_found_key;
        default:        state <= check_byte;
        endcase
    end

    assign key_found = state[4];
    assign next_key = state[3];     
    //assign count = state[2] ? count + 1'b1 : count;
    assign checked_byte = state[2];
endmodule 