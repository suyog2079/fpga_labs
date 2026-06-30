module register_bank #(
    parameter int NO_REGISTERS = 8,
    parameter int DATA_LINES   = 8
) (
    inout wire [DATA_LINES - 1:0] data_bus,
    input logic clk,
    input alu_db_bar,
    input rd_wr_bar,
    input swp,
    input logic [2:0] reg_sel[1:0],
    input logic cs,
    input [DATA_LINES - 1:0] alu_input,
    output logic [DATA_LINES - 1 : 0] alu_out[1:0]
);
  reg [DATA_LINES - 1:0] register[0:NO_REGISTERS - 1];
  // connect data_bus to selected register to out selected register value to
  // the data bus
  assign data_bus   = (cs && rd_wr_bar && !alu_db_bar) ? register[reg_sel[0]] : 'z;
  assign alu_out[0] = register[reg_sel[0]];
  assign alu_out[1] = register[reg_sel[1]];
  always_ff @(posedge clk) begin : blockName
    if (cs) begin
      if (swp) begin
        temp = register[reg_sel[0]];
        register[reg_sel[0]] <= register[reg_sel[1]];
        register[reg_sel[1]] <= temp;
      end else if (!rd_wr_bar) begin
        if (alu_db_bar) begin
          register[reg_sel[0]] <= alu_input;
        end else begin
          register[reg_sel[0]] <= data_bus;
        end
      end
    end
  end

endmodule
