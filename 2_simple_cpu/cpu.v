// === cpu === //

//=================================================
// module register 16-bit
//=================================================
module register_16bit_cpu (
	input 		 clk,
	input 		 resetn,
	input 		 write_enable,
	input [15:0] bus_in,
	output reg 	 data_out
);
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			data_out <= 16'h0000;
		end
		else if (write_enable) begin
			data_out <= bus_in;
		end 
	end
endmodule

//=================================================
// module instruction register IR
//=================================================
module ir_cpu (
	input 		 	 clk,
	input 		 	 resetn,
	input 		 	 ir_en,
	input 	  [15:0] buswires,
	output reg [8:0] ir
);
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			ir <= 9'b0;
		end
		else if (ir_en) begin
			ir <= buswires[8:0];
		end
	end
endmodule

//=================================================
// module register file r0-r7
//=================================================
module register_file_cpu (
	input 		  clk,
	input 		  resetn,
	input  [7:0]  rin,
	input  [15:0] buswires,
	output [15:0] r0_out, r1_out, r2_out, r3_out,
	output [15:0] r4_out, r5_out, r6_out, r7_out
);
	register_16bit_cpu reg0 (.clk(clk), .resetn(resetn), .write_enable(rin[0]), .bus_in(buswires), .data_out(r0_out));
	register_16bit_cpu reg1 (.clk(clk), .resetn(resetn), .write_enable(rin[1]), .bus_in(buswires), .data_out(r1_out));
	register_16bit_cpu reg2 (.clk(clk), .resetn(resetn), .write_enable(rin[2]), .bus_in(buswires), .data_out(r2_out));
	register_16bit_cpu reg3 (.clk(clk), .resetn(resetn), .write_enable(rin[3]), .bus_in(buswires), .data_out(r3_out));
	register_16bit_cpu reg4 (.clk(clk), .resetn(resetn), .write_enable(rin[4]), .bus_in(buswires), .data_out(r4_out));
	register_16bit_cpu reg5 (.clk(clk), .resetn(resetn), .write_enable(rin[5]), .bus_in(buswires), .data_out(r5_out));
	register_16bit_cpu reg6 (.clk(clk), .resetn(resetn), .write_enable(rin[6]), .bus_in(buswires), .data_out(r6_out));
	register_16bit_cpu reg7 (.clk(clk), .resetn(resetn), .write_enable(rin[7]), .bus_in(buswires), .data_out(r7_out));
endmodule

//=================================================
// module counter state
//=================================================
module counter_2bit_cpu (
	input 			 clk,
	input 			 resetn, // reset chung he thong
	input 			 clear,	// reset bo dem ve 0 khi done = 1
	output reg [1:0] state
);
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			state <= 2'b00;
		end else if (clear) begin
			state <= 2'b00;
		end else begin
			state <= state + 1'b1;
		end
	end
endmodule

