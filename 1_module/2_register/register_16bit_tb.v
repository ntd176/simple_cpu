`timescale 1ns/1ns

module register_16bit_tb; 

	reg clock_tb;
    reg rin_en_tb;
	reg [15:0] buswires_tb;
    wire [15:0] rout_tb; 

    register_16bit dut (
		.clock(clock_tb),
		.rin_en(rin_en_tb),
		.buswires(buswires_tb),
		.rout(rout_tb)
	);

// CK clock 20ns (tan so 50 MHz)
	initial begin
		clock_tb = 0;
		forever #10 clock_tb = ~clock_tb;
	end
	
	initial begin
		// 01 gia tri ban dau
		rin_en_tb = 0;
		buswires_tb = 16'h0000;
		#10; 
		
		// 02 load data khi enable = 1
		rin_en_tb = 1;
		buswires_tb = 16'hAAAA;
		#60;
		buswires_tb = 16'hBBBB;
		#60;
		
		// 03 load data khi enable = 0
		rin_en_tb = 0;
		buswires_tb = 16'hCCCC;
		#40;
		
		// 04 continue enable = 1
		rin_en_tb = 1;
		#20;
		$finish;
	end

endmodule