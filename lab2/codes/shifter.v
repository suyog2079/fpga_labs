module leftShift (
    input  wire [7:0] in,
    input  wire [2:0] shift,// (0-7)
    output wire [7:0] out
);
    wire [7:0] stage1, stage2;
 
    assign stage1 = shift[0] ? {in[6:0], 1'b0} : in; //Shift by 1 bit
	assign stage2 = shift[1] ? {stage1[5:0], 2'b00} : stage1; //Shift by 2 bit
    assign out = shift[2] ? {stage2[3:0], 4'b0000} : stage2; //Shift by 4 bit
 
endmodule

module rightShift(
    input  wire [7:0] in,
    input  wire [2:0] shift, //(0-7)
    output wire [7:0] out
);
 
    wire [7:0] stage1, stage2;
 
    assign stage1 = shift[0] ? {1'b0, in[7:1]} : in; //Shift by 1 bit
    assign stage2 = shift[1] ? {2'b00, stage1[7:2]} : stage1; //Shift by 2 bit
    assign out = shift[2] ? {4'b0000, stage2[7:4]} : stage2; //Shift by 4 bit
 
endmodule