//=================================================
// module ALU
//=================================================
module alu_cpu (
	input 		  clk,
	input 		  resetn,
	input  [15:0] buswires,
	input 		  ain, 
	input 		  gin, 
	input 		  sub,
	output [15:0] aluout
);
	reg [15:0] reg_A;
	reg [15:0] reg_G;
	wire [15:0] raout = reg_A;
	wire [15:0] addsub_result = (sub==1'b0) ? (raout + buswires) : (raout - buswires);
	
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			reg_A <= 16'h0000;
		end
		else if (ain) begin
			reg_A <= buswires;
		end
	end
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			reg_G <= 16'h0000;
		end 
		else if (gin) begin
			reg_G <= addsub_result;
		end
	end
	assign aluout = reg_G;	
endmodule

//=================================================
// module multiplexer
//=================================================
module multiplexer_cpu(
	input 	   [15:0] din,
	input 	   [15:0] aluout,
	input 	   [15:0] r0_out,
	input 	   [15:0] r1_out,
	input 	   [15:0] r2_out,
	input 	   [15:0] r3_out,
	input 	   [15:0] r4_out,
	input 	   [15:0] r5_out,
	input 	   [15:0] r6_out,
	input 	   [15:0] r7_out,
	input 		 	  din_en,
	input 		      gout,
	input 	   [2:0]  rout,
	output reg [15:0] buswires
); 
	always @(*) begin
		if (din_en) begin
			buswires = din;
		end
		else if (gout) begin
			buswires = aluout;
		end
		else begin
			case (rout)
				3'b000: buswires = r0_out;
				3'b001: buswires = r1_out;
				3'b010: buswires = r2_out;
				3'b011: buswires = r3_out;
				3'b100: buswires = r4_out;
				3'b101: buswires = r5_out;
				3'b110: buswires = r6_out;
				3'b111: buswires = r7_out;
				default: buswires = 16'hXXXX;
			endcase
		end
	end
endmodule 

//=================================================
// module control unit
//=================================================
module control_unit_cpu (
	input 			 run,
	input 			 resetn,		
	input 	   [8:0] ir,
	input 	   [1:0] state,
	output reg 		 ain,
	output reg 		 gin,
	output reg 		 sub,
	output reg [7:0] rin,
	output reg [2:0] rout,
	output reg 		 din_en,
	output reg 		 gout,
	output reg 		 ir_en,
	output reg 		 clear,
	output reg 		 done
);
	wire [2:0] opcode = ir[8:6];
	wire [2:0] rx	  = ir[5:3];
	wire [2:0] ry	  = ir[2:0];	
	localparam MV  = 3'b000; 
	localparam MVI = 3'b001;
	localparam ADD = 3'b010;
	localparam SUB = 3'b011;
	
	always @(*) begin
		ain		= 1'b0;
		gin 	= 1'b0;
		sub 	= 1'b0;
		// --------------------
		rin 	= 8'h00;
		rout 	= 3'b000;
		din_en 	= 1'b0;
		gout 	= 1'b0;
		// --------------------
		ir_en 	= 1'b0;
		clear	= 1'b0;
		done 	= 1'b0;
		
		if (run && resetn) begin
			case (state)
				// --- state 0: fetch ---
				2'd0: begin
					ir_en = 1'b1;
					din_en = 1'b1;
				end
				// --- state 1: decode / execute ---
				2'd1: begin
					case (opcode)
						MV: begin
							rout = ry;
							rin = (1 << rx); // 1 là hằng số, rx số bit cần dịch
							done = 1'b1;
							clear = 1'b1;
						end
						MVI: begin
							din_en = 1'b1;
							rin = (1 << rx);
							done = 1'b1;
							clear = 1'b1;
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
						clear = 1'b1;
					end
				end
			endcase
		end
	end
endmodule

//=================================================
// module main cpu
//=================================================
module cpu (
	input 		 clk,
	input 		 resetn,
	input 		 run,
	input [15:0] din,
	output 		 done
);
	wire [15:0] buswires;
	wire		ain, gin, sub;
	wire [7:0]  rin;
	wire [2:0]  rout;
	wire 		din_en, gout, ir_en, clear;
	wire [1:0]  state;
	wire [8:0]  ir_out;
	wire [15:0] aluout;
	wire [15:0] r0_out, r1_out, r2_out, r3_out, r4_out, r5_out, r6_out, r7_out;
	
	control_unit_cpu cu_unit (
	.run(run), .resetn(resetn), .ir(ir_out), .state(state),
	.ain(ain), .gin(gin), .sub(sub), .rin(rin), .rout(rout),
	.din_en(din_en), .gout(gout), .ir_en(ir_en), .clear(clear), .done(done)
	);
	
	multiplexer_cpu mux_unit (
	.din(din), .aluout(aluout), .din_en(din_en), .gout(gout),
	.rout(rout), .buswires(buswires),
	.r0_out(r0_out), .r1_out(r1_out), .r2_out(r2_out), .r3_out(r3_out),
	.r4_out(r4_out), .r5_out(r5_out), .r6_out(r6_out), .r7_out(r7_out)
	);
	
	alu_cpu alu_unit (
	.clk(clk), .resetn(resetn), .buswires(buswires), .ain(ain),
	.gin(gin), .sub(sub), .aluout(aluout)
	);
	
	counter_2bit_cpu counter_unit (
	.clk(clk), .resetn(resetn), .clear(clear), .state(state)
	);
	
	register_file_cpu rf_unit (
	.clk(clk), .resetn(resetn), .rin(rin), .buswires(buswires),
	.r0_out(r0_out), .r1_out(r1_out), .r2_out(r2_out), .r3_out(r3_out),
	.r4_out(r4_out), .r5_out(r5_out), .r6_out(r6_out), .r7_out(r7_out)
	);
	
	ir_cpu ir_unit (
	.clk(clk), .resetn(resetn), .ir_en(ir_en), .buswires(buswires), .ir(ir_out)
	);
endmodule