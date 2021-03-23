module mem_init_tb;
    logic clk_tb, start_tb, rst_tb, finish_tb, write_en_tb;
    logic [7:0] address_tb, data_tb;
    mem_init tb1(
        clk_tb, start_tb, rst_tb, 
        finish_tb, write_en_tb,
        address_tb, data_tb
    );
    initial forever begin
        clk_tb = 1'b0; #10;
        clk_tb = 1'b1; #10;
    end
    initial begin
        start_tb = 1'b1;
        rst_tb = 1'b0;
        //data_tb = 8'b0;
        //address_tb = 8'b0;
    end
endmodule