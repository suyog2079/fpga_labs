module memory_tb;

  localparam AD_LINES = 16;
  localparam DATA_LINES = 8;

  logic rd_wr_bar;
  logic [AD_LINES-1:0] addr;
  logic [DATA_LINES-1:0] wd;
  logic [DATA_LINES-1:0] rd;
  logic clk;
  logic cs;

  memory #(
      .AD_LINES  (AD_LINES),
      .DATA_LINES(DATA_LINES)
  ) dut (
      .rd_wr_bar(rd_wr_bar),
      .addr(addr),
      .wd(wd),
      .rd(rd),
      .clk(clk),
      .cs(cs)
  );

  //----------------------------------
  // Clock
  //----------------------------------

  initial clk = 0;
  always #5 clk = ~clk;

  //----------------------------------
  // Write task
  //----------------------------------

  task automatic write_mem(input [AD_LINES-1:0] a, input [DATA_LINES-1:0] d);
    begin
      @(posedge clk);

      addr      = a;
      wd        = d;
      rd_wr_bar = 0;
      cs        = 1;

      @(negedge clk);

      cs = 0;

      $display("[%0t] WRITE addr=%h data=%h", $time, a, d);
    end
  endtask

  //----------------------------------
  // Read task
  //----------------------------------

  task automatic read_mem(input [AD_LINES-1:0] a, output [DATA_LINES-1:0] d);
    begin
      @(posedge clk);

      addr      = a;
      rd_wr_bar = 1;
      cs        = 1;

      @(negedge clk);
      #1;

      d  = rd;

      cs = 0;

      $display("[%0t] READ  addr=%h data=%h", $time, a, d);
    end
  endtask

  logic [DATA_LINES-1:0] data;

  //----------------------------------
  // Tests
  //----------------------------------

  initial begin
    cs        = 0;
    rd_wr_bar = 1;
    addr      = '0;
    wd        = '0;

    repeat (2) @(posedge clk);

    write_mem(16'h0010, 8'hAA);
    read_mem(16'h0010, data);

    if (data !== 8'hAA) begin
      $display("TEST1 FAIL");
      $finish;
    end
    $display("TEST1 PASS");

    write_mem(16'h1234, 8'h55);
    read_mem(16'h1234, data);

    if (data !== 8'h55) begin
      $display("TEST2 FAIL");
      $finish;
    end
    $display("TEST2 PASS");

    $display("ALL TESTS PASSED");
    $finish;
  end

endmodule
