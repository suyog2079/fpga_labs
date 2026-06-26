`timescale 1ns / 1ps

module alu_tb ();
  reg  [2:0] alu_sel;
  reg  [7:0] a;
  reg  [7:0] b;

  wire [7:0] out;
  wire       cout;

  alu dut (
      .alu_sel(alu_sel),
      .a(a),
      .b(b),
      .out(out),
      .cout(cout)
  );

  initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0, dut);

    a = 8'h55;
    b = 8'h0F;

    alu_sel = 3'b000;  // ADD
    #10;
    alu_sel = 3'b001;  // SUB
    #10;
    alu_sel = 3'b010;  // COMP
    #10;
    alu_sel = 3'b011;  // XOR
    #10;
    alu_sel = 3'b100;  // AND
    #10;
    alu_sel = 3'b101;  // OR
    #10;
    alu_sel = 3'b110;  // NAND
    #10;
    alu_sel = 3'b111;  // NOR
    #10;

    a = 8'hFF;
    b = 8'h01;

    alu_sel = 3'b000;
    #10;
    alu_sel = 3'b001;
    #10;
    alu_sel = 3'b010;
    #10;
    alu_sel = 3'b011;
    #10;
    alu_sel = 3'b100;
    #10;
    alu_sel = 3'b101;
    #10;
    alu_sel = 3'b110;
    #10;
    alu_sel = 3'b111;
    #10;

    a = 8'h34;
    b = 8'hAA;

    alu_sel = 3'b000;  // ADD
    #10;
    alu_sel = 3'b001;  // SUB
    #10;
    alu_sel = 3'b010;  // COMP
    #10;
    alu_sel = 3'b011;  // XOR
    #10;
    alu_sel = 3'b100;  // AND
    #10;
    alu_sel = 3'b101;  // OR
    #10;
    alu_sel = 3'b110;  // NAND
    #10;
    alu_sel = 3'b111;  // NOR
    #10;

    a = 8'hB3;
    b = 8'h29;

    alu_sel = 3'b000;  // ADD
    #10;
    alu_sel = 3'b001;  // SUB
    #10;
    alu_sel = 3'b010;  // COMP
    #10;
    alu_sel = 3'b011;  // XOR
    #10;
    alu_sel = 3'b100;  // AND
    #10;
    alu_sel = 3'b101;  // OR
    #10;
    alu_sel = 3'b110;  // NAND
    #10;
    alu_sel = 3'b111;  // NOR
    #10;

    a = 8'h58;
    b = 8'hD0;

    alu_sel = 3'b000;  // ADD
    #10;
    alu_sel = 3'b001;  // SUB
    #10;
    alu_sel = 3'b010;  // COMP
    #10;
    alu_sel = 3'b011;  // XOR
    #10;
    alu_sel = 3'b100;  // AND
    #10;
    alu_sel = 3'b101;  // OR
    #10;
    alu_sel = 3'b110;  // NAND
    #10;
    alu_sel = 3'b111;  // NOR
    #10;
    $finish;
  end

endmodule
