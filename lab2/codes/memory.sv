module memory #(
    parameter int AD_LINES   = 16,
    parameter int DATA_LINES = 8
) (
    input logic rd_wr_bar,
    input logic [AD_LINES - 1 : 0] addr,
    inout wire [DATA_LINES - 1 : 0] data,
    //output logic [DATA_LINES - 1: 0] rd,
    input logic clk,
    input logic cs
);

  logic [DATA_LINES - 1:0] mem[0:(1<<AD_LINES) -1];
  assign data = (cs && rd_wr_bar) ? mem[addr] : 'z;
  always_ff @(posedge clk) begin
    if (cs && !rd_wr_bar) begin
      mem[addr] <= data;
    end
  end
endmodule
