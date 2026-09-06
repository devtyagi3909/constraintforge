module simple (
    input clk,
    input a,
    input b,
    output reg c
);
    always @(posedge clk) begin
        c <= a & b;
    end
endmodule
