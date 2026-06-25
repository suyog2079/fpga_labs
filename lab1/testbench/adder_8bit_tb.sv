`timescale 1ns/1ps

module adder_8bit_tb();
 reg [7:0]a, b;
 reg cin;
 wire cout;
 wire [7:0] s;

 adder_8bit a8b(.a(a), .b(b), .cin(cin), .s(s), .cout(cout));

 integer i, j, k;

 initial begin
  $dumpfile("adder_8bit.vcd");
  $dumpvars(0,a8b);

	for (k = 0; k < 2; k = k + 1) begin          // cin
	 	for (i = 0; i < 256; i = i + 1) begin        // a
	  	for (j = 0; j < 256; j = j + 1) begin      // b
	   		a = i; b = j; cin = k;
	   		#100;
	 		end 
	 	end 
	end
  $finish;
 end 
endmodule
