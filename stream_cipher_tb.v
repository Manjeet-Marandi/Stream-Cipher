`timescale 1ps/1ps
`include "stream_cipher.v"

module encrypt_tb ();
    
reg clk = 0;
reg load_seed;
reg rst_n;
reg [7:0] seed_in;
reg encrypt_en;
reg [7:0] data_in;
wire [7:0] data_out;

stream_cipher uut(
    .clk(clk),
    .load_seed(load_seed),
    .rst_n(rst_n),
    .seed_in(seed_in),
    .encrypt_en(encrypt_en),
    .data_in(data_in),
    .data_out(data_out)
);

always begin
    #0.5; clk = ~clk;
end

initial begin
    rst_n = 0;
    @(posedge clk);

    //encryption
    rst_n = 1;
    seed_in = 8'b1101_0111;
    load_seed = 1;
    data_in = 8'b1001_1001;
    @(posedge clk);
    load_seed = 0;
    encrypt_en = 1;
    @(posedge clk);
    encrypt_en = 0;
    repeat (3) @(posedge clk); 
    $display("data_in=%b, data_out=%b",data_in, data_out);

    //decryption
    @(posedge clk);
    seed_in = 8'b1101_0111;
    load_seed = 1;
    data_in = 8'b0111_0010;
    @(posedge clk);
    load_seed = 0;
    encrypt_en = 1;
    @(posedge clk);
    encrypt_en = 0;
    repeat (3) @(posedge clk);
    $display("data_in=%b, data_out=%b", data_in, data_out);
    $finish;    
end

endmodule