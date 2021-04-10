# RTL Files

* `top.v`: Top level module tying the other modules
* `comm_interface.v`: Communication interface
* `pdm.v`: Pulse density modulator
* `clock_divider.v`: Simple clock divider
* `arb_wavefgen.v`: Arbitrary wavegenerator. Data written by `comm_interface`
* `sinegen.v`: ROM based wave generator. Uses `sine.mem`
* `sine.mem`: Actually a ramp ;)

