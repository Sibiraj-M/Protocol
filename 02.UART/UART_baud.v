module baud_rate_gen(
	input clk_b,rst_b,
	output reg enb_tx,enb_rx
);
parameter baud=9600;
parameter frq=100000000;
parameter clk_div_t=frq/baud;
parameter clk_div_r=frq/(16*baud);
reg [15:0] count_t;
reg [15:0] count_r;

always @(posedge clk_b) begin
	if(rst_b) begin
		count_t<=0;
		enb_tx<=0;
		enb_rx<=0;
	end
	else if(count_t==clk_div_t-1) begin
		enb_tx<=1;
		count_t<=0;
	end
	else begin
		count_t<=count_t+1;
		enb_tx<=0;
	end

end
always @(posedge clk_b) begin
	if(rst_b) count_r<=0;
	else if(count_r==clk_div_r-1) begin
		count_r<=0;
		enb_rx<=1;
	end
	else begin
		count_r<=count_r+1;
		enb_rx<=0;
	end
end
endmodule
