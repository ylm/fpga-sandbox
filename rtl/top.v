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

clock_divider #(
	.DIVIDER_LOG2(4) // Triggers every 16 cycles
) u_clock_divider (
	.clk(clk),
	.reset(reset),
	.enable_pulse(step_pulse)
);

`ifdef USE_SINE
comm_interface u_comm_interface (
	.clk(clk),
	.reset(reset),
	.rxd(rxd),
	.txd(txd),
	.we_enable(wr_enable),
	.wr_addr(wr_addr),
	.wr_data(wr_data),
	.step(step),
	.range(range)
);

arb_wavegen #(
) u_arb_wavegen (
	.clk(clk),
	.reset(reset),
	.enable_pulse(step_pulse),
	.step(step),
	.range(range),
	.wr_enable(wr_enable),
	.wr_addr(wr_addr),
	.wr_data(wr_data),
	.wave_out(sample)
);

`else
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
