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

`ifndef USE_SINE
wire wr_enable; // Assert high when writting to the arb_wavegen
wire [11:0] wr_addr; // Address at which sample gets written (sample width aligned)
wire [15:0] wr_data; // Sample data value
wire [11:0] step; // Step increment to the wave generator
wire [11:0] range; // Highest address with sample content

comm_interface u_comm_interface (
	.clk(clk),
	.reset(reset),
	.rxd(rxd),
	.txd(txd),
	.wr_enable(wr_enable),
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
