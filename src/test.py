import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_counter(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 1, units="us")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 1)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    await ClockCycles(dut.clk, 1000000)
    #assert int(dut.counter_out.value) == 0
