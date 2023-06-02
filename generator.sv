// GENERATOR CLASS - start //

class generator;
  
  transaction tr;
  mailbox #(transaction) mbx;
  
  int count = 0;
  
  event next;  // indicates when to send next transaction
  event done;  // indicates that requested number of transactions have been completed
  
  // constructor for generator class' object
  function new (mailbox #(transaction) mbx);
    
    this.mbx = mbx; //Generator's mbx = Envionment's gdmbx
    tr = new();
    
  endfunction
  
  // MAIN TASK
  task run();
    
    repeat(count) begin
      
      assert (tr.randomize()) else $error("Randomization Failed!"); // goes inside the else block only when randomization fails (means tr.randomize() returns 0)
      mbx.put(tr.copy);
      tr.display("GENERATOR"); // displays the value of Generator's Transaction class object
      @(next);
      
    end
    ->done;
    
  endtask
  
endclass

// GENERATOR CLASS - end   //