uart: tb/uart_tb.v rtl/uart.v
	iverilog tb/uart_tb.v rtl/uart.v
test: tb/functional_test.v rtl/top.v rtl/clock_divider.v rtl/sinegen.v rtl/pdm.v rtl/arb_wavefgen.v rtl/comm_interface.v
	iverilog tb/functional_test.v rtl/top.v rtl/clock_divider.v rtl/sinegen.v rtl/pdm.v rtl/arb_wavefgen.v rtl/comm_interface.v
