module transmitter(
	input clk_t,rst_t,wr_en,enb,
	input [7:0]data_t,
	output reg tx,
	output tx_busy
);
always @(posedge clk_t) begin 
	if(rst_t) tx<=1'b1;
end
parameter idle=2'b00,start=2'b01,dataa=2'b10,stop=2'b11;
reg [7:0] data=8'h0;
reg [2:0] count=3'h0;
reg [1:0] state=idle;

always @(posedge clk_t) begin
	case(state)
		idle:begin
			if(wr_en) begin
				state<=start;
				data<=data_t;
				count<=3'h0;
			end
		end
		start: begin
		       	if(enb) begin
				tx<=1'b0;
				state<=dataa;	
			end
		end
		dataa: begin
			if(enb) begin
				if(count==3'h7) state<=stop;
				else count<=count+3'h1;
				tx<=data_t[count];
			end
		end
		stop: begin
			if(enb) begin
				tx<=1'b1;
				state<=idle;
			end
		end
		default: begin
			tx<=1'b1;
			state<=idle;
		end
	endcase
end
assign tx_busy=(state!=idle);
endmodule
