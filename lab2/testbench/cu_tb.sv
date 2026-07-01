module tb_control_unit;

  parameter int AD_LINES   = 16;
  parameter int DATA_LINES = 8;

  // ----- Signals -----
  logic clk;
  logic reset = 1'b0;

  wire [AD_LINES-1:0] addr_bus;
  wire [DATA_LINES-1:0] data_bus;
  wire mem_cs, mem_rd_wr_bar;
  wire [2:0] reg_sel[1:0];
  wire reg_alu_db_bar, reg_rd_wr_bar, swp, reg_cs;
  wire [3:0] alu_sel;

  wire [DATA_LINES-1:0] acc_out;
  wire [DATA_LINES-1:0] alu_in;
  wire [DATA_LINES-1:0] alu_out[1:0];
  wire [2:0] alu_flag;

	// Control Unit
  control_unit #(
    .AD_LINES(AD_LINES),
    .DATA_LINES(DATA_LINES)
  ) uut (
    .clk(clk),
    .acc_in(acc_out),
    .addr_bus(addr_bus),
    .data_bus(data_bus),
    .mem_cs(mem_cs),
    .mem_rd_wr_bar(mem_rd_wr_bar),
    .reg_sel(reg_sel),
    .reg_alu_db_bar(reg_alu_db_bar),
    .reg_rd_wr_bar(reg_rd_wr_bar),
    .swp(swp),
    .reg_cs(reg_cs),
    .alu_sel(alu_sel)
  );

	// Memory
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

	//Register bank
  register_bank #(
    .NO_REGISTERS(8),
    .DATA_LINES(DATA_LINES)
  ) reg_bank (
    .data_bus(data_bus),
    .clk(clk),
    .alu_db_bar(reg_alu_db_bar),
    .rd_wr_bar(reg_rd_wr_bar),
    .swp(swp),
    .reg_sel(reg_sel),
    .cs(reg_cs),
    .alu_input(alu_in),
    .alu_out(alu_out),
    .acc_out(acc_out)
  );

	// ALU
  ALU alu (
    .opcode(alu_sel),
    .clk(clk),
    .reset(reset),
    .operand1(alu_out[0]),
    .operand2(alu_out[1]),
    .result(alu_in),
    .flag(alu_flag)
  );

	// Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $dumpfile("waves.vcd");
    $dumpvars(0, tb_control_unit);
  end

	// Memory and Register initialization
  initial begin
    // Program at address 0
    mem.mem[0]  = 8'h01;      // SWAP R0, R1
    mem.mem[1]  = 8'h89;      // ADD R0, R1
    mem.mem[2]  = 8'h50;      // MEM2REG (load from 0x1234)
    mem.mem[3]  = 8'h34;      // low byte
    mem.mem[4]  = 8'h12;      // high byte
    mem.mem[5]  = 8'h40;      // REG2MEM (store R0 to 0x5678)
    mem.mem[6]  = 8'h78;      // low byte
    mem.mem[7]  = 8'h56;      // high byte
    mem.mem[8]  = 8'h60;      // JMP 0x2000
    mem.mem[9]  = 8'h00;      // low byte
    mem.mem[10] = 8'h20;      // high byte
    mem.mem[16'h2000] = 8'h00; // NOP at jump target

    // Data for MEM2REG
    mem.mem[16'h1234] = 8'hAA;

    // Initial register values
    reg_bank.register[0] = 8'h55;
    reg_bank.register[1] = 8'h66;
  end

  initial begin
    repeat (130) @(posedge clk);

    $finish;
  end

endmodule
