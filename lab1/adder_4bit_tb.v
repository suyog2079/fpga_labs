`timescale 1ns/1ps

module adder_4bit_tb();
 reg [3:0]a, b;
 reg cin;
 wire cout;
 wire [3:0] s;

 adder_4bit a4b(.a(a), .b(b), .cin(cin), .s(s), .cout(cout));

 integer i, j, k;

 initial begin
  $dumpfile("adder_4bit.vcd");
  $dumpvars(0,a4b);

	for (k = 0; k < 2; k = k + 1) begin          // cin
	 	for (i = 0; i < 16; i = i + 1) begin        // a
	  	for (j = 0; j < 16; j = j + 1) begin      // b
	   		a = i; b = j; cin = k;
	   		#100;
	 		end 
	 	end 
	end
  $finish;
 end 
endmodule
