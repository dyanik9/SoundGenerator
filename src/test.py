import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_counter(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 100, units="ns")
    cocotb.start_soon(clock.start())

    dut._log.info("check counter values")
    for i in range(1,16):
        dut._log.info("check counter value {}".format(i))

        dut.rst_n.value = 0
        await ClockCycles(dut.clk, 1)
        dut.rst_n.value = 1
        await ClockCycles(dut.clk, 1)

        #dut._log.info("After reset ctr = {}".format(dut.counter_out.value))

        # counter value has to be 0 after reset
        #assert int(dut.counter_out.value) == 0

        # now count and then check final result
        await ClockCycles(dut.clk, i)
        #dut._log.info("i = {}".format(i))
        #dut._log.info("ctr = {}".format(dut.counter_out.value))
        #assert int(dut.counter_out.value) == i

        # all bidirectionals are set to output
        #assert dut.uio_oe == 0xFF

    dut._log.info("check counter overflow")

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 1)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    await ClockCycles(dut.clk, 16)
    #assert int(dut.counter_out.value) == 0
