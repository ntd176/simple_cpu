// alu

module alu (
	input clock,
	input [15:0] buswires,
	// input control
	input ain, // register A
	input gin, // register B
	input sub, // sub=0-->add, sub=1-->sub
	// output
	output reg [15:0] aluout
);
	reg [15:0] reg_A;
	
	wire [15:0] addsub_result;
	
	// load data in register A
	always @(posedge clock) begin
		if (ain) begin
			reg_A <= buswires;
		end
	end
	
	// add sub caculate
	assign addsub_result = (sub==1'b0) ? (reg_A + buswires) : (reg_A - buswires);
	
	// result in register B
	always @(posedge clock) begin
		if (gin) begin
			aluout <= addsub_result;
		end
	end
	
endmodule