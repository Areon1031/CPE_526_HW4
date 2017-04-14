module top;
	bit clk;
	always #5 clk = ~clk;

	// Instantiate the interface
	tape_if tapeif(clk);

	// Map to the DUT
	TAPE_PLAYER u1 (.PL (tapeif.PL),
	                .RE (tapeif.RE),
	                .FF (tapeif.FF),
	                .ST (tapeif.ST),
	                .M  (tapeif.M),
	                .P  (tapeif.P),
	                .F  (tapeif.F),
	                .R  (tapeif.R),
	                .COUNT(tapeif.COUNT),
	                .RESET(tapeif.RESET),
	                .CLK (clk));
  test t1(tapeif);
endmodule : top