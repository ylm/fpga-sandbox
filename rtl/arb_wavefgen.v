// Copyright goes here ;)
// sinegen.v Sine wave generator

module arb_wavegen #(
parameter OUTPUT_WIDTH = 16
)(
input wire clk,
input wire reset,
input wire [11:0] step,
input wire [11:0] range,
output wire [OUTPUT_WIDTH-1:0] sine_out
);

reg [15:0] sine_rom [0:2047];
reg [11:0] rd_addr;
reg [11:0] rd_addrm;
reg [15:0] out_value;

assign dac_out = out_value;

always @(posedge clk) begin
	rd_addr <= rd_addr + step;
	rd_addrm <= rd_addr + step - range;
	out_value <= sine_rom[rd_addr];
	if (reset) begin
		rd_addr <= 12'b0;
		out_value <= {OUTPUT_WIDTH-1{1'b0}};
	end
end

endmodule


