module complement_8bit(input [7:0] a, output [7:0] b);
 not(b[0:0], a[0:0]);
 not(b[1:1], a[1:1]);
 not(b[2:2], a[2:2]);
 not(b[3:3], a[3:3]);
 not(b[4:4], a[4:4]);
 not(b[5:5], a[5:5]);
 not(b[6:6], a[6:6]);
 not(b[7:7], a[7:7]);
endmodule
