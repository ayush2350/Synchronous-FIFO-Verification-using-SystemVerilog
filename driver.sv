// DRIVER - start //

class driver;
  
  virtual fifo_if fif; // this interface comes from env and is linked directly to the DUT signals
  mailbox #(transaction) mbx;
  
  transaction datac; //data container
  
  event next;
  
  function new(mailbox #(transaction) mbx);
  	
    this.mbx = mbx; // assigning mailbox item rcvd from generator to driver's mailbox
    
  endfunction
  
  // This task will put the DUT in reset when called
  task reset();
    
  	fif.rst     <= 1'b1;
   
    $display ("DRV : DUT Reset Started");
    
    fif.rd      <= 1'b0;
    fif.rd      <= 1'b0;
    fif.data_in <= 0;
    
    repeat(5) @(posedge fif.clock) begin
    	// Empty loop so that fif.rst == 1 for 5 clock cycles  
    end
    
    fif.rst <= 1'b0; // to drive reset low
    
    $display ("DRV : DUT Reset Done");
    
  endtask
  
  task run();
    
    forever begin
      
      mbx.get(datac); // getting the stimulus from generator's mbx
      
      datac.display("DRV");
      // next 3 lines are responsible for providing stimulus to the DUT
      fif.rd       <= datac.rd;    
      fif.wr       <= datac.wr;
      fif.data_in  <= datac.data_in;
      
      repeat(2) @(posedge fif.clock);
       
    end
    
  endtask
  
endclass

// DRIVER - end //