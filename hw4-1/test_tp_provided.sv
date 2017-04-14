import mine::*;
module test(tape_if.TEST tapeif);
  Packet p;
  integer in, status;
  logic reset, ff, re, pl, st;
  initial begin
    p = new();
    in = $fopen("sv_tape_player.txt", "r");
  end
  initial begin
    repeat (10) @ (tapeif.cb);
    repeat (200)
    begin
      `SV_RAND_CHECK(p.randomize());
      while (!$feof(in))
      begin
        status = $fscanf(in, "%b %b %b %b %b\n", 
                         reset, pl, ff, re, st);
        tapeif.cb.RESET <= reset;
        tapeif.cb.FF <= ff;
        tapeif.cb.RE <= re;
        tapeif.cb.PL <= pl;
        tapeif.cb.ST <= st;
        
        
        // Problem Statement
        // 1.) Randomize time it takes M = '0' when state needs it
        //     States requiring input M:
        //       PP_REW
        //       PP_FFOR
        //
        // 2.) Randomize the time it takes STOP = '1'
        // 3.) When STOP = '1' and M = '0' are read from the file,
        //     delay the application the correct number of cycles.
        //        NOTE: M is not read from the file
        
        
        // Start My Tests
        
        // 2.) and 3.) If Stop is read from the file and is '1' delay application
        if (tapeif.cb.ST)
          repeat (p.STOP_t) @(tapeif.cb) // Wait random time for stop
        
        // 1.) If we reach these states then randomize the time it takes
        //     M to be set low.
        //     Also note that ST = '1' is a valid branch back to INIT
        @(posedge tapeif.cb.PP_FFOR) or @(posedge tapeif.cb.PP_REW);
        if (not tapeif.cb.ST)
          repeat(p.M_T) @(tapeif.cb); // Wait for M to be set low
                         
        @(tapeif.cb); // Wait one clock cycle
      end // end while
      $rewind(in);
    end // repeat 200
    $finish;
  end // initial
endmodule : test
