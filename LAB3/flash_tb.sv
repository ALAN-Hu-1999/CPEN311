module flash_tb;
    logic clk_tb, flash_wait_tb, flash_valid_tb, start_tb;
    logic [31:0] flash_data_tb;
    logic flash_read_tb;
    logic [31:0] saved_audio_data_tb;

    flash_control tb2(
        clk_tb, flash_wait_tb, flash_valid_tb, start_tb,
        flash_data_tb,
        flash_read_tb,
        saved_audio_data_tb
    );

    initial forever begin
        clk_tb = 1'b0;  #10;
        clk_tb = 1'b1;  #10;
    end

    initial begin
        //check if it stays in WAIT state
        flash_data_tb = 32'h00ff00ff;
        #40;

        //check if it stays in REQUEST_WAIT state
        start_tb = 1'b1;
        flash_wait_tb = 1'b1;
        #100;
        start_tb = 1'b0;
        
        //check if it save data to output and go back to WAIT
        flash_wait_tb = 1'b0;
        flash_valid_tb = 1'b1;
        #100;
        $stop;
    end
endmodule
