parameter wait_4_start      = 17'b0_0000_0000_0000_0001;
parameter read_Si           = 17'b0_0000_0000_0000_0010;
parameter READ_si_wait      = 17'b0_0000_0000_0000_0100;
parameter STORE_si          = 17'b0_0000_0000_0000_1000;
parameter UPDATE_j          = 17'b0_0000_0000_0001_0000;
parameter read_Sj           = 17'b0_0000_0000_0010_0000;
parameter READ_sj_wait      = 17'b0_0000_0000_0100_0000;
parameter STORE_sj          = 17'b0_0000_0000_1000_0000;
parameter WRITE_Si2Sj       = 17'b0_0000_0001_0000_0000;
parameter WAIT_4_WRITE      = 17'b0_0000_0010_0000_0000;
parameter WRITE_Sj2Si       = 17'b0_0000_0100_0000_0000;
parameter updata_f          = 17'b0_0000_1000_0000_0000;
parameter wait_4_f          = 17'b0_0000_1100_0000_0000;
parameter store_f           = 17'b0_0000_1110_0000_0000;
parameter read_rom          = 17'b0_0001_0000_0000_0000;
parameter wait_4_rom        = 17'b0_0010_0000_0000_0000;
parameter write_2_result    = 17'b0_0100_0000_0000_0000;
parameter wait_for_result   = 17'b0_1000_0000_0000_0000;
parameter increament_k      = 17'b0_1100_0000_0000_0000;
parameter finish_loop3      = 17'b1_0000_0000_0000_0000;

module loop3#(
    parameter message_length = 32)(
    input clk, start, next_byte, rst,
    input [7:0] encryted_data, data_from_mem,
    output reg [7:0] address, data,
    output reg finish, write_en, rom_flag, s_flag, k_flag
    
);
    logic [7:0] i, j, k;
    logic [7:0] DATA_IN_Si, DATA_IN_Sj, DATA_f;
    logic [16:0] state;
    

    always_ff @( posedge clk ) begin
        case(state)
        wait_4_start:   state <= start ? read_Si : wait_4_start;
        read_Si:        state <= READ_si_wait;
        READ_si_wait:   state <= STORE_si;
        STORE_si:       state <= UPDATE_j;  
        UPDATE_j:       state <= read_Sj;
        read_Sj:        state <= READ_sj_wait;  
        READ_sj_wait:   state <= STORE_sj;  
        STORE_sj:       state <= WRITE_Si2Sj;
        WRITE_Si2Sj:    state <= WAIT_4_WRITE;  
        WAIT_4_WRITE:   state <= WRITE_Sj2Si;
        WRITE_Sj2Si:    state <= updata_f;          
        updata_f:       state <= wait_4_f;
        wait_4_f:       state <= store_f;
        store_f:        state <= read_rom;          //working with memory s
        read_rom:       state <= wait_4_rom;
        wait_4_rom:     state <= write_2_result;
        write_2_result: state <= wait_for_result;   //working with rom
        wait_for_result:state <= rst ? wait_4_start : (next_byte ? ((k == (message_length - 1)) ? finish_loop3 : increament_k) : wait_for_result);
        increament_k:   state <= read_Si;
        finish_loop3:   state <= start ? wait_4_start : finish_loop3;
        default: state <= wait_4_start;
        endcase
    end

    always_ff @( posedge clk ) begin
        case(state)
        wait_4_start:   begin
                i <= 8'b0;
                j <= 8'b0;
                k <= 8'b0;
                write_en <= 1'b0;
            end
        read_Si:        begin                       //  start working with ram s
                k_flag <= 1'b0;
                s_flag <= 1'b1;
                rom_flag <= 1'b0;
                i <= i + 1'b1;
                address <= i + 1'b1;  //have to does since its no-blocking assignment
            end
		  READ_si_wait: begin end
        STORE_si:       DATA_IN_Si <= data_from_mem;
        UPDATE_j:       j <= j + DATA_IN_Si;
        read_Sj:        address <= j;
		  READ_sj_wait: begin end
        STORE_sj:       DATA_IN_Sj <= data_from_mem;
        WRITE_Si2Sj:    begin
                address <= j;
                data <= DATA_IN_Si;
                write_en <= 1'b1;
            end
        WAIT_4_WRITE:   write_en <= 1'b0;
        WRITE_Sj2Si:    begin
                address <= i;
                data <= DATA_IN_Sj;
                write_en <= 1'b1;
            end
        updata_f:       begin
                address <= DATA_IN_Si + DATA_IN_Sj;
                write_en <= 1'b0;
            end
		  wait_4_f: begin end
        store_f:        DATA_f <= data_from_mem;
        read_rom:       begin                       //  start working with rom
                k_flag <= 1'b0;
                s_flag <= 1'b0;
                rom_flag <= 1'b1;
                address <= k;
            end
		  wait_4_rom: begin end
        write_2_result: begin                       // start working with rem k
                k_flag <= 1'b1;
                s_flag <= 1'b0;
                rom_flag <= 1'b0;
                write_en <= 1'b1;
                address <= k;
                data <= DATA_f ^ encryted_data;
            end
        wait_for_result: begin
                write_en <= 1'b0;
                k_flag <= 1'b0;         // to keep fsm check_result to stay in "check_byte" state unitil the next result is ready
            end
        increament_k: k <= k + 1'b1;
        finish_loop3: begin end
        default:    begin
                i <= 8'b0;
                j <= 8'b0;
                k <= 8'b0;
                write_en <= 1'b0;
            end
        endcase
    end
    assign finish = state[16];
endmodule