// MONITOR - start //
                   
class monitor;
  
  virtual fifo_if fif;
  
  mailbox #(transaction) mbx;
  
  transaction tr;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    
    tr = new();
    
    forever begin
      
      repeat(2) @(posedge fif.clock);
      // not using <= as it can't be used to update the data member of a class
      tr.wr = fif.wr;
      tr.rd = fif.rd;
      tr.data_in = fif.data_in;
      tr.data_out = fif.data_out;
      tr.full = fif.full;
      tr.empty = fif.empty;
      
      mbx.put(tr);  // this mbx will be shared by Scoreboard
      tr.display("MON");
      
    end
    
  endtask
  
endclass

// MONITOR - end   //