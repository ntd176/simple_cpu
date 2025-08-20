// multiplexer

module multiplexer(
	// input data
	input [15:0] din,
	input [15:0] aluout,
	input [15:0] r0,
	input [15:0] r1,
	input [15:0] r2,
	input [15:0] r3,
	input [15:0] r4,
	input [15:0] r5,
	input [15:0] r6,
	input [15:0] r7,
	// input control
	input din_en,
	input gout,
	input [2:0] rout,
	// output data
	output reg [15:0] buswires
); 

	always @(*) begin
		// uu tien 1
		if (din_en) begin
			buswires = din;
		end
		// uu tien 2
		else if (gout) begin
			buswires = aluout;
		end
		// cuoi cung
		else begin
			case (rout)
				3'b000: buswires = r0;
				3'b001: buswires = r1;
				3'b010: buswires = r2;
				3'b011: buswires = r3;
				3'b100: buswires = r4;
				3'b101: buswires = r5;
				3'b110: buswires = r6;
				3'b111: buswires = r7;
				default: buswires = 16'h0000;
			endcase
		end
	end

endmodule 