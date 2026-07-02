module processor #(
    parameter int AD_LINES   = 16,
    parameter int DATA_LINES = 8
) (
    input logic clk,
    input logic reset,
    output logic [AD_LINES - 1 : 0] addr_bus,
    inout wire [DATA_LINES -1 : 0] data_bus,

    output logic mem_cs,
    output logic mem_rd_wr_bar
);

  wire [2:0] reg_sel[1:0];
  wire reg_alu_db_bar;
  wire reg_rd_wr_bar;
  wire swp;
  wire reg_cs;
  wire [DATA_LINES -1 : 0] acc_line;
  wire [3:0] alu_op_code;
  wire [DATA_LINES - 1 : 0] alu_result;
  wire [DATA_LINES -1 : 0] alu_input[1:0];

  control_unit #(
      .AD_LINES  (AD_LINES),
      .DATA_LINES(DATA_LINES)
  ) cu (
      .clk(clk),
      .reset(reset),
      .acc_in(acc_line),
      .addr_bus(addr_bus),
      .data_bus(data_bus),
      .mem_cs(mem_cs),
      .mem_rd_wr_bar(mem_rd_wr_bar),
      .reg_sel(reg_sel),
      .reg_alu_db_bar(reg_alu_db_bar),
      .reg_rd_wr_bar(reg_rd_wr_bar),
      .swp(swp),
      .reg_cs(reg_cs),
      .alu_sel(alu_op_code)
  );

  register_bank #(
      .NO_REGISTERS(8),
      .DATA_LINES  (DATA_LINES)
  ) registers (
      .clk(clk),
      .data_bus(data_bus),
      .alu_db_bar(reg_alu_db_bar),
      .rd_wr_bar(reg_rd_wr_bar),
      .swp(swp),
      .reg_sel(reg_sel),
      .cs(reg_cs),
      .alu_input(alu_result),
      .alu_out(alu_input),
      .acc_out(acc_line)
  );


  ALU alu (
      .opcode(alu_op_code),
      .clk(clk),
      .reset(reset),
      .operand1(alu_input[0]),
      .operand2(alu_input[1]),
      .result(alu_result)
  );
endmodule
