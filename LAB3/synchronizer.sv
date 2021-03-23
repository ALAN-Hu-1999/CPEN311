//this scychornizer is from the submitted Q7.v code in HW1 (reused)
//this was complied and tested in HW1
//takes signal "async_sig" and synchornizes it with the desired "outclk"
module synchronizer(
    input async_sig, outclk,
    output out_sync_sig
);
    logic VCC2, VCC3, FDC_1_out;

    flip_flop FDC_2(.D(1'b1), .C(async_sig), .CLR(FDC_1_out), .Q(VCC2));
    flip_flop FDC_3(.D(VCC2), .C(outclk), .CLR(1'b0), .Q(VCC3));
    flip_flop FDC_4(.D(VCC3), .C(outclk), .CLR(1'b0), .Q(out_sync_sig));
    flip_flop FDC_1(.D(out_sync_sig), .C(outclk), .CLR(1'b0), .Q(FDC_1_out));
endmodule

module flip_flop(
    input D, C, CLR,
    output reg Q
);
    always_ff @(posedge C, posedge CLR) begin
        if(CLR) Q <= 1'b0;
        else    Q <= D;
    end

endmodule