define mem_cell_size = 12;
module control_unit(input [12:0] opcode, input clk,
	output [2:0]readreg,
	[2:0]writereg,
	[2:0] aluop,
	[7:0] immediate,
	[mem_cell_size - 1:0] mem_addr [1023:0],
	mem_rd_wr_bar
);

reg [mem_cell_size -1: 0] pc; //program counter read
reg [mem_cell_size-1: 0] opcode_reg;
assign mem_rd_wr_bar = 1; // default read

memory mem(.rd_wr_bar(mem_rd_wr_bar), .addr(mem_addr), .out(opcode));

assign pc = mem_cell_size'b0;
enum {fetch, mem_read, decode, fetch_operand, execute} state;
state = fetch;
always @(posedge clk)
begin
	case(state)
		fetch:
			mem_rd_wr_bar = 1'b1;
		mem_addr = pc;
		pc = pc + 1;
		state = decode;

		mem_read: 
			mem_rd_wr_bar = 1'b1;
		mem_addr = pc;
		pc = pc + 1;
		state = decode;

		decode:
			opcode_reg = opcode;
		if(opcode[mem_cell_size - 1] == 1'b1)
			immediate = opcode_reg[7:0];

		else
			pc = pc + 1;
		state = mem_read;




		fetch_operand:

			execute
