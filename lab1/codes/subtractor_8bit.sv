module subtractor_8bit(input [7:0] a, b, output bout, output [7:0] s);
 wire [7:0] compb;
 complement_8bit c8b(.a(b),.b(compb));
 adder_8bit a8b(.a(a), .b(compb), .cin(1'b1), .s(s), .cout(bout));
endmodule
 
