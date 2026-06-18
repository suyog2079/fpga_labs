`timescale 1ns/1ps

module half_adder_tb();
 reg a, b;
 wire c, s;
 half_adder ha(.a(a), .b(b), .c(c), .s(s));
 initial begin
  $dumpfile("half_adder.vcd");
  $dumpvars(0,ha);

  a=0;b=0; #100;
  a=0;b=1; #100;
  a=1;b=0; #100;
  a=1;b=1; #100;

  $finish;
 end 
endmodule
