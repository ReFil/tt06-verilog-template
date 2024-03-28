# SPDX-FileCopyrightText: © 2023 Uri Shaked <uri@tinytapeout.com>
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_adder(dut):
  dut._log.info("Start")
  
 # Our example module doesn't use clock and reset, but we show how to use them here anyway.
  clock = Clock(dut.clk, 10, units="us")
  cocotb.start_soon(clock.start())
  # Reset
  dut._log.info("Reset")
  dut.ena.value = 1
  dut.ui_in.value = 0
  dut.uio_in.value = 0
  dut.rst_n.value = 0
  dut.rst_n.value = 1

  # Set the input values, wait one clock cycle, and check the output
  dut._log.info("Addition test 1 ")
  dut.ui_in.value = 105
  dut.uio_in.value = 0
  await ClockCycles(dut.clk, 10)
  assert dut.uo_out.value == 15
    # Set the input values, wait one clock cycle, and check the output
  dut._log.info("Addition test 2 ")
  dut.ui_in.value = 41
  dut.uio_in.value = 0
  await ClockCycles(dut.clk, 10)

  assert dut.uo_out.value == 11
  # Set the input values, wait one clock cycle, and check the output
  dut._log.info("Addition test 3 ")
  dut.ui_in.value = 40
  dut.uio_in.value = 0
  await ClockCycles(dut.clk, 10)

  assert dut.uo_out.value == 10
  # Set the input values, wait one clock cycle, and check the output
  dut._log.info("Addition test 4 ")
  dut.ui_in.value = 128
  dut.uio_in.value = 0
  await ClockCycles(dut.clk, 10)

  assert dut.uo_out.value == 8

