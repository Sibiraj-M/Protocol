module uart_tb();
	reg clk_tb,rst_tb,wr_en_tb,rdy_clr_tb;
	reg [7:0] data_in;
	wire rdy,busy;
	wire [7:0] data_out;
	top_module dut(.clk(clk_tb),.rst(rst_tb),.wr_en(wr_en_tb),.rdy_clr(rdy_clr_tb),.rdy(rdy),.busy(busy),.data_out(data_out),.data_in(data_in));
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(0,uart_tb);
	end
	initial begin
		{clk_tb,rst_tb,data_in,rdy_clr_tb}=0;
	end
	always #5 clk_tb=~clk_tb;
	task send_byte(input [7:0] din);
		begin
			@(negedge clk_tb);
			data_in=din;
			wr_en_tb=1'b1;
			@(negedge clk_tb)
			wr_en_tb=0;
		end
	endtask
	task clear_rdy;
		begin
			@(negedge clk_tb)
			rdy_clr_tb=1'b1;
			@(negedge clk_tb)
			rdy_clr_tb=1'b0;
		end
	endtask
	initial begin
		@(negedge clk_tb)
		rst_tb=1'b1;
		@(negedge clk_tb)
		rst_tb=1'b0;
		send_byte(8'h41);
		wait(!busy);
		wait(rdy);
		$display("received data is %h",data_out);
		clear_rdy;

		send_byte(8'h55);
		wait(!busy);
		wait(rdy);
		$display("received data is %h",data_out);
		clear_rdy;

		#400 $finish;
	end
	endmodule
