// Kyle Ray
// CPE_526 Intro to VLSI
// HW4
// Due: April 14, 2017

// Interface for the Tape Player
interface tape_if(input bit clk);
	logic PL, RE, FF, ST, M,
	      P, F, R, RESET, CLK;
	bit[15:0] COUNT;

	clocking cb @(posedge clk);
		output PL, RE, FF, ST, M, RESET, CLK;
		input P, F, R, COUNT;
	endclocking

	modport TEST(clocking cb);
endinterface