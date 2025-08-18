`timescale 1ns/1ns

module register_16bit_tb; 

	reg clk_tb;
    reg enable_tb;
	reg [15:0] data_in_tb;
    wire [15:0] data_out_tb; 

    register_16bit dut (
		.clk(clk_tb),
		.enable(enable_tb),
		.data_in(data_in_tb),
		.data_out(data_out_tb)
	);

// CK clock 10ns (tan so 100 MHz)
	initial begin
		clk_tb = 0;
		forever #10 clk_tb = ~clk_tb; // sau 10ns clock dao trang thai
	end
	
	initial begin
		//01 tao gia tri ban dau
		enable_tb = 0;
		data_in_tb = 16'h0000;
		#15; 
		
		//02 load data khi enable = 1
		enable_tb = 1;
		data_in_tb = 16'hAAAA;
		#10;
		data_in_tb = 16'h5555;
		#10;
		
		//03 load data khi enable = 0
		enable_tb = 0;
		data_in_tb = 16'hFFFF;
		#20;
		
		//04 continue enable = 1
		enable_tb = 1;
		#10;
		$finish;
	end

endmodule