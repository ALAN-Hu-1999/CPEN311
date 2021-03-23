//  states declare
parameter wait4start    = 5'b00001;
parameter WAIT 		    = 5'b00010;
parameter WRITE 		= 5'b00100;
parameter increament    = 5'b01100;
parameter DONE 		    = 5'b10000;

module mem_init(
    input clk, start, rst,
    output finish, write_en,
    output reg [7:0] address, data
);
    logic [4:0] state;
    logic [7:0] i;

    initial begin 
        state = wait4start;
        i = 8'b0;
    end 

    always_ff @(posedge clk) begin
        case(state)
            wait4start: state <= start ? WAIT : wait4start;
            WAIT:       state <= WRITE;
            WRITE:      state <= increament;
            increament: state <= (i == 255) ? DONE : WAIT;
            DONE:       state <= rst ? wait4start : DONE;
            default:    state <= wait4start;
        endcase
    end

    always_ff @(posedge clk) begin 
        if(state[3])   i <= i + 1'b1;     
        else i <= i;
    end

    assign data     = i;
    assign address  = i;
    assign write_en = state[2];
    assign finish   = state[4];
endmodule