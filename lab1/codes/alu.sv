module alu (
    input [2:0] alu_sel,
    input [7:0] a,
    input [7:0] b,
    output wire [7:0] out,
    output wire cout
);

  // result[0] : ADD
  // result[1] : SUB
  // result[2] : NOT
  // result[3] : XOR
  // result[4] : AND
  // result[5] : OR
  // result[6] : NAND
  // result[7] : NOR
  wire [7:0] result[7:0];
  wire carry;
  wire borrow;

  assign cout = (alu_sel == 3'b000) ? carry : (alu_sel == 3'b001) ? borrow : 1'b0;
  adder_8bit adder (
      .cin(1'b0),
      .a(a),
      .b(b),
      .cout(carry),
      .s(result[0])
  );
  subtractor_8bit subtractor (
      .a(a),
      .b(b),
      .bout(borrow),
      .s(result[1])
  );

  complement_8bit complement (
      .a  (a),
      .out(result[2])
  );
  xor_8bit xorgate (
      .a  (a),
      .b  (b),
      .out(result[3])
  );
  and_gate_8bit andgate (
      .a  (a),
      .b  (b),
      .out(result[4])
  );
  or_gate_8bit orgate (
      .a  (a),
      .b  (b),
      .out(result[5])
  );
  nand_gate_8bit nandgate (
      .a  (a),
      .b  (b),
      .out(result[6])
  );
  nor_gate_8bit norgate (
      .a  (a),
      .b  (b),
      .out(result[7])
  );

  mux_8x1_8bit_struct mux (
      .sel(alu_sel),
      .a  (result),
      .out(out)
  );
endmodule
