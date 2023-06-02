// MODULE : tb - start //
`include "interface.sv"
`include "environment.sv"

module tb;
  fifo_if fif();
  
  fifo dut (fif.clock, fif.rd, fif.wr,fif.full, fif.empty, fif.data_in, fif.data_out, fif.rst);
  
   initial begin
     fif.clock <= 0;
   end
    
   always #5 fif.clock <= ~fif.clock;

   environment env;
  
   initial begin
     env = new(fif); // this "fif" is being shared by env and from it its shared by drv.fif and mon.fif
     env.gen.count = 10;
     env.run();
   end
  
   initial begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
  
endmodule
// MODULE : tb - end   //