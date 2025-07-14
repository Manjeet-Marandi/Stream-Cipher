module prng #(
    parameter SEED = 8'b1110_1110
)(
    input clk,
    input rst_n,
    input load_seed,
    input [7:0] seed_in,
    input encrypt_en,
    output reg [7:0] prng
);

wire feedback;
assign feedback = seed_in[7] ^ seed_in[6] ^ seed_in[3] ^ seed_in[2];

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        prng <= SEED;
    end
    else if(load_seed) begin
        prng <= seed_in;
    end
    else if(encrypt_en) begin
        prng <= {feedback, prng[7:1]};
    end
end
endmodule