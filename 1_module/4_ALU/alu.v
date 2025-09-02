// alu

module alu (
	input clock,
	input [15:0] buswires,
	// input control
	input ain, // register A
	input gin, // register G
	input sub, // sub=0-->add, sub=1-->sub
	// output
	output [15:0] aluout
);
	reg [15:0] reg_A;
	reg [15:0] reg_G;
	
	wire [15:0] raout;
	wire [15:0] addsub_result;
	
	// load data in register A
	always @(posedge clock) begin
		if (ain) begin
			reg_A <= buswires;
		end
	end
	
	assign raout = reg_A;
	
	// add sub caculate
	assign addsub_result = (sub==1'b0) ? (raout + buswires) : (raout - buswires);
	
	// result in register G
	always @(posedge clock) begin
		if (gin) begin
			reg_G <= addsub_result;
		end
	end
	
	assign aluout = reg_G;
	
endmodule