module binary_to_gray (
     input       [9:0] binary,
     output wire [9:0] gray
);
//
assign gray[9] = binary[9];
assign gray[8] = binary[9] ^ binary[8];
assign gray[7] = binary[8] ^ binary[7];
assign gray[6] = binary[7] ^ binary[6];
assign gray[5] = binary[6] ^ binary[5];
assign gray[4] = binary[5] ^ binary[4];
assign gray[3] = binary[4] ^ binary[3];
assign gray[2] = binary[3] ^ binary[2];
assign gray[1] = binary[2] ^ binary[1];
assign gray[0] = binary[1] ^ binary[0];
//
endmodule
