module top_module(
	input clk,wr_en,rst,rdy_clr,
	input[7:0] data_in,
	output rdy,busy,
	output [7:0] data_out
);
wire rx_clk_en,tx_clk_en,tx_temp;
baud_rate_gen bgen(.clk_b(clk),.rst_b(rst),.enb_tx(tx_clk_en),.enb_rx(rx_clk_en));
transmitter trans(.clk_t(clk),.rst_t(rst),.wr_en(wr_en),.enb(tx_clk_en),.data_t(data_in),.tx(tx_temp),.tx_busy(busy));
receiver rec(.clk_r(clk),.rst_r(rst),.rdy_clr(rdy_clr),.rx(tx_temp),.clk_en(rx_clk_en),.rdy(rdy),.data_out(data_out));
endmodule
