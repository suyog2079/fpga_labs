module memory #(
    parameter int AD_LINES   = 16,
    parameter int DATA_LINES = 8
) (
    input logic cs,
    input logic ale,
    input logic clk,
    input logic rd_wr_bar,
    inout wire [AD_LINES-1:0] ad
);

  reg [AD_LINES - 1 : 0] stored_addr;
  logic [DATA_LINES - 1 : 0] mem[2**AD_LINES - 1];

  typedef enum {
    INIT,
    ADDRESS_SELECTED
  } state_t;

  state_t state = INIT;

  assign ad[7:0] = (rd_wr_bar && cs && state == ADDRESS_SELECTED) ? mem[stored_addr] : 'z;

  always_ff @(posedge clk) begin
    if (cs) begin
      case (state)
        INIT: begin
          if (ale) begin
            stored_addr <= ad;
            state <= ADDRESS_SELECTED;
          end
        end

        ADDRESS_SELECTED: begin
          if (!rd_wr_bar && ale == 0) begin
            mem[stored_addr] <= ad[7:0];
          end
          state <= ADDRESS_SELECTED;
        end

        default: state <= INIT;
      endcase
    end
    if (!cs) begin
      state <= INIT;
    end
  end
endmodule
