module xor_8bit(input [7:0]a, b, output [7:0]s);
 assign s[0] = a[0] ^ b[0];
 assign s[1] = a[1] ^ b[1];
 assign s[2] = a[2] ^ b[2];
 assign s[3] = a[3] ^ b[3];
 assign s[4] = a[4] ^ b[4];
 assign s[5] = a[5] ^ b[5];
 assign s[6] = a[6] ^ b[6];
 assign s[7] = a[7] ^ b[7];
endmodule
