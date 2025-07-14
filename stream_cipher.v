`include "prng.v"

module stream_cipher (
    input clk,
    input load_seed,
    input rst_n,
    input [7:0] seed_in,
    input encrypt_en,
    input [7:0] data_in,
    output reg [7:0] data_out
);

wire [7:0] prng;
reg [7:0] data_in_delay;
reg [7:0] encrypt_en_delay;

prng PRNG(
    .clk(clk),
    .rst_n(rst_n),
    .load_seed(load_seed),
    .seed_in(seed_in),
    .encrypt_en(encrypt_en),
    .prng(prng)
);

//delay for prng to work
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_in_delay <= 0;
        encrypt_en_delay <= 0;
    end
    else begin
        data_in_delay <= data_in;
        encrypt_en_delay <= encrypt_en;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_out <= 0;
    end
    else if(encrypt_en_delay) begin
        data_out <= data_in_delay ^ prng;
    end
end
    
endmodule