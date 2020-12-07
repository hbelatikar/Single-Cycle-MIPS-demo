module clk_div (
	input clk,
	input rst,
	output reg clk_out
	);
	
	localparam [31:0] constNos = 2500000;
	
	reg [31:0] counter;
	
	always @(posedge clk or posedge rst)
	begin
		if(rst)
			counter <= 32'b0;
		else if(counter == constNos-1)
			counter <= 32'b0;
		else
			counter <= counter + 1'b1;
	end
	
	always @(posedge clk or posedge rst)
	begin
		if(rst)
			clk_out <= 1'b0;
		else if(counter == constNos-1)
			clk_out <= ~clk_out;
		else
			clk_out <= clk_out;
	end
	
endmodule //End clkDivider