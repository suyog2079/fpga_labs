`timescale 1ns/1ps

module complement_8bit_tb();
 reg [7:0] a;
 wire [7:0] b;

 complement_8bit c8b(.a(a), .b(b));

  integer i;

 initial begin
  $dumpfile("complement_8bit.vcd");
  $dumpvars(0,c8b);
   for(i = 0; i < 256; i = i + 1) begin
    a = i; #100;
   end
  $finish;
 end
endmodule
