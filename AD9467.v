module AD9467
//////////////////////////////////////////////////////////////////
(      
      input             sclk,
      input             rst_n,
      input      [ 7:0] data_in,
      output reg [15:0] data_out,
      input             dco
);
///////////////////////////////////////////////////////////////////////////////////
reg [7:0] data_H;
reg [7:0] data_L;
///////////////////////////////////////////////////////////////////////////////////
always @(posedge dco or negedge rst_n)
begin
     if (!rst_n) data_L <= 8'h00;
     else        data_L <= data_in[7:0];
end
///////////////////////////////////////////////////////////////////////////////////
always @(negedge dco or negedge rst_n)
begin
     if (!rst_n) data_H <= 8'h00;
     else        data_H <= data_in[7:0];
end
///////////////////////////////////////////////////////////////////////////////////
always @(posedge sclk)
begin
     data_out[ 0] <= data_L[0];
     data_out[ 1] <= data_H[0];
     data_out[ 2] <= data_L[1];
     data_out[ 3] <= data_H[1];
     data_out[ 4] <= data_L[2];
     data_out[ 5] <= data_H[2];
     data_out[ 6] <= data_L[3];
     data_out[ 7] <= data_H[3];
     data_out[ 8] <= data_L[4];
     data_out[ 9] <= data_H[4];
     data_out[10] <= data_L[5];
     data_out[11] <= data_H[5];
     data_out[12] <= data_L[6];
     data_out[13] <= data_H[6];
     data_out[14] <= data_L[7];
     data_out[15] <= data_H[7];
end
///////////////////////////////////////////////////////////////////////////////////
endmodule
