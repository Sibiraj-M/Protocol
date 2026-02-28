`include "master_apb.v"
`include "slave_apb.v"


module Top #(parameter Data = 32, Addr = 32)(
  input wire pclk,
  input wire presetn,
  input wire trans,
  input wire read_write,
  input wire [Addr-1:0]addr_in,
  input wire [Data-1:0]data_in,
  
  
  output wire [Data-1:0] pr_data
);

  wire p_sel;
  wire p_enable;
  wire p_ready;
  wire pwrite;
  wire [Data-1:0] pwdata;
  wire [Addr-1:0] paddr;
  

    // Master
  master #(.Data(Data), .Addr(Addr)) master_in (
    .pclk   (pclk),
    .presetn(presetn),
    .p_ready (p_ready),
    .pr_data (pr_data),

    .trans(trans),
    .read_write(read_write),
    .addr_in(addr_in),
    .data_in(data_in),
    
    .paddr(paddr),
    .pwrite(pwrite),
    .pwdata (pwdata),
    .p_sel(p_sel),
    .p_enable(p_enable)
    );

    // Slave
  slave #(.Data(Data), .Addr(Addr)) slave_in (
    .pclk(pclk),
    .presetn(presetn),
    .paddr(paddr),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .p_sel(p_sel),
    .p_enable(p_enable),
    .pr_data (pr_data),
    .p_ready (p_ready)
    );
endmodule
