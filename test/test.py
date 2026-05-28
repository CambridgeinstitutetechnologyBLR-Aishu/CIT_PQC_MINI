import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_pqc_mini(dut):
    dut._log.info("Starting Miniature PQC Test")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Resetting...")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    dut.ena.value = 1

    # Test PQC Addition (Mode = 1)
    dut.uio_in.value = 1 # mode_sel = 1
    dut.ui_in.value = 0x53 # a=5, b=3
    await ClockCycles(dut.clk, 2)
    # 5 + 3 = 8
    assert dut.uo_out.value == 8

    # Test PQC Mixing (Mode = 0)
    dut.uio_in.value = 0 # mode_sel = 0
    dut.ui_in.value = 0x53 # a=5, b=3
    await ClockCycles(dut.clk, 2)
    # 5 ^ 3 = 6
    assert dut.uo_out.value == 6
