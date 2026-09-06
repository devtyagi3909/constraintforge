module child (
    input clk, input d, output reg q
);
    always @(posedge clk) q <= d;
endmodule

module hier (
    input clk, input d, output q
);
    child u_child (.clk(clk), .d(d), .q(q));
endmodule
