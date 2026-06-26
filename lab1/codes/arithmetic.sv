module adder_8bit (
    input cin,
    input [7:0] a,
    b,
    output cout,
    output [7:0] s
);
  wire c1;
  adder_4bit ad1 (
      .a(a[3:0]),
      .b(b[3:0]),
      .cin(cin),
      .s(s[3:0]),
      .cout(c1)
  );
  adder_4bit ad2 (
      .a(a[7:4]),
      .b(b[7:4]),
      .cin(c1),
      .s(s[7:4]),
      .cout(cout)
  );
endmodule


module adder_4bit (
    input [3:0] a,
    b,
    input cin,
    output [3:0] s,
    output cout
);
  wire c1, c2, c3;

  full_adder fa0 (
      .a(a[0]),
      .b(b[0]),
      .cin(cin),
      .s(s[0]),
      .cout(c1)
  );
  full_adder fa1 (
      .a(a[1]),
      .b(b[1]),
      .cin(c1),
      .s(s[1]),
      .cout(c2)
  );
  full_adder fa2 (
      .a(a[2]),
      .b(b[2]),
      .cin(c2),
      .s(s[2]),
      .cout(c3)
  );
  full_adder fa3 (
      .a(a[3]),
      .b(b[3]),
      .cin(c3),
      .s(s[3]),
      .cout(cout)
  );
endmodule


module full_adder (
    input  a,
    b,
    cin,
    output s,
    cout
);
  wire stemp, ctemp1, ctemp2;

  half_adder ha1 (
      .a(a),
      .b(b),
      .s(stemp),
      .c(ctemp1)
  );
  half_adder ha2 (
      .a(stemp),
      .b(cin),
      .s(s),
      .c(ctemp2)
  );
  or (cout, ctemp1, ctemp2);
endmodule


module half_adder (
    input  a,
    b,
    output s,
    c
);
  xor (s, a, b);
  and (c, a, b);
endmodule


module subtractor_8bit (
    input [7:0] a,
    b,
    output bout,
    output [7:0] s
);
  wire [7:0] compb;
  complement_8bit c8b (
      .a(b),
      .out(compb)
  );
  adder_8bit a8b (
      .a(a),
      .b(compb),
      .cin(1'b1),
      .s(s),
      .cout(bout)
  );
endmodule

