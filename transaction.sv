// TRANSACTION CLASS - start //

class transaction;
  
  /*
  	Global DUT signals like clk, rst need not to be included
  */
  
  // DUT input signals
  rand bit wr;
  rand bit rd;
  rand bit [7:0] data_in;
  
  //DUT output signals
  bit empty, full;
  bit [7:0] data_out;
  
  constraint wr_rd {
    
   	rd != wr; 				  // for, wr & rd requests never occur simultaneosuly 
    
    wr dist {0 := 1, 1 := 5}; // WEIGHT of wr = 0 is 1 || wr = 1 is 1
    rd dist {0 := 1, 1 := 1}; // WEIGHT of rd = 0 is 1 || rd = 1 is 1
    
    /*
    
    We can also write the above statements as:
    
    wr dist {0 :/ 50 , 1:/ 50};
    rd dist {0 :/ 50 , 1:/ 50};
    
    */
    
  }
  
  constraint data_con {
    
    data_in > 1;
    data_in < 100;
    
  }
  
  function void display (input string tag);
    
    $display("[%0s] : WR = %0b  RD = %0b  DATA_WR = %0d  DATA_RD = %0d  FULL = %0b  EMPTY = %0b  @time = %0t", tag, wr, rd, data_in, data_out, full, empty, $time);
    
  endfunction
  
  
  function transaction copy();  // this will be used to send stimulus from gen to driver
    copy = new();
    copy.rd = this.rd;
    copy.wr = this.wr;
    copy.data_in = this.data_in;
    copy.data_out= this.data_out;
    copy.full = this.full;
    copy.empty = this.empty;
  endfunction
  
endclass

// TRANSACTION CLASS - end //