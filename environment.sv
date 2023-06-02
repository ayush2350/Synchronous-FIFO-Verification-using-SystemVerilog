`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

// ENVIRONMENT - start //

class environment;
  
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  
  mailbox #(transaction) gdmbx; //gen to drv mbx
  mailbox #(transaction) msmbx; //mon to sco mbx
  
  event nextgs; // event next working between scb and generator
  
  virtual fifo_if fif;
  
  function new(virtual fifo_if fif);
    
    gdmbx = new();
    gen   = new(gdmbx);
    drv   = new(gdmbx);
    
    msmbx = new();
    mon   = new(msmbx);
    sco   = new(msmbx);
    
    this.fif = fif;
    drv.fif  = this.fif;
    mon.fif  = this.fif;
    
    gen.next = nextgs;
    sco.next = nextgs;
    
  endfunction
  
  task pre_test();
    drv.reset();
  endtask
  
  task test();
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_any
  endtask
  
  task post_test();
    wait(gen.done.triggered);
    $finish();
  endtask
  
  task run();
    pre_test();
    test();
    post_test();
  endtask
  
endclass

// ENVIRONMENT - end   // 