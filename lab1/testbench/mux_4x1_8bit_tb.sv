module mux_4x1_8bit_tb();
	reg [1:0] sel;
	reg [7:0]a[3:0];
	wire [7:0] out;

	mux_4x1_8bit m8b(.sel(sel), .a(a), .out(out));

	initial begin
		$dumpfile("mux_4x1_8bit.vcd");
		$dumpvars(0,m8b);
		a[0] = 8'h12;
    a[1] = 8'h34;
    a[2] = 8'h56;
    a[3] = 8'h78;

    sel = 2'b00; #10;
    sel = 2'b01; #10;
    sel = 2'b10; #10;
    sel = 2'b11; #10;

    a[0] = 8'hFF;
    a[1] = 8'h00;
    a[2] = 8'hAA;
    a[3] = 8'h55;

    sel = 2'b00; #10;
    sel = 2'b01; #10;
    sel = 2'b10; #10;
    sel = 2'b11; #10;
    $finish;
	end
endmodule

