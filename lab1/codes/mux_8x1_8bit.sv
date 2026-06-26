module mux_8x1_8bit_behv (
    input [2:0] sel,
    input [7:0] a[0 : 7],
    output reg [7:0] out
);
  always @(*) begin
    case (sel)
      3'b000:  out = a[0];
      3'b001:  out = a[1];
      3'b010:  out = a[2];
      3'b011:  out = a[3];
      3'b100:  out = a[4];
      3'b101:  out = a[5];
      3'b110:  out = a[6];
      3'b111:  out = a[7];
      default: out = a[0];
    endcase
  end
endmodule

module mux_8x1_1bit (
    input [2:0] sel,
    input [7:0] a,
    output wire b
);
  wire s0 = sel[0], s1 = sel[1], s2 = sel[2];

  assign b =
		 s2 &  s1 &  s0 & a[7] |
		 s2 &  s1 & ~s0 & a[6] |
		 s2 & ~s1 &  s0 & a[5] |
		 s2 & ~s1 & ~s0 & a[4] |
		~s2 &  s1 &  s0 & a[3] |
		~s2 &  s1 & ~s0 & a[2] |
		~s2 & ~s1 &  s0 & a[1] |
		~s2 & ~s1 & ~s0 & a[0];
endmodule

module mux_8x1_8bit_struct (
    input [2:0] sel,
    input [7:0] a[0:7],
    output wire [7:0] out
);

  genvar i;
  for (i = 0; i < 8; i = i + 1) begin
    mux_8x1_1bit m (
        .sel(sel),
        .a  ({a[7][i], a[6][i], a[5][i], a[4][i], a[3][i], a[2][i], a[1][i], a[0][i]}),
        .b  (out[i])
    );
  end
endmodule
