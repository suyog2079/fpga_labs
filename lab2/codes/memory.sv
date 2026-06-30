module memory #(
    parameter int AD_LINES   = 16,
    parameter int DATA_LINES = 8
) (
    input logic rd_wr_bar,
    input logic [AD_LINES - 1 : 0] addr_bus,
    inout wire [DATA_LINES - 1 : 0] data_bus,
    input logic clk,
    input logic cs
);

  logic [DATA_LINES - 1:0] mem[0:(1<<AD_LINES) -1];
  assign data_bus = (cs && rd_wr_bar) ? mem[addr_bus] : 'z;
  always_ff @(posedge clk) begin
    if (cs && !rd_wr_bar) begin
      mem[addr_bus] <= data_bus;
    end
  end
endmodule
