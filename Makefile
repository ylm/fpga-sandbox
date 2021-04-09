test: tb/functional_test.v rtl/top.v rtl/clock_divider.v rtl/sinegen.v rtl/pdm
	iverilog tb/functional_test.v rtl/top.v rtl/clock_divider.v rtl/sinegen.v rtl/pdm
