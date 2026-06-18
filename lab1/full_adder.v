module full_adder(input a, b, cin, output s, cout);
 wire stemp, ctemp1, ctemp2;

 half_adder ha1(.a(a), .b(b), .s(stemp), .c(ctemp1));
 half_adder ha2(.a(stemp), .b(cin), .s(s), .c(ctemp2));
 or(cout, ctemp1, ctemp2);

endmodule
