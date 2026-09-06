module cycle (
    input clk,
    input a,
    output reg c
);
    wire x, y;
    assign x = y & a;
    assign y = x | a;
    
    always @(posedge clk) begin
        c <= x;
    end
endmodule
