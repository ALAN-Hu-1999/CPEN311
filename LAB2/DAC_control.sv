//module in here uses 22kHz clock
module DAC_control(
    input clk, start, restart, direction,
    input [31:0] save_audio_data,
    output reg [31:0] address,
    output reg [15:0] audio_out,
    output reg DAC_done, restart_done
);
    logic [1:0] count;

    parameter LAST_ADDR = 32'h7FFFF;

    initial begin
        DAC_done = 1'b0;
        restart_done = 1'b0;
        address = 32'b0;
        count = 2'b0;
    end


    always @(posedge clk or posedge restart) begin
//------restart, after "R" is pressed
        if(restart) begin 
            address <= 32'b0;
            restart_done <= 1'b1;
        end
//------pause, after "D" is pressed
        else if(!start) begin 
            audio_out <= 16'b0;
            restart_done <= 1'b0;
        end 
//----------play forward, after "F" is pressed
        else begin  //(start & !restart)
            restart_done = 1'b0;
            if(direction) begin 
                count <= count + 1'b1;
                //assign audio output depending on "count"
                if(count == 2'b00)      audio_out <= save_audio_data[7:0];
                else if(count == 2'b01) audio_out <= save_audio_data[15:8];
                else if(count == 2'b10) audio_out <= save_audio_data[23:16];
                else begin 
                    //increament address
                    audio_out <= save_audio_data[31:24];
                    address <= ((address < 32'b0) | (address > LAST_ADDR)) ? 32'b0 : (address + 32'b1);
                end
            end
//----------play backward, after "B" is pressed
            else begin  
                count <= count + 1'b1;
                if(count == 2'b00)      audio_out <= save_audio_data[31:24];
                else if(count == 2'b01) audio_out <= save_audio_data[23:16];
                else if(count == 2'b10) audio_out <= save_audio_data[15:8];
                else begin 
                    //increament address
                    audio_out <= save_audio_data[7:0];
                    address <= ((address < 32'b0) | (address > LAST_ADDR)) ? LAST_ADDR : (address - 32'b1);
                end
            end
            //DAC_done tells flash to read
            DAC_done <= (count == 2'b11) ? 1'b1 : 1'b0;
            
        end
    end
endmodule