module complement_8bit (
    input  [7:0] a,
    output [7:0] out
);
  genvar i;
  for (i = 0; i < 8; i = i + 1) begin
    not (out[i], a[i]);
  end
endmodule

module xor_8bit (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);
  genvar i;
  for (i = 0; i < 8; i = i + 1) begin
    xor (out[i], a[i], b[i]);
  end
endmodule

module and_gate_8bit (
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out
);
  genvar i;
  for (i = 0; i < 8; i = i + 1) begin
    and (out[i], a[i], b[i]);
  end
endmodule

module or_gate_8bit (
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out
);
  genvar i;
  for (i = 0; i < 8; i = i + 1) begin
    or (out[i], a[i], b[i]);
  end
endmodule

module nand_gate_8bit (
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out
);
  wire [7:0] anded;
  and_gate_8bit a8b (
      .a  (a),
      .b  (b),
      .out(anded)
  );
  complement_8bit c8b (
      .a  (anded),
      .out(out)
  );
endmodule

module nor_gate_8bit (
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out
);
  wire [7:0] ored;
  or_gate_8bit a8b (
      .a  (a),
      .b  (b),
      .out(ored)
  );
  complement_8bit c8b (
      .a  (ored),
      .out(out)
  );
endmodule
