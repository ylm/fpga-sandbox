// Copyright goes here ;)
// sinegen.v Sine wave generator

module sinegen (
input wire clk,
input wire reset,
input wire clk_en,
output wire [15:0] sine_out
);

reg [15:0] sine_rom [0:2047];
reg [11:0] rd_addr;
reg [15:0] out_value;

assign sine_out = out_value;

// Initializing our ROM
initial begin
$readmemh("rtl/sine.mem", sine_rom);
end

// Iterating through the wave's ROM
always @(posedge clk) begin
	if (clk_en == 1'b1) begin
		rd_addr <= rd_addr + 1'b1;
		out_value <= sine_rom[rd_addr];
	end
	if (reset) begin
		rd_addr <= 12'b0;
		out_value <= {16-1{1'b0}};
	end
end

endmodule


