// Copyright

module tb_top();

reg clk;
reg reset;
wire [11:0] dac_out;
reg rxd;
reg txd;

//clk   _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
//dplse _____________________________/-\_____________________________/-\
//rdadr x0                             x1                              x 2

reg [11:0] test_rom [0:2047];
integer idx = 0;

initial begin
$readmemh("tb/sine.mem", test_rom);
end

top u_top (
	.clk(clk),
	.reset(reset),
	.rxd(rxd),
	.txd(txd),
	.dac_out(dac_out)
);

// Clock generator
always begin
	#5 clk = 1;
	#5 clk = 0;
end

always @(posedge clk) begin
//$display("test_output = %b", dac_out);
end

initial begin
reset = 1;
#15;
reset = 0;
for (idx = 0; idx < 2048; idx = idx + 1) begin
	wait (dac_out == test_rom[idx]) #1;
	$display("dac_out = %h", dac_out);
end
$display("SUCCESS");
end

endmodule
