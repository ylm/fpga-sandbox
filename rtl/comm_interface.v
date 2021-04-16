// Copyright
//

module comm_interface #(
parameter OUTPUT_WIDTH = 16
) (
input wire clk,
input wire reset,
input wire rxd,
output wire txd,
output reg wr_enable,
output reg [11:0] wr_addr,
output wire [OUTPUT_WIDTH-1:0] wr_data,
output wire [11:0] step,
output wire [11:0] range
);

// TODO: Update configuration registers in a single step (instead of current
// shift register fashion)
// TODO: Maybe start/stop messages
assign step = 12'd1;
assign range = 12'hfff;

reg init_done;
reg [11:0] init_addr;
reg [OUTPUT_WIDTH-1:0] init_data;
reg [7:0] length;
reg [7:0] rcv_bytes_m1;	// Bytes rceived after length minus 1
						// Effectively, the number of data bytes received
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
// msgTypes:
// 0x00 = RESERVED
// 0x01 = SYS RESETS
// 0x02 = step value
// 0x03 = range value
// 0x04 = base write address
// 0x05 = write RAM data
always @(posedge clk) begin
sys_reset <= 1'b0;
wr_enable <= 1'b0;
if (rx_intr) begin
	if (|length) begin
		if (rcv_bytes_m1 == 8'hff) begin
			msgType <= rx_data;
		end else begin
			case (msgType) // See Communication Protocol above
				8'h00: ; // RESERVED
				8'h01:	sys_reset <= rx_data[0];
				8'h02:	step <= {step[3:0], rx_data};
				8'h03:	range <= {range[3:0], rx_data};
				8'h04:	base_addr <= {base_addr[3:0], rx_data};
				8'h05:	begin
							sample_addr <= base_addr + rcv_bytes_m1[7:1]; // Address increments every other bytes
							sample_data <= {sample_data, rx_data}; // Sample data is 16bits
							wr_enable <= rcv_bytes_m1[0]; // Toggles to one every other byte received
						end
				default: ;
			endcase
		end
		rcv_bytes_m1 <= rcv_bytes_m1 + 8'd1;
		length <= length - 8'd1;
	end else begin
		length <= rx_data;
	end
end
if (reset) begin
	rcv_bytes_m1 <= 8'hff;
	length <= 8'd0;
	msgType <= 8'd0;
end
end

endmodule
