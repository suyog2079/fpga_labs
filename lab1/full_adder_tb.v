`timescale 1ns/1ps

module full_adder_tb();
 reg a, b, cin;
 wire cout, s;
 full_adder fa(.a(a), .b(b), .cin(cin), .s(s), .cout(cout));
 initial begin
  $dumpfile("full_adder.vcd");
  $dumpvars(0,fa);

  a=0;b=0;cin=0; #100;
  a=0;b=1;cin=0; #100;
  a=1;b=0;cin=0; #100;
  a=1;b=1;cin=0; #100;

  a=0;b=0;cin=1; #100;
  a=0;b=1;cin=1; #100;
  a=1;b=0;cin=1; #100;
  a=1;b=1;cin=1; #100;

  $finish;
 end 
endmodule
