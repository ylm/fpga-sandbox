// Copyright
//

module comm_interface #(
parameter OUTPUT_WIDTH = 16
) (
input wire clk,
input wire reset,
input wire rxd,
output wire txd,
output wire wr_enable,
output wire [11:0] wr_addr,
output wire [OUTPUT_WIDTH-1:0] wr_data,
output wire [11:0] step,
output wire [11:0] range
);

assign step = 12'd1;
assign range = 12'hfff;

reg init_done;
reg [11:0] init_addr;
reg [OUTPUT_WIDTH-1:0] init_data;

assign wr_enable = ~init_done;

// LFSR for test purposes, will be replaced by data from host.
always @(posedge clk) begin
	init_done <= &init_addr;
	if (~init_done) begin
		init_addr <= init_addr + 1'b1;
		init_data <= {init_data[OUTPUT_WIDTH-2:0], 1'b0};
		init_data[0] <= init_data[15] ^ init_data[13] ^ init_data[12] ^ init_data[10]; // Fibonnaci LFSR as per wikipedia
	end
	if (reset) begin
		init_done <= 1'b0;
		init_addr <= 12'd0;
		init_data <= {OUTPUT_WIDTH{1'b0}};
		init_data[0] <= 1'b1; // Requirement of LFSR is to never be zero
	end
end

endmodule
