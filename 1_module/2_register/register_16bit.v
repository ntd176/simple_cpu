// Thanh ghi 16 bit

module register_16bit (
	input clock,
	input rin_en,
	input [15:0] buswires,
	output reg [15:0] rout
);
	always @(posedge clock) begin
		if (rin_en) begin
			rout <= buswires;
		end 
	end
	
endmodule