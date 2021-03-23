//this module uses 50MHz clock
module flash_control(
    input clk, flash_wait, flash_valid, start,
    input [31:0] flash_data,
    output reg flash_read,
    output reg [31:0] saved_audio_data = 32'b0
);

    parameter WAIT          = 5'b00001;
    parameter START_READ    = 5'b00010;
    parameter REQUEST_WAIT  = 5'b00100;
    parameter SAVE_DATA     = 5'b01000;
    parameter FINISH        = 5'b10000;

    logic [4:0] state = WAIT;
    wire edge_of_SAVE_DATA;
	assign edge_of_SAVE_DATA = state[3];
    
    always @(posedge clk) begin
        case(state)
            WAIT:   if(start) state <= START_READ;
                    else state <= WAIT;
            START_READ:     state <= REQUEST_WAIT;
            REQUEST_WAIT:   if(flash_wait)  state <= REQUEST_WAIT;
                            else state <= SAVE_DATA;
            SAVE_DATA:  begin
                        if(flash_valid) state <= FINISH;
                        else state <= SAVE_DATA;
                        saved_audio_data <= flash_data; //output data
            end
            FINISH: state <= WAIT;
            default:    state <= WAIT;
        endcase
    end

    //enable flashread at "START_READ" state
    assign flash_read = (state[1] | state[2] | state[3]);

endmodule