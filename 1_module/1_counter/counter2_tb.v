`timescale 1ns/1ns

module counter2_tb; 

	reg clock_tb;
    reg clear_tb;   
    wire [1:0] state_tb; 

    counter2 dut (
		.clock(clock_tb),
		.clear(clear_tb),
		.state(state_tb)
	);

// CK clock 10ns (tan so 100 MHz)
	initial begin
		clock_tb = 0;
		forever #10 clock_tb = ~clock_tb; // sau 10ns clock dao trang thai
	end
	
	initial begin
		//01 test reset
		clear_tb = 1'b1;
		#15; 
		
		//02 test bo dem
		clear_tb = 1'b0;
		#100;
		
		//03 test reset trong luc dem
		clear_tb = 1'b1;
		#20;
		clear_tb = 1'b0;
		#40;
		
		$finish;
	end

endmodule