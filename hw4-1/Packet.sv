package mine;
	class Packet;
	  
	  // Distribution Weights
	  const int WEIGHT_1 = 10;
	  const int WEIGHT_2 = 20;
	  const int WEIGHT_3 = 15;
	  
		// The random variables
		rand int M_t, STOP_t;
		
		// Limit the values for M and STOP
		constraint  c {M_t <= 50; M_t >= 20;
		               STOP_t <= 50; STOP_t >= 20;}
		               
		// Create the random distributions with the following
		/* Values    Weight
		 * 20:25     10 each
		 * 26:39     20 each
		 * 40:50     15 each */
		 
		 constraint M_ranges {M_t dist {[20:25] := 10,
                                    [26:39] := 20,
                                    [40:50] := 15};}
      
     constraint STOP_ranges {STOP_t dist {[20:25] := 10,
                                          [26:39] := 20,
                                          [40:50] := 15};}
	endclass : Packet
endpackage : mine