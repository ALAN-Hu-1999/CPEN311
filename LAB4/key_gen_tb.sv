module key_gen_tb;
    logic clk_tb, start_tb;
    logic [23:0] generated_key_tb;
    logic finish_tb, finsih_key_space_tb;

    key_gen tb3(
        clk_tb, start_tb, 
        generated_key_tb,
        finish_tb, finsih_key_space_tb
    );

    initial forever begin
        clk_tb = 1'b0;  #10;
        clk_tb = 1'b1;  #10;
    end

    initial begin
        start_tb = 1'b0;
        #50;
        start_tb = 1'b1;
        #20;
        start_tb = 1'b0;
        #50;
        $stop;
    end
endmodule 