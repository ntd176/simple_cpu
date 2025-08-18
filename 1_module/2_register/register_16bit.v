// Thanh ghi 16 bit

module register_16bit (
	input clk,
	input enable,
	input [15:0] data_in,
	output reg [15:0] data_out
);
	always @(posedge clk) begin
		if (enable) begin
			data_out <= data_in;
		end 
	end
	
endmodule