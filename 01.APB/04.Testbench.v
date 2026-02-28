module tb_Apb;
  
  parameter Data=32;
  parameter Addr=32;
  
  reg pclk;
  reg presetn;
  reg trans;
  reg read_write;
  reg [Addr-1:0] addr_in;
  reg [Data-1:0] data_in;
  
  wire [Data-1:0] pr_data;
  
  Top #(.Data(Data),.Addr(Addr)) dut(
    .pclk(pclk),
    .presetn(presetn),
    .trans(trans),
    .read_write(read_write),
    .addr_in(addr_in),
    .data_in(data_in),
    .pr_data(pr_data)
  );
  
  
  initial pclk = 0;
  always #5 pclk = ~pclk;
  initial begin
    $dumpfile("OP.vcd");
    $dumpvars;
    
    
    // Reset
    presetn = 0;
    trans = 0;
    read_write = 0;
    addr_in = 0;
    data_in = 0;
    #25 presetn = 1;
    
    
    // Write
    apb_write(8'hAA, 32'hBBBB);
    apb_write(8'hAB, 32'hCCCC);
    apb_write(8'hAC, 32'h1111);
    apb_write(8'hAD, 32'h2222);
    apb_write(8'hAE, 32'h3333);
    apb_write(8'hAF, 32'h4444);
    
    // Read
    apb_read(8'hAA);
    apb_read(8'hAB);
    apb_read(8'hAC);
    apb_read(8'hAD);
    apb_read(8'hAE);
    apb_read(8'hAF);
    #30 $finish;
    end

    // APB write request
  task apb_write(input [Addr-1:0] addr, input [Data-1:0] data);
    begin
        @(posedge pclk);
        addr_in=addr;
        data_in=data;
        read_write=1;
        trans=1;

        @(posedge pclk);
        trans=0; 
      repeat(3) @(posedge pclk);
      $display("WRITE FUNC Complated");
      $display("---WRITE--- Addr=%0h Data=%0h",Addr,Data);
    end
    endtask

  
  
    // APB read requeust
  task apb_read(input [Addr-1:0] addr);
    begin
    @(posedge pclk);
    addr_in = addr;
    read_write = 0;
    trans = 1;

    @(posedge pclk);
    trans = 0;

    repeat(3) @(posedge pclk);

    $display("READ FUNC Completed");
    $display("---READ---  Addr=%0h Data=%0h", addr, pr_data);
    end
  endtask
endmodule
