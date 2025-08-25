// =-= control unit =-= 

module control_unit (
	// --- input ---
	input run,
	input resetn,		// reset active low
	input [8:0] ir,		// instruction register
	input [1:0] state,
	
	// --- output ---
	// output control alu
	output reg ain,
	output reg gin,
	output reg sub,
	
	// output control register and mux
	output reg [7:0] rin,	// bus write data in register ro --> r7
	output reg [2:0] rout,	// select register ro --> r7 to bus
	output reg din_en,		// enable data from din to bus
	output reg gout, 		// enable alu result in bus
	output reg dout_en,		// enable data out
	
	// output general control
	output reg ir_en, 
	output reg done
);

	wire [2:0] opcode = ir[8:6]; // opcode
	wire [2:0] rx	  = ir[5:3]; // source_1/ destination register address
	wire [2:0] ry	  = ir[2:0]; // source_2 register address
	
	localparam MV  = 3'b000; 
	localparam MVI = 3'b001;
	localparam ADD = 3'b010;
	localparam SUB = 3'b011;
	localparam MVO = 3'b100;
	
	// --- main ---
	always @(*) begin
		// initial value output
		ain		= 1'b0;
		gin 	= 1'b0;
		sub 	= 1'b0;
		// --------------------
		rin 	= 8'h00;
		rout 	= 3'b000;
		din_en 	= 1'b0;
		gout 	= 1'b0;
		dout_en = 1'b0;
		// --------------------
		ir_en 	= 1'b0;
		done 	= 1'b0;
		
		if (run && resetn) begin
			case (state)
				// --- state 0: fetch ---
				2'd0: begin
					ir_en = 1'b1;
				end
				// --- state 1: decode / execute ---
				2'd1: begin
					case (opcode)
						MV: begin
							rout = ry;
							rin = (1 << rx); // 1 là hằng số, rx số bit cần dịch
							done = 1'b1;
						end
						MVI: begin
							din_en = 1'b1;
							rin = (1 << rx);
							done = 1'b1;
						end
						MVO: begin
							rout = rx;
							dout_en = 1'b1;
							done = 1'b1;
						end
						ADD, SUB: begin
							rout = rx;
							ain = 1'b1;
						end
						default: begin
							done = 1'b1;
						end
					endcase
				end
				// --- state 2: alu execute ---
				2'd2: begin
					if (opcode == ADD || opcode == SUB) begin
						rout = ry;
						gin = 1'b1;
						sub = (opcode == SUB);
					end
				end
				// --- state 3: writeback ---
				2'd3: begin
					if (opcode == ADD || opcode == SUB) begin
						gout = 1'b1;
						rin = (1 << rx);
						done = 1'b1;
					end
				end
			endcase
		end
	end
	
endmodule