module cdc_test(
    input clk1, input clk2, input rst, input d_in, output reg q_out
);
    reg q1;
    always @(posedge clk1 or posedge rst) begin
        if (rst) q1 <= 0;
        else q1 <= d_in;
    end
    always @(posedge clk2 or posedge rst) begin
        if (rst) q_out <= 0;
        else q_out <= ~q1;
    end
endmodule
