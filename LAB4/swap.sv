parameter WAIT_4_start  = 11'b000_0000_0001;
parameter READ_si       = 11'b000_0000_0010;
parameter read_si_wait  = 11'b000_0000_0011;
parameter store_si      = 11'b000_0000_0100;
parameter update_j      = 11'b000_0000_1000;
parameter READ_sj       = 11'b000_0001_0000;
parameter read_sj_wait  = 11'b000_0001_1000;
parameter store_sj      = 11'b000_0010_0000;
parameter write_si2sj   = 11'b000_0100_0000;
parameter wait_4_write1 = 11'b000_1000_0000;
parameter write_sj2si   = 11'b001_0000_0000;
parameter wait_4_write2 = 11'b010_0000_0000;
parameter increament_i  = 11'b011_0000_0000;
parameter finish_swap   = 11'b100_0000_0000;
module swap (
    input clk, start, rst,
    input [23:0] key,
    input [7:0] data_from_mem,

    output reg [7:0] data, address,
    output reg write_en, finish
);
    logic [7:0] i, j, k = 8'b0;
    logic [7:0] data_in_si, data_in_sj;
    logic [7:0] selected_key;
    logic [10:0] state;

    //  select byte in key base on "i mod 3"
    always @( posedge clk) begin 
        k <= i % 2'b11;
        case(k)
        2'b00:  selected_key <= key[23:16];
        2'b01:  selected_key <= key[15:8];
        2'b10:  selected_key <= key[7:0];
        default: selected_key <= 8'b0;
        endcase 
    end

    always_ff @( posedge clk ) begin
        case(state)
        WAIT_4_start:   state <= start ? READ_si : WAIT_4_start;
        READ_si:        state <= read_si_wait;
        read_si_wait:   state <= store_si;
        store_si:       state <= update_j;
        update_j:       state <= READ_sj;
        READ_sj:        state <= read_sj_wait;
        read_sj_wait:   state <= store_sj;
        store_sj:       state <= write_si2sj;
        write_si2sj:    state <= wait_4_write1;
        wait_4_write1:  state <= write_sj2si;
        write_sj2si:    state <= wait_4_write2; 
        wait_4_write2:  state <= (i == 255) ? finish_swap : increament_i;
        increament_i:   state <= READ_si;
        finish_swap:    state <= rst ? WAIT_4_start : finish_swap;
        default: state <= WAIT_4_start;
        endcase
    end

    always_ff @( posedge clk ) begin
        case(state)
        WAIT_4_start:   begin
                i <= 8'b0;
                j <= 8'b0;
                //k <= 8'b0;
                write_en <= 1'b0;
            end
        READ_si:    address <= i;
        read_si_wait: begin end
        store_si:   data_in_si <= data_from_mem;
        update_j:   j <= j + data_in_si + selected_key; 
        READ_sj:        address <= j;
        read_sj_wait: begin end
        store_sj:       data_in_sj <= data_from_mem;
        write_si2sj:    begin
                address <= j;
                data <= data_in_si;
                write_en <= 1'b1;
            end
        wait_4_write1:  write_en =1'b0;
        write_sj2si:    begin
                address <= i;
                data <= data_in_sj;
                write_en <= 1'b1;
            end
        wait_4_write2:  write_en <= 1'b0;
        increament_i:   i <= i + 1'b1; 
        finish_swap: begin end
		default:	begin
                i <= 8'b0;
                j <= 8'b0;
                write_en <= 1'b0;
            end
        endcase
    end
    assign finish = state[10];
endmodule 