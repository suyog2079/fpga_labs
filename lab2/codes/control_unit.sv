module control_unit #(
    parameter int AD_LINES   = 16,
    parameter int DATA_LINES = 8
) (
    // common signals
    input logic clk,
    input logic reset,
    input wire [DATA_LINES -1 : 0] acc_in,
    output logic [AD_LINES - 1 : 0] addr_bus,
    inout wire [DATA_LINES -1 : 0] data_bus,
    // memory control lines and signals.
    output logic mem_cs,
    output logic mem_rd_wr_bar,

    // register bank control lines and signals
    output logic [2:0] reg_sel[1:0],
    output logic reg_alu_db_bar,
    output logic reg_rd_wr_bar,
    output logic swp,
    output logic reg_cs,

    // alu control bits
    output logic [3:0] alu_sel
);

  reg [ AD_LINES - 1 : 0] pc;
  reg [  AD_LINES -1 : 0] mem_address;
  reg [DATA_LINES -1 : 0] ir;
  reg [DATA_LINES -1 : 0] flag_register;

  typedef enum {
    FETCH,
    DECODE,
    EXECUTE,
    FETCH_ADDR,
    STORE
  } state_t;
  state_t state;

  typedef enum {
    SWAP,
    JUMP,
    MEMORY_OPERATION,
    ARITH
  } inst_t;
  inst_t instruction_type;

  typedef enum {
    MEMORY_2_REG,
    REG_2_MEMORY,
    ALU_2_REG
  } store_t;
  store_t store_type;

  typedef enum {
    FIRST,
    SECOND
  } fetch_number_t;
  fetch_number_t fetch_number;

  logic [DATA_LINES -1:0] recv_data;
  logic [DATA_LINES -1:0] acc_data;
  assign recv_data = data_bus;
  assign acc_data  = acc_in;

  initial begin
    pc <= 16'h0;
    state <= FETCH;
  end

  always_ff @(posedge reset) begin
    pc <= 16'h0;
    ir <= 8'h0;
    mem_address <= 16'h0;
    flag_register <= 8'h0;
    state <= FETCH;
  end

  always_ff @(posedge clk) begin
    mem_cs         <= 0;
    mem_rd_wr_bar  <= 1;

    reg_cs         <= 0;
    swp            <= 0;
    reg_rd_wr_bar  <= 1;
    reg_alu_db_bar <= 0;
		alu_sel <= 4'b0;
    case (state)
      FETCH: begin
        mem_cs <= 1;
        addr_bus <= pc;
        mem_rd_wr_bar <= 1'b1;
        pc <= pc + 1;
        state <= DECODE;
      end

      DECODE: begin
        ir = recv_data;
        case (ir[7:7])
          // either move type or load type instruction
          1'b0: begin
            case (ir[6:6])
              // swap type instruction
              // 00, 3 source register select and 3 destination register
              // select
              1'b0: begin
                instruction_type <= SWAP;
                state <= EXECUTE;
              end
              // load/store type instruction
              // bit division not done yet
              1'b1: begin
                fetch_number <= FIRST;
                // 010
                case (ir[5:5])
                  1'b0: begin
                    case (ir[4:4])
                      1'b1: begin
                        store_type <= MEMORY_2_REG;
                      end
                      1'b0: begin
                        store_type <= REG_2_MEMORY;
                      end
                      default: begin
                        state <= FETCH;
                      end
                    endcase
                    instruction_type <= MEMORY_OPERATION;
                  end
                  1'b1: begin
                    flag_register = acc_data;
                    case (ir[4:2])
                      // unconditional jump
                      3'b000: begin
                        instruction_type <= JUMP;
                      end
                      //JC 
                      3'b001: begin
                        if (flag_register[1:1]) begin
                          instruction_type <= JUMP;
                        end
                      end
                      //JNC
                      3'b010: begin
                        if (!flag_register[1:1]) begin
                          instruction_type <= JUMP;
                        end
                      end
                      // JZ
                      3'b011: begin
                        if (flag_register[2:2]) begin
                          instruction_type <= JUMP;
                        end
                      end
                      //JNZ
                      3'b100: begin
                        if (!flag_register[2:2]) begin
                          instruction_type <= JUMP;
                        end
                      end
                      default: begin
                        state <= FETCH;
                      end
                    endcase
                  end
                  default: begin
                    state <= FETCH;
                  end
                endcase
                state <= FETCH_ADDR;
              end
              default: begin
              end
            endcase
          end

          // arithematic / logical type instruction
          //1, 3 source register select and 4 operation select bits
          1'b1: begin
            instruction_type <= ARITH;
            state <= EXECUTE;
          end
          default: begin
            state <= FETCH;
          end
        endcase
      end

      FETCH_ADDR: begin
        case (fetch_number)
          FIRST: begin
            mem_cs <= 1;
            addr_bus <= pc;
            mem_rd_wr_bar <= 1'b1;
            pc <= pc + 1;
            fetch_number <= SECOND;
          end
          SECOND: begin
            mem_address[AD_LINES-DATA_LINES-1 : 0] <= recv_data;  //lower oeder address
            mem_cs <= 1;
            addr_bus <= pc;
            mem_rd_wr_bar <= 1'b1;
            pc <= pc + 1;
            state <= EXECUTE;
          end
          default: begin
            state <= FETCH;
          end
        endcase
      end

      EXECUTE: begin
        if (instruction_type == JUMP || instruction_type == MEMORY_OPERATION) begin
          mem_address[AD_LINES-1 : AD_LINES-DATA_LINES] <= recv_data;  //higher order address
        end
        case (instruction_type)
          SWAP: begin
            reg_sel[0] <= ir[5:3];
            reg_sel[1] <= ir[2:0];
            reg_cs <= 1;
            swp <= 1;
            state <= FETCH;
          end
          ARITH: begin
            alu_sel <= ir[6:3];
            reg_sel[0] <= 3'b000;
            reg_sel[1] <= ir[2:0];
            reg_cs <= 1;
            reg_alu_db_bar <= 1;
            reg_rd_wr_bar <= 1;
            state <= STORE;
            store_type <= ALU_2_REG;
          end
          MEMORY_OPERATION: begin
            state <= STORE;
          end
          JUMP: begin
            pc <= {recv_data, mem_address[DATA_LINES-1:0]};
            state <= FETCH;
          end
          default: begin
            state <= FETCH;
          end
        endcase
      end

      STORE: begin
        case (store_type)
          ALU_2_REG: begin
            reg_cs <= 1;
            reg_rd_wr_bar <= 0;
            reg_alu_db_bar <= 1;
            reg_sel[0] <= 3'b000;
          end
          MEMORY_2_REG: begin
            reg_cs <= 1;
            reg_rd_wr_bar <= 0;
            reg_alu_db_bar <= 0;
            reg_sel[0] <= 3'b000;

            addr_bus <= mem_address;
            mem_cs <= 1;
            mem_rd_wr_bar <= 1;
          end
          REG_2_MEMORY: begin
            reg_cs <= 1;
            reg_rd_wr_bar <= 1;
            reg_alu_db_bar <= 0;
            reg_sel[0] <= 3'b000;

            addr_bus <= mem_address;
            mem_cs <= 1;
            mem_rd_wr_bar <= 0;
          end
          default: begin
            state <= FETCH;
          end
        endcase
        state <= FETCH;
      end
      default: state <= FETCH;
    endcase
  end
endmodule

