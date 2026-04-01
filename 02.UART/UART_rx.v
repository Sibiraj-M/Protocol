module receiver(
	input clk_r,rst_r,rdy_clr,rx,clk_en,
	output reg rdy,
	output reg [7:0] data_out
);
reg [1:0] state=start;
reg [3:0] count=0;
reg [3:0] index=0;
reg [7:0] data_temp=8'b0;
parameter start=2'b00,data_o=2'b01,stop=2'b10;
always @(posedge clk_r) begin
	if(rst_r) begin
		rdy=0;
		data_out=0;
	end
end	
always @(posedge clk_r) begin
	if(rdy_clr) rdy<=0;
	if(clk_en) begin
		case(state) 
			start: begin
				if(!rx || count!=0) count<=count+4'b1;
				if(count==15) begin
					state<=data_o;
					index<=0;
					count<=0;
					data_temp<=0;
				end
			end
			data_o: begin
				count<=count+4'b1;
				if(count==4'h8) begin
					data_temp[index]<=rx;
					index<=index+4'b1;
				end
				if(index==8 && count==15) state<=stop;
			end
			stop: begin
				if(count==15) begin
					state<=start;
					data_out<=data_temp;
					rdy<=1'b1;
					count<=0;
				end
				else count<=count+4'b1;
			end
			default: state<=start;
		endcase
	end
end
endmodule
