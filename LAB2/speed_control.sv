module speed_control(
    input clk, speed_up, speed_down, reset,
    output reg [31:0] clk_count
);
    parameter default_clk = 32'd1136;
    initial begin
        clk_count = default_clk;
    end

    always @(posedge clk) begin
       if(reset)        clk_count <= default_clk;
       if(speed_up)     clk_count <= clk_count - 1'b1;
       if(speed_down)   clk_count <= clk_count + 1'b1;
    end
endmodule