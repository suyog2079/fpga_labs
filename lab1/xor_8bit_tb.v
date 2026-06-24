`timescale 1ns/1ps

module xor_8bit_tb();
 reg [7:0]a,b;
 wire [7:0] s;

 xor_8bit x8b(.a(a), .b(b), .s(s));

 integer i,j; 
 initial begin
  $dumpfile("xor_8bit.vcd");
  $dumpvars(0,x8b);
  
  for(i=0; i<256; i=i+1) begin
    for(j=0;j<256; j=j+1) begin
     a = i; b = j; #100;
    end
  end
  $finish;
 end
endmodule
