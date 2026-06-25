module complement_8bit (
    input  [7:0] a,
    output [7:0] b
);
  not (b[0:0], a[0:0]);
  not (b[1:1], a[1:1]);
  not (b[2:2], a[2:2]);
  not (b[3:3], a[3:3]);
  not (b[4:4], a[4:4]);
  not (b[5:5], a[5:5]);
  not (b[6:6], a[6:6]);
  not (b[7:7], a[7:7]);
endmodule


module xor_8bit (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s
);
  assign s[0] = a[0] ^ b[0];
  assign s[1] = a[1] ^ b[1];
  assign s[2] = a[2] ^ b[2];
  assign s[3] = a[3] ^ b[3];
  assign s[4] = a[4] ^ b[4];
  assign s[5] = a[5] ^ b[5];
  assign s[6] = a[6] ^ b[6];
  assign s[7] = a[7] ^ b[7];
endmodule


