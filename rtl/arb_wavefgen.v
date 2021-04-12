// Copyright goes here ;)
// sinegen.v Sine wave generator

module arb_wavegen #(
parameter OUTPUT_WIDTH = 16
)(
input wire clk,
input wire reset,
input wire enable_pulse, // Acts as a clock divider
input wire [11:0] step, // Acts as a clock multiplier
input wire [11:0] range,
input wire [11:0] wr_addr,
input wire [OUTPUT_WIDTH-1:0] wr_data,
input wire wr_enable,
output wire [OUTPUT_WIDTH-1:0] wave_out
);

reg [15:0] wave_ram [0:2047];
reg [11:0] rd_addr;
reg [15:0] out_value;

assign wave_out = out_value;

// Pseudo-dual port RAM (as in ice40)
// TODO: Implement range checking
always @(posedge clk) begin
	if (wr_enable) begin
		wave_ram[wr_addr] <= wr_data;
	end
	if (enable_pulse) begin
		rd_addr <= rd_addr + step;
		out_value <= wave_ram[rd_addr];
	end
	if (reset) begin
		rd_addr <= 12'b0;
		out_value <= {OUTPUT_WIDTH-1{1'b0}};
	end
end

endmodule


