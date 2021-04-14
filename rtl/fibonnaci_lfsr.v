
module fibonnaci_lfsr (
input wire clk,
input wire reset,
output reg [15:0] init_data
);
// LFSR for test purposes, will be replaced by data from host.
always @(posedge clk) begin
	init_data <= {init_data[OUTPUT_WIDTH-2:0], 1'b0};
	init_data[0] <= init_data[15] ^ init_data[13] ^ init_data[12] ^ init_data[10]; // Fibonnaci LFSR as per wikipedia
	if (reset) begin
		init_data <= {OUTPUT_WIDTH{1'b0}};
		init_data[4] <= 1'b1; // Requirement of LFSR is to never be zero
	end
end

endmodule
