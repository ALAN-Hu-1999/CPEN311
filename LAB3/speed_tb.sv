module speed_tb;
    logic clk_tb, speed_up_tb, speed_down_tb, reset_tb;
    logic [31:0] clk_count_tb;

    speed_control tb3(
        clk_tb, speed_up_tb, speed_down_tb, reset_tb,
        clk_count_tb
    );
    initial forever begin
        clk_tb = 1'b0; #10;
        clk_tb = 1'b1; #10;
    end

    initial begin
        //testing speed up
        speed_up_tb = 1'b1;
        #80;
        speed_up_tb = 1'b0;

        //testing speed down
        speed_down_tb = 1'b1;
        #120;
        speed_down_tb = 1'b0;

        //testing reset
        reset_tb = 1'b1;
        #50;
        reset_tb = 1'b0;
        $stop;
    end
endmodule
