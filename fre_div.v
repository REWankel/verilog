module fre_div
#(
parameter limit     = 125000000,
parameter cnt_width = 32
)
(
    input      sclk,
    input      rst_n,
    output reg div_clk
);
//
reg [cnt_width-1:0] cnt;
//
always @(posedge sclk or negedge rst_n) 
begin
     if (!rst_n)
         cnt <= 0;
     else if (cnt == limit - 1)
         cnt <= 0;
     else
         cnt <= cnt + 1;
end
//
always @(posedge sclk or negedge rst_n) 
begin
     if (!rst_n)
         div_clk <= 0;
     else if (cnt < limit/2)
         div_clk <= 1;
     else
         div_clk <= 0;
end

//	
endmodule
