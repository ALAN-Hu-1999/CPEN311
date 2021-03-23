parameter waitFORstart      = 4'b0001;
parameter increamt_counter  = 4'b0010;
parameter key_gen_finish    = 4'b0100;
parameter key_space_finish  = 4'b1000;
module key_gen(
    input clk, start, 
    output reg [23:0] generated_key,
    output reg finish, finsih_key_space
);
    logic [21:0] counter;
    logic [3:0] state;
    initial begin
        counter = 22'b0;
    end

    always_ff @( posedge clk ) begin 
        case(state)
        waitFORstart:         state <= start ? increamt_counter : waitFORstart;
        increamt_counter:   begin
                state <= key_gen_finish;
                counter <= counter + 1'b1;
            end
        key_gen_finish:     state <= (counter == 22'h3FFFFF) ? key_space_finish : waitFORstart;
        key_space_finish:   state <= key_space_finish;
        default: state <= waitFORstart;
        endcase
    end

    //assign counter = state[1] ? counter + 1'b1 : counter;
    assign finish = state[0];
    assign finsih_key_space = state[3];
    assign generated_key = {2'b0, counter};
endmodule