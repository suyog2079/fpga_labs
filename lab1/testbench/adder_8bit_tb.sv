`timescale 1ns / 1ps

module adder_8bit_tb ();
  reg [7:0] a, b;
  reg cin;
  wire cout;
  wire [7:0] s;

  adder_8bit a8b (
      .a(a),
      .b(b),
      .cin(cin),
      .s(s),
      .cout(cout)
  );

  integer i, j, k;

  initial begin
    $dumpfile("adder_8bit.vcd");
    $dumpvars(0, a8b);

    a   = 8'h00;
    b   = 8'h00;
    cin = 0;

    a   = 8'hFF;
    b   = 8'h01;
    cin = 0;
    #100;

    a   = 8'hFF;
    b   = 8'hFF;
    cin = 1;
    #100;

    a   = 8'h7F;
    b   = 8'h01;
    cin = 0;
    #100;


    a   = 8'h55;
    b   = 8'hAA;
    cin = 1;
    #100;


    a   = 8'h03;
    b   = 8'h05;
    cin = 1;
    #100;

    a   = 8'hFF;
    b   = 8'h00;
    cin = 1;
    #100;

    $finish;
  end
endmodule
