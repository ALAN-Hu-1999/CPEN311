module DAC_tb;
    logic clk_tb, start_tb, restart_tb, direction_tb;
    logic [31:0] save_audio_data_tb;
    logic [31:0] address_tb;
    logic [15:0] audio_out_tb;
    logic DAC_done_tb, restart_done_tb;

    DAC_control tb_1(
        clk_tb, start_tb, restart_tb, direction_tb,
        save_audio_data_tb,
        address_tb,
        audio_out_tb,
        DAC_done_tb, restart_done_tb
    );

    initial forever begin
        clk_tb = 1'b0; #10;
        clk_tb = 1'b1; #10;
    end

    initial begin
        //testing read forward
	    direction_tb = 1'b1;
        start_tb = 1'b1;
        restart_tb = 1'b0;
        save_audio_data_tb = 32'h00ff00ff;
        #170;

        //testing read backward
        direction_tb = 1'b0;
        #400;

        //testing restart
        restart_tb = 1'b1;
        #40;
        $stop;
    end
endmodule
