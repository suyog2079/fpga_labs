module adder_8bit(input cin, input [7:0]a, b, output cout, output [7:0]s);
	wire c1;
	adder_4bit ad1(.a(a[3:0]), .b(b[3:0]), .cin(cin), .s(s[3:0]), .cout(c1));
	adder_4bit ad2(.a(a[7:4]), .b(b[7:4]), .cin(c1), .s(s[7:4]), .cout(cout));
endmodule
