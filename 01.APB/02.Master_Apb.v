module master #(parameter Data=32,Addr=32)(
  input wire pclk,
  input wire presetn,
  input wire p_ready,
  input wire[Data-1:0] pr_data,
  
  
  input wire trans,
  input wire read_write,
  input wire[Addr-1:0] addr_in,
  input wire [Data-1:0] data_in,
  
  output reg[Addr-1:0] paddr,
  output reg pwrite,
  output reg[Data-1:0] pwdata,
  output reg p_sel,
  output reg p_enable
);
  
  parameter Idle=2'b00,Setup=2'b01,Access=2'b10;
  
  reg[1:0] state,ns;
  
  always @(*) begin
    case(state)
      Idle:ns=(trans)?Setup:Idle;
      Setup:ns=Access;
      Access:ns=(p_ready&&!trans)?Idle:Access;
      default:ns=Idle;
    endcase
  end
  
  always @(posedge pclk or negedge presetn)begin
    if(!presetn)
      state<=Idle;
    else
      state<=ns;
  end
  
  always @(*)begin
    case(state)
      
      Idle:begin
        paddr=0;
        pwrite=0;
        pwdata=0;
        p_sel=0;
        p_enable=0;
      end
      
      Setup: begin
        paddr=addr_in;
        pwrite=read_write;
        pwdata=data_in;
        p_sel=1;
        p_enable=0;
      end
      
      Access: begin
        paddr=addr_in;
        pwrite=read_write;
        pwdata=data_in;
        p_sel=1;
        p_enable=1;
      end
      
    endcase
  end
endmodule
