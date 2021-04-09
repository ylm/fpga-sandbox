// Copyright goes here ;)
// Top.v just top level for proper pinout.

module top (
input wire clk,
input wire reset,
input wire rxd,
input wire txd,
output wire [11:0] dac_out
);

// Clock enable for the wave generator
wire step_pulse;

// Sample coming out of wave generator into our pdm
wire [15:0] sample;

`ifdef USE_COMM
comm_interface u_comm_interface (
	.rxd(rxd),
	.txd(txd),
	.wr_addr(wr_addr),
	.wr_data(wr_data)
);

`else
clock_divider #(
	.DIVIDER_LOG2(4) // Triggers every 16 cycles
) u_clock_divider (
	.clk(clk),
	.reset(reset),
	.enable_pulse(step_pulse)
);

sinegen u_sinegen(
	.clk(clk),
	.reset(reset),
	.clk_en(step_pulse),
	.sine_out(sample)
);

`endif

// DAC driver
pdm #(
	.INPUT_WIDTH(16),
	.OUTPUT_WIDTH(12)
) u_pdm(
	.clk(clk),
	.reset(reset),
	.sample(sample),
	.dac_out(dac_out)
);

endmodule
