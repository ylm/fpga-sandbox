// Copyright goes here ;)
// pdm.v Pulse Density Modulator

module pdm #(
parameter OUTPUT_WIDTH = 1,
parameter INPUT_WIDTH = 8
)(
input wire clk,
input wire reset,
input wire [INPUT_WIDTH-1:0] sample,
output wire [OUTPUT_WIDTH-1:0] dac_out
);

reg [INPUT_WIDTH:0] accumulator;
reg [OUTPUT_WIDTH-1:0] out_value;

assign dac_out = out_value;

always @(posedge clk) begin
	accumulator <= {1'b0, accumulator[INPUT_WIDTH-1:0]} + sample[INPUT_WIDTH-OUTPUT_WIDTH-1:0];
	out_value <= sample[INPUT_WIDTH-1:INPUT_WIDTH-OUTPUT_WIDTH] + accumulator[INPUT_WIDTH];
	if (reset) begin
		accumulator <= {INPUT_WIDTH{1'b0}};
		out_value <= {OUTPUT_WIDTH-1{1'b0}};
	end
end

endmodule

