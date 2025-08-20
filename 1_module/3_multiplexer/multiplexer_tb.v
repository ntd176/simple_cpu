`timescale 1ns/1ns

module multiplexer_tb; 

	// input data
	reg [15:0] din_tb;
    reg [15:0] aluout_tb;
	reg [15:0] r0_tb, r1_tb, r2_tb, r3_tb, r4_tb, r5_tb, r6_tb, r7_tb;
	
	// input control
	reg din_en_tb;
	reg gout_tb;
	reg [2:0] rout_tb;
	
	// output data
    wire [15:0] buswires_tb; 

    multiplexer dut (
		.din(din_tb), .aluout(aluout_tb),
		.r0(r0_tb), .r1(r1_tb), .r2(r2_tb), .r3(r3_tb),
		.r4(r4_tb), .r5(r5_tb), .r6(r6_tb), .r7(r7_tb),
		.din_en(din_en_tb), .gout(gout_tb), .rout(rout_tb),
		.buswires(buswires_tb)
	);

	integer i;

	initial begin
		din_tb 		= 16'hAAAA;
		aluout_tb 	= 16'hBBBB;
		r0_tb 		= 16'h0000;
		r1_tb 		= 16'h1111;
		r2_tb 		= 16'h2222;
		r3_tb 		= 16'h3333;
		r4_tb 		= 16'h4444;
		r5_tb 		= 16'h5555;
		r6_tb 		= 16'h6666;
		r7_tb 		= 16'h7777;
		
		
		// 01 test din_en
		#10; // expect result buswires_tb = AAAA
		din_en_tb = 1; // uu tien 1
		gout_tb = 1; // uu tien 2
		rout_tb  = 3'b000; // uu tien 3
		
		// 02 test gout
		#30; // expect result buswires_tb = BBBB
		din_en_tb = 0;
		gout_tb = 1; // uu tien 1
		rout_tb = 3'b101; // uu tien 2
		
		// 03 test rout
		#20; // expect result buswires_tb = 0000, 1111,..., 7777 
		din_en_tb = 0;
		gout_tb = 0;
		for (i=0; i<8; i=i+1) begin
			rout_tb = i;
			#10;
		end
		$finish;
	end

endmodule