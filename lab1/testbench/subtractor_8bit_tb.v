`timescale 1ns/1ps

module subtractor_8bit_tb();
 reg [7:0]a, b;
 wire bout;
 wire [7:0] s;

 subtractor_8bit s8b(.a(a), .b(b), .s(s), .bout(bout));

 integer i, j, k;

 initial begin
  $dumpfile("subtractor_8bit.vcd");
  $dumpvars(0,s8b);

  for (i = 0; i < 256; i = i + 1) begin        // a
 	 for (j = 0; j < 256; j = j + 1) begin      // b
   		a = i; b = j;
   		#100;
	end 
  end 
  $finish;
 end 
endmodule
