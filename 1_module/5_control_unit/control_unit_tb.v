`timescale 1ns/1ns

module control_unit_tb;
	
	// --- input ---
	reg clock_tb;
	reg run_tb;
	reg resetn_tb;
	reg [8:0] ir_tb;
	reg [1:0] state_tb;
	
	// --- output ---
	// -- alu --
	wire ain_tb;
	wire gin_tb;
	wire sub_tb;
	
	// -- register, mux --
	wire [7:0] rin_tb;
	wire [2:0] rout_tb;
	wire din_en_tb;
	wire gout_tb;
	wire dout_en_tb;
	
	// -- general --
	wire ir_en_tb;
	wire done_tb;
	
	control_unit dut (
		.run(run_tb), .resetn(resetn_tb), .ir(ir_tb), .state(state_tb),
		.ain(ain_tb), .gin(gin_tb), .sub(sub_tb), .rin(rin_tb),
		.rout(rout_tb), .din_en(din_en_tb), .gout(gout_tb),
		.dout_en(dout_en_tb), .ir_en(ir_en_tb), .done(done_tb)
	);
	
	initial begin
		clock_tb = 0;
		forever #10 clock_tb = ~clock_tb;
	end
	
	// -- state simulation --
	// reset ve 0 neu 'done' duoc kich hoat
	always @(posedge clock_tb or negedge resetn_tb) begin
		if (!resetn_tb) begin
			state_tb <= 2'b00;
		end else if (done_tb) begin
			state_tb <= 2'b00;
		end else begin
			state_tb <= state_tb + 1'b1;
		end
	end
	
	initial begin
		// init value
		run_tb = 1;
		ir_tb = 9'b0;
		resetn_tb = 1;
		#5;
		
		// 01 test resetn
		resetn_tb = 0; // reset active low
		#20;
		resetn_tb = 1;
		#20;
		
		// 02 test ADD r1, r2 (9'b010_001_010) in 4 freq
		@(posedge clock_tb);
		ir_tb = 9'b010_001_010;
		#80;
		
		// 03 test MV r3, r4 (9'b000_011_100) in 2 freq
		@(posedge clock_tb);
		ir_tb = 9'b000_011_100;
		#40;
		
		// 04 test MVI r5, din (9'b001_101_xxx) in 2 freq
		@(posedge clock_tb);
		ir_tb = 9'b001_101_000;
		#40;
		
		// 05 test MVO r6 (9'b100_110_xxx) in 2 freq
		@(posedge clock_tb);
		ir_tb = 9'b100_110_000;
		#40;
		
		// 06 test SUB r7, r0 (9'b011_111_000) in 4 freq
		@(posedge clock_tb);
		ir_tb = 9'b011_111_000;
		#80;
		$finish;
	end
	
endmodule