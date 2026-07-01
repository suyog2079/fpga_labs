module half_adder(input a,b, output c,s);
	assign s=a^b;
	assign c=a&b;
endmodule;

module fulladder(input a,b,cin, output s,cout);
	wire stemp, ctemp1,ctemp2;
	half_adder ha1(.s(stemp), .c(ctemp1), .a(a), .b(b));
	half_adder ha2(.s(s), .c(ctemp2), .a(cin), .b(stemp));
	or(cout, ctemp1, ctemp2);
endmodule

module bit4adder(input [3:0] a,b,
	 input cin,
	 output cout, 
	 output [3:0] sum);

	wire c1, c2, c3;

	fulladder fa0(.a(a[0]),.b(b[0]), .cin(cin), .s(sum[0]), .cout(c1));
	fulladder fa1(.a(a[1]),.b(b[1]), .cin(c1), .s(sum[1]), .cout(c2));
	fulladder fa2(.a(a[2]),.b(b[2]), .cin(c2), .s(sum[2]), .cout(c3));
	fulladder fa3(.a(a[3]),.b(b[3]), .cin(c3), .s(sum[3]), .cout(cout));

	endmodule

module bit8adder(input [7:0] a,b,
	 input cin,
	 output cout, 
	 output [7:0] sum);

	wire c1;

	bit4adder adder1(.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(c1));
	bit4adder adder2(.a(a[7:4]), .b(b[7:4]), .cin(c1), .sum(sum[7:4]), .cout(cout));

	endmodule

module bit8subtractor(
		input [7:0] a,b,
		input cin,
		output cout,
		output [7:0] diff);

	wire [7:0]notB;
	assign notB = ~b;
	bit8adder adder(.a(a), .b(notB), .cin(cin), .cout(cout), .sum(diff));
endmodule

