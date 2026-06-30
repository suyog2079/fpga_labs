module control_unit #(
    parameter int AD_LINES   = 16,
    parameter int DATA_LINES = 8
) (
    // common signals
    input logic clk,
    output logic [AD_LINES - 1 : 0] addr_bus,
    inout wire [DATA_LINES -1 : 0] data_bus,
    // memory control lines and signals.
    output logic mem_cs,
    output logic mem_rd_wr_bar,

    // register bank control lines and signals
    output logic [2:0] reg_sel[1:0],
    output alu_alu_db_bar,
    output alu_rd_wr_bar,
    output mv,
    output logic reg_cs
);

  reg pc;
  reg ir;

  typedef enum {
    FETCH,
    DECODE,
    EXECUTE,
    STORE
  } state_t;
  state_t state = FETCH;

  logic   recv_data = data;

  always_ff @(posedge clk) begin
    case (state)
      FETCH: begin
        mem_addr <= pc;
        rd_wr_bar <= 1'b1;
        pc <= pc + 1;
        state <= DECODE;
      end

      DECODE: begin
        ir <= recv_data;

        case (ir[7:7])

          // either move tyoe or load type instruction
          1'b0: begin
            case (ir[6:6])
              // move type instruction
              // 00, 3 source register select and 3 destination register
              // select
              1'b0: begin

              end
              // load/store type instruction
              // bit division not done yet
              1'b1: begin

              end
              default: begin

              end
            endcase
          end

          // arithematic / logical type instruction
          //1, 3 source register select and 4 operation select bits
          1'b1: begin

          end

          default: begin

          end
        endcase
      end

      EXECUTE: begin

      end

      STORE: begin

      end

      default: state <= FETCH;

    endcase

  end

endmodule

