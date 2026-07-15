
`timescale 1ns / 1ps
module tb_processor;

  parameter int AD_LINES = 16;
  parameter int DATA_LINES = 8;

  logic clk = 0;
  logic reset = 1;

  wire [AD_LINES-1:0] addr_bus;
  wire [DATA_LINES-1:0] data_bus;
  wire mem_cs, mem_rd_wr_bar;

  processor #(
      .AD_LINES(AD_LINES),
      .DATA_LINES(DATA_LINES)
  ) dut (
      .clk(clk),
      .reset(reset),
      .addr_bus(addr_bus),
      .data_bus(data_bus),
      .mem_cs(mem_cs),
      .mem_rd_wr_bar(mem_rd_wr_bar)
  );

  memory #(
      .AD_LINES(AD_LINES),
      .DATA_LINES(DATA_LINES)
  ) mem (
      .rd_wr_bar(mem_rd_wr_bar),
      .addr_bus(addr_bus),
      .data_bus(data_bus),
      .clk(clk),
      .cs(mem_cs)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("processor.vcd");
    $dumpvars(0, tb_processor);
  end

  initial begin
    // Program:
    // 0x0000 : ADD R1          (R0 = R0 + R1)
    // 0x0001 : REG2MEM 0x1000
    // 0x0004 : MEM2REG 0x1000
    // 0x0007 : SUB R2          (sets Z flag)
		// 0x0008 : GETFLAG R0
    // 0x0008 : JZ 0x0010
    // 0x000B : NOP             (should be skipped)
    // 0x0010 : INC
    // 0x0011 : JMP 0x0020
    // 0x0020 : XOR R3

    mem.mem[16'h0000] = 8'h89; // ADD R1
    mem.mem[16'h0001] = 8'h40; // REG2MEM
    mem.mem[16'h0002] = 8'h00;
    mem.mem[16'h0003] = 8'h10;

    mem.mem[16'h0004] = 8'h50; // MEM2REG
    mem.mem[16'h0005] = 8'h00;
    mem.mem[16'h0006] = 8'h10;

    mem.mem[16'h0007] = 8'h92; // SUB R2

    mem.mem[16'h0008] = 8'hC0; // Read flag
    mem.mem[16'h0009] = 8'h6C; // JZ
    mem.mem[16'h000A] = 8'h10;
    mem.mem[16'h000B] = 8'h00;

    mem.mem[16'h000C] = 8'h80; // NOP

    mem.mem[16'h0010] = 8'h98; // INC (lower bits ignored)
    mem.mem[16'h0011] = 8'h60; // JMP
    mem.mem[16'h0012] = 8'h20;
    mem.mem[16'h0013] = 8'h00;

    mem.mem[16'h0020] = 8'hE3; // XOR R3

    // Register initialization
    dut.registers.register[0] = 8'h05; // R0
    dut.registers.register[1] = 8'h03; // R1
    dut.registers.register[2] = 8'h08; // R2 -> makes SUB result zero
    dut.registers.register[3] = 8'h0F; // R3

    #20 reset = 0;

    repeat (200) @(posedge clk);

    $display("Memory[0x1000] = %02h", mem.mem[16'h1000]);
    $display("R0 = %02h", dut.registers.register[0]);
    $finish;
  end

endmodule
