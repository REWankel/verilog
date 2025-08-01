module ADC3241_1W(
     input             sclk,
     input             rst_n,
     input             FCLK,
     input             DCLK,
     input             DA0,
     input             DA1,
     input             DB0,
     input             DB1,
     output reg [13:0] adc_da,
     output reg [13:0] adc_db
);
//
reg [6:0] temp_1;
reg [6:0] temp_2;
reg [6:0] temp_3;
reg [6:0] temp_4;
//
always @(posedge DCLK or negedge rst_n)
begin
     if (!rst_n) begin 
                      temp_1[6:0] <= 7'h00;
                      temp_2[6:0] <= 7'h00;
                 end
     else        begin
                      temp_1[6:0] <= {DA0,temp_1[6:1]};
                      temp_2[6:0] <= {DB0,temp_2[6:1]};
                 end
end
//
always @(negedge DCLK or negedge rst_n)
begin
     if (!rst_n) begin 
                      temp_3[6:0] <= 7'h00;
                      temp_4[6:0] <= 7'h00;
                 end
     else        begin
                      temp_3[6:0] <= {DA0,temp_3[6:1]};
                      temp_4[6:0] <= {DB0,temp_4[6:1]};
                 end
end
//
always @(posedge FCLK or negedge rst_n)
begin
     if (!rst_n) begin 
                      adc_da[13:0] <= 14'h0000;
                      adc_db[13:0] <= 14'h0000;
                 end
     else        begin 
                      adc_da[13:0] <= {temp_3[6],temp_1[6],
                                       temp_3[5],temp_1[5],
                                       temp_3[4],temp_1[4],
                                       temp_3[3],temp_1[3],
                                       temp_3[2],temp_1[2],
                                       temp_3[1],temp_1[1],
                                       temp_3[0],temp_1[0]};
                      adc_db[13:0] <= {temp_4[6],temp_2[6],
                                       temp_4[5],temp_2[5],
                                       temp_4[4],temp_2[4],
                                       temp_4[3],temp_2[3],
                                       temp_4[2],temp_2[2],
                                       temp_4[1],temp_2[1],
                                       temp_4[0],temp_2[0]};
                 end
end
//
endmodule
