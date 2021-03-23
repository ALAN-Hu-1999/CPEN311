module KBD_tb;
    logic restart_done_tb, KBD_ready_tb;
    logic [7:0] letter_tb;
    logic restart_tb, start_tb, direction_tb;

    KBD_control tb4(
        restart_done_tb, KBD_ready_tb,
        letter_tb,
        restart_tb, start_tb, direction_tb
    );

    initial forever begin
        KBD_ready_tb = 1'b0; #10;
        KBD_ready_tb = 1'b1; #10;
    end

    initial begin
        restart_done_tb = 1'b0;
        //testing E
        letter_tb = 8'h45;
        #40;

        //testing D
        letter_tb = 8'h44;
        #40;

        //testing F
        letter_tb = 8'h46;
        #40;

        //testing B
        letter_tb = 8'h42;
        #40;

        //testing R
        letter_tb = 8'h52;
        #40;

        //testing R, with restart_done
        letter_tb = 8'h52;
        restart_done_tb = 1'b1;
        #40;
        $stop;
    end
endmodule
