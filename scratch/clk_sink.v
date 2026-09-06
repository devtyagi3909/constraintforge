module clk_sink (
    input clk_in,
    input a,
    input d,
    output reg q
);
    wire clk = clk_in ^ a;
    always @(posedge clk) begin
        q <= d;
    end
endmodule
