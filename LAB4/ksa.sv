+module ksa(
    input CLOCK_50,
    input [3:0] KEY,
    input [9:0] SW,
    output [9:0] LEDR,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5
);
    logic CLK_50M;
    logic [9:0] LED;
    logic [6:0] ssOut;
    //logic [3:0] nIn;
    //logic reset_n;
    //logic first_start;

    
    assign LED[9:2] = 8'b0;

    assign CLK_50M = CLOCK_50;
    assign LEDR[9:0] = LED[9:0];
    //assign reset_n = KEY[3];

// untill now, it is translated from the ksa.vhd

    //  part III
    logic init_write, init_finish, reset_i, key_gen_finish, next_key, key_space_finish;
    logic [23:0] secret_key;
	logic [7:0] init_data, init_address;

    SevenSegmentDisplayDecoder SevSeg0(.ssOut(HEX0), .nIn(secret_key[7:4]));
    SevenSegmentDisplayDecoder SevSeg1(.ssOut(HEX1), .nIn(secret_key[7:4]));
    SevenSegmentDisplayDecoder SevSeg2(.ssOut(HEX2), .nIn(secret_key[11:8]));
    SevenSegmentDisplayDecoder SevSeg3(.ssOut(HEX3), .nIn(secret_key[15:12]));
    SevenSegmentDisplayDecoder SevSeg4(.ssOut(HEX4), .nIn(secret_key[19:16]));
    SevenSegmentDisplayDecoder SevSeg5(.ssOut(HEX5), .nIn(secret_key[23:20]));

    //  since the generated_key is default as 0, we dont need to start key_gen the first time we run the program
    assign LED[1] = key_space_finish;   //no match key in the key space
    key_gen get_new_key(
        .clk(CLK_50M), .start(next_key), 
        .generated_key(secret_key),
        .finish(key_gen_finish), .finsih_key_space(key_space_finish)
    );

    //assign start_init = init_finish ? 1'b0 : start_init;    // start_init will be 0 after first initialization
    //assign start_init = key_gen_finish ? 1'b1 : 1'b0;
    //  part I
	//assign reset_i = 1'b0;
    mem_init initialize_mem(
        .clk(CLK_50M), .start(key_gen_finish), .rst(next_key),
        .finish(init_finish), .write_en(init_write),
        .address(init_address), .data(init_data)
    );
    

    logic [7:0] data_from_mem, mem_address, mem_data, loop3_address, loop3_data;
    logic [7:0] swap_data, swap_address;
    logic swap_write, swap_finish, loop3_finish, loop3_write, use_s, s_flag, k_flag, write_mem;
    assign mem_address  = init_finish ?     (swap_finish ?  loop3_address   : swap_address)     : init_address;
    assign mem_data     = init_finish ?     (swap_finish ?  loop3_data      : swap_data)        : init_data;
    assign write_mem    = init_finish ?     (swap_finish ?  loop3_write     : swap_write)       : init_write;
    assign s_flag = swap_finish ? use_s : 1'b1;
    s_memory REM(
        .address(mem_address),.clock(CLK_50M),.data(mem_data),.wren(write_mem & s_flag),
        .q(data_from_mem)
    );
    
    // part II 
    //assign secret_key[23:10] = 14'b0;   //this is for task2 only 
    //assign secret_key[9:0] = SW;

    //encryption 
    swap swap_i_n_j(
        .clk(CLK_50M), .start(init_finish), .rst(next_key),
        .key(secret_key),
        .data_from_mem(data_from_mem),
        .data(swap_data), .address(swap_address),
        .write_en(swap_write), .finish(swap_finish)
    );

    //ROM
    logic [7:0] rom_address, data_from_rom, rom_flag;
    assign rom_address = rom_flag ? loop3_address : 8'b0;
    message ROM(
        .address(rom_address), .clock(CLK_50M),
        .q(data_from_rom)
    );

    //MEM_k
    logic [7:0] data_from_mem_k;
    k_memory REM_k(
        .address(mem_address),.clock(CLK_50M),.data(mem_data),.wren(write_mem & k_flag),
        .q(data_from_mem_k)
    );
	 
    logic [7:0]  data_from_ram;
    logic next_byte;
    assign data_from_ram = k_flag ? data_from_mem_k : data_from_mem;
    //decryption
	loop3 decrytion(
        .clk(CLK_50M), .start(swap_finish), .next_byte(next_byte), .rst(next_key),
        .encryted_data(data_from_rom), .data_from_mem(data_from_ram),
        .address(loop3_address), .data(loop3_data), 
        .finish(loop3_finish), .write_en(loop3_write), .rom_flag(rom_flag), .s_flag(use_s), .k_flag(k_flag)
    );

    // part III
    logic key_found;
    assign LED[0] = key_found;   //we found key, finsihed!
    check_result ckeck_current_data_in_k(
        .clk(CLK_50M), .k_flag(k_flag), 
        .data(loop3_data),   
        .key_found(key_found), .next_key(next_key), .checked_byte(next_byte)
    );


    
endmodule