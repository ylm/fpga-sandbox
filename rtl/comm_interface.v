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
reg [7:0] length;
reg [7:0] rcv_bytes;
reg [7:0] msgType;


assign wr_enable = ~init_done;
assign wr_addr = init_addr;
assign wr_data = init_data;

uart #(
	.INPUT_FREQ(INPUT_FREQ),
	.BAUD_RATE(BAUD_RATE)
) u_uart (
	.clk(clk),
	.reset(reset),
	.rxd(rxd),
	.txd(txd),
	.received_data_intr(rx_intr),
	.rx_data(rx_data),
	.tx_data(tx_data),
	.busy(busy),
	.send_data(send_data)
);

// Communication protocol
always @(posedge clk) begin
if (rx_intr) begin
	if (|length) begin
		if (rcv_bytes == 8'd0) begin
			msgType <= rx_data;
		end
		rcv_bytes <= rcv_bytes + 8'd1;
		length <= length - 8'd1;
	end else begin
		length <= rx_data;
	end
end
if (reset) begin
	rcv_bytes <= 8'd0;
	length <= 8'd0;
	msgType <= 8'd0;
end
end

endmodule
