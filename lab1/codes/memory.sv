module memory #(
    parameter int AD_LINES = 16,
    parameter int DATA_LINES = 8
) (
    input logic rd_wr_bar,
    input logic [AD_LINES - 1 : 0] addr,
    input logic [DATA_LINES - 1 : 0] wd,
    output logic [DATA_LINES - 1: 0] rd,
    input logic clk,
    input logic cs
);

  logic [DATA_LINES - 1: 0] mem[2**AD_LINES -1];
  always_ff @(posedge clk) begin
    if (cs && rd_wr_bar) begin
      rd <= mem[addr];
    end else if (cs && !rd_wr_bar) begin
      mem[addr] <= wd;
    end
  end
endmodule
