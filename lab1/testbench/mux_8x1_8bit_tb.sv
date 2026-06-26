module mux_8x1_8bit_tb ();
  reg [2:0] sel;
  reg [7:0] a[7:0];
  wire [7:0] out;

  mux_8x1_8bit_struct m8b (
      .sel(sel),
      .a  (a),
      .out(out)
  );

  initial begin
    $dumpfile("mux_4x1_8bit.vcd");
    $dumpvars(0, m8b);
    a[0] = 8'h00;
    a[1] = 8'h11;
    a[2] = 8'h22;
    a[3] = 8'h33;
    a[4] = 8'h44;
    a[5] = 8'h55;
    a[6] = 8'h66;
    a[7] = 8'h77;

    sel  = 3'b000;
    #10;
    sel = 3'b001;
    #10;
    sel = 3'b010;
    #10;
    sel = 3'b011;
    #10;
    sel = 3'b100;
    #10;
    sel = 3'b101;
    #10;
    sel = 3'b110;
    #10;
    sel = 3'b111;
    #10;
    $finish;
  end
endmodule

