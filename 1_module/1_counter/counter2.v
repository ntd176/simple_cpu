// Mo ta: Thiet ke bo dem 2-bit tin hieu clear khong dong bo

module counter2 (
	input clock,
	input clear,
	output reg [1:0] state
);

always @(posedge clock or posedge clear) begin
    if (clear == 1'b1) begin
        state <= 2'b00;  // resset 0
    end
    else begin
        state <= state + 1'b1;  // tang trang thai dem 1
    end
end

endmodule
