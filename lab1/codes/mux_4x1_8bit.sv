module mux_4x1_8bit(input [1:0]sel, input [7:0] a[3:0], output reg [7:0] out);
	always @(*)
	begin
		case(sel)
			2'b00 : out = a[0];
			2'b01 : out = a[1];
			2'b10 : out = a[2];
			2'b11 : out = a[3];
			default : out = a[0];
		endcase
	end
endmodule
