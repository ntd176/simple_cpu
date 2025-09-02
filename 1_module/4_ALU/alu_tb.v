`timescale 1ns/1ns

module alu_tb; 

	reg clock_tb;
    reg [15:0] buswires_tb;
	
	reg ain_tb;
	reg sub_tb;
	reg gin_tb;
	
	wire [15:0] aluout_tb; 

    alu dut (
		.clock(clock_tb),
		.buswires(buswires_tb),
		.ain(ain_tb),
		.sub(sub_tb),
		.gin(gin_tb),
		.aluout(aluout_tb)
	);

	initial begin
		clock_tb = 0;
		forever #10 clock_tb = ~clock_tb;
	end
	
	initial begin
		// init value
		buswires_tb = 16'd0;
		ain_tb = 1'b0;
		sub_tb = 1'b0;
		gin_tb = 1'b0;
		#20;
		
		// test I
		// CK_1 load in register A
		buswires_tb = 16'd100;
		ain_tb = 1'b1;
		sub_tb = 1'b0; // add
		gin_tb = 1'b0;
		#20;
		
		// CK_2 load in register G
		buswires_tb = 16'd50;
		ain_tb = 1'b0;
		gin_tb = 1'b1;
		#20; // result 16'd150
		
		// 01 off controll
		gin_tb = 1'b0;
		#30;
		
		// test II
		// CK_1 load in register A
		buswires_tb = 16'd200;
		ain_tb = 1'b1;
		sub_tb = 1'b1; // sub
		gin_tb = 1'b0;
		#20;
		
		// CK_2 load in register G
		buswires_tb = 16'd25;
		ain_tb = 1'b0;
		gin_tb = 1'b1;
		#20; // result 16'd175
		
		// 02 off controll
		gin_tb = 1'b0;
		#30;
		
		$finish;
	end

endmodule