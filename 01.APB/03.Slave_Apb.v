module slave #(parameter Data=32,Addr=32)(
  input wire pclk,
  input wire presetn,
  input wire[Addr-1:0] paddr,
  input wire pwrite,
  input wire[Data-1:0] pwdata,
  input wire p_sel,
  input wire p_enable,
  
  output reg[Data-1:0] pr_data,
  output reg p_ready
);
  
  reg [Data-1:0] mem[0:255];
  
  always @(posedge pclk or negedge presetn) begin
    
    if(!presetn) begin
      p_ready<=0;
      pr_data<=0;
    end
    else begin
      p_ready <=0;
      if(p_sel && p_enable) begin
        
        p_ready <=1;
        if(pwrite)
          mem[paddr]<=pwdata;
        else
          pr_data<=mem[paddr];
      end else begin
        p_ready<=0;
      end
    end
  end
endmodule
