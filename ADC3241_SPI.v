module ADC3241_SPI(
     input             sclk,
     input             rst_n,
     output wire       spi_sclk,
     output wire [2:0] spi_cs,
     output wire       spi_mosi,
     input             spi_miso,
     output wire [2:0] adc_rst,
     output wire [2:0] adc_pdn,
     output  reg       spi_done
);
//
reg  [6:0] spi_cnt;
reg        sck;
reg        csn;
reg        mosi;
reg [13:0] addr;
reg  [7:0] dout;
reg  [4:0] spi_state;
reg  [3:0] spi_FSM;
reg  [3:0] wait_cnt;
//
always @(posedge sclk)
begin
     case(spi_FSM)
     0:                         begin                           spi_FSM <= spi_FSM+1; spi_done <= 0; end
     1: if      (28==spi_state) begin spi_state <= 0;           spi_FSM <= 4;                        end
        else if (spi_cnt>72)    begin spi_cnt   <= 0;           spi_FSM <= spi_FSM+1;                end
        else if (72>=spi_cnt)   begin spi_cnt   <= spi_cnt+1;                                        end
     2: if      (9>=wait_cnt)   begin wait_cnt  <= wait_cnt+1;                                       end
        else if (wait_cnt>9)    begin wait_cnt  <= 0;           spi_FSM <= spi_FSM+1;                end
     3: if      (27>=spi_state) begin spi_state <= spi_state+1; spi_FSM <= 1;                        end
	 //
     4: if      (28==spi_state) begin spi_state <= 0;           spi_FSM <= 7;                        end
        else if (spi_cnt>72)    begin spi_cnt   <= 0;           spi_FSM <= spi_FSM+1;                end
        else if (72>=spi_cnt)   begin spi_cnt   <= spi_cnt+1;                                        end
     5: if      (9>=wait_cnt)   begin wait_cnt  <= wait_cnt+1;                                       end
        else if (wait_cnt>9)    begin wait_cnt  <= 0;           spi_FSM <= spi_FSM+1;                end
     6: if      (27>=spi_state) begin spi_state <= spi_state+1; spi_FSM <= 4;                        end
	 //
     7: if      (28==spi_state) begin spi_state <= spi_state;   spi_FSM <= spi_FSM;   spi_done <= 1; end
        else if (spi_cnt>72)    begin spi_cnt   <= 0;           spi_FSM <= spi_FSM+1;                end
        else if (72>=spi_cnt)   begin spi_cnt   <= spi_cnt+1;                                        end
     8: if      (9>=wait_cnt)   begin wait_cnt  <= wait_cnt+1;                                       end
        else if (wait_cnt>9)    begin wait_cnt  <= 0;           spi_FSM <= spi_FSM+1;                end
     9: if      (27>=spi_state) begin spi_state <= spi_state+1; spi_FSM <= 7;                        end
     endcase
end
//
always @(posedge sclk)
begin
     case(spi_state)
     0  : begin addr[13:0] <= 14'h0000; dout[7:0] <= 8'h00; end
     1  : begin addr[13:0] <= 14'h0006; dout[7:0] <= 8'h00; end     
     2  : begin addr[13:0] <= 14'h0006; dout[7:0] <= 8'h01; end
     3  : begin addr[13:0] <= 14'h0006; dout[7:0] <= 8'h00; end
     4  : begin addr[13:0] <= 14'h0001; dout[7:0] <= 8'h00; end
     5  : begin addr[13:0] <= 14'h0003; dout[7:0] <= 8'h00; end
     6  : begin addr[13:0] <= 14'h0004; dout[7:0] <= 8'h00; end
     7  : begin addr[13:0] <= 14'h0005; dout[7:0] <= 8'h01; end
     8  : begin addr[13:0] <= 14'h0007; dout[7:0] <= 8'h00; end
     9  : begin addr[13:0] <= 14'h0009; dout[7:0] <= 8'h01; end
     10 : begin addr[13:0] <= 14'h000A; dout[7:0] <= 8'h00; end
     11 : begin addr[13:0] <= 14'h000B; dout[7:0] <= 8'h00; end
     12 : begin addr[13:0] <= 14'h000E; dout[7:0] <= 8'h00; end
     13 : begin addr[13:0] <= 14'h000F; dout[7:0] <= 8'h00; end
     14 : begin addr[13:0] <= 14'h0013; dout[7:0] <= 8'h00; end
     15 : begin addr[13:0] <= 14'h0015; dout[7:0] <= 8'h00; end
     16 : begin addr[13:0] <= 14'h0025; dout[7:0] <= 8'h00; end
     17 : begin addr[13:0] <= 14'h0027; dout[7:0] <= 8'h00; end
     18 : begin addr[13:0] <= 14'h041D; dout[7:0] <= 8'h00; end
     19 : begin addr[13:0] <= 14'h0422; dout[7:0] <= 8'h00; end
     20 : begin addr[13:0] <= 14'h0434; dout[7:0] <= 8'h00; end
     21 : begin addr[13:0] <= 14'h0439; dout[7:0] <= 8'h00; end
     22 : begin addr[13:0] <= 14'h051D; dout[7:0] <= 8'h00; end
     23 : begin addr[13:0] <= 14'h0522; dout[7:0] <= 8'h00; end
     24 : begin addr[13:0] <= 14'h0534; dout[7:0] <= 8'h00; end
     25 : begin addr[13:0] <= 14'h0539; dout[7:0] <= 8'h00; end
     26 : begin addr[13:0] <= 14'h0608; dout[7:0] <= 8'h00; end
     27 : begin addr[13:0] <= 14'h070A; dout[7:0] <= 8'h00; end
     endcase
end
//
always @(posedge sclk)
begin
     case(spi_cnt)
     0  : begin sck <= 1; csn <= 1; mosi <= 0;        end
     1  : begin sck <= 0; csn <= 0; mosi <= 0;        end
     2  : begin sck <= 1; csn <= 0; mosi <= 0;        end
     3  : begin sck <= 0; csn <= 0; mosi <= 0;        end
     4  : begin sck <= 0; csn <= 0; mosi <= 1;        end
     5  : begin sck <= 1; csn <= 0; mosi <= 1;        end
     6  : begin sck <= 0; csn <= 0; mosi <= 1;        end
     7  : begin sck <= 0; csn <= 0; mosi <= addr[13]; end
     8  : begin sck <= 1; csn <= 0; mosi <= addr[13]; end
     9  : begin sck <= 0; csn <= 0; mosi <= addr[13]; end
     10 : begin sck <= 0; csn <= 0; mosi <= addr[12]; end
     11 : begin sck <= 1; csn <= 0; mosi <= addr[12]; end
     12 : begin sck <= 0; csn <= 0; mosi <= addr[12]; end
     13 : begin sck <= 0; csn <= 0; mosi <= addr[11]; end
     14 : begin sck <= 1; csn <= 0; mosi <= addr[11]; end
     15 : begin sck <= 0; csn <= 0; mosi <= addr[11]; end
     16 : begin sck <= 0; csn <= 0; mosi <= addr[10]; end
     17 : begin sck <= 1; csn <= 0; mosi <= addr[10]; end
     18 : begin sck <= 0; csn <= 0; mosi <= addr[10]; end
     19 : begin sck <= 0; csn <= 0; mosi <= addr[9];  end
     20 : begin sck <= 1; csn <= 0; mosi <= addr[9];  end
     21 : begin sck <= 0; csn <= 0; mosi <= addr[9];  end
     22 : begin sck <= 0; csn <= 0; mosi <= addr[8];  end
     23 : begin sck <= 1; csn <= 0; mosi <= addr[8];  end
     24 : begin sck <= 0; csn <= 0; mosi <= addr[8];  end
     25 : begin sck <= 0; csn <= 0; mosi <= addr[7];  end
     26 : begin sck <= 1; csn <= 0; mosi <= addr[7];  end
     27 : begin sck <= 0; csn <= 0; mosi <= addr[7];  end
     28 : begin sck <= 0; csn <= 0; mosi <= addr[6];  end
     29 : begin sck <= 1; csn <= 0; mosi <= addr[6];  end
     30 : begin sck <= 0; csn <= 0; mosi <= addr[6];  end
     31 : begin sck <= 0; csn <= 0; mosi <= addr[5];  end
     32 : begin sck <= 1; csn <= 0; mosi <= addr[5];  end
     33 : begin sck <= 0; csn <= 0; mosi <= addr[5];  end
     34 : begin sck <= 0; csn <= 0; mosi <= addr[4];  end
     35 : begin sck <= 1; csn <= 0; mosi <= addr[4];  end
     36 : begin sck <= 0; csn <= 0; mosi <= addr[4];  end
     37 : begin sck <= 0; csn <= 0; mosi <= addr[3];  end
     38 : begin sck <= 1; csn <= 0; mosi <= addr[3];  end
     39 : begin sck <= 0; csn <= 0; mosi <= addr[3];  end
     40 : begin sck <= 0; csn <= 0; mosi <= addr[2];  end
     41 : begin sck <= 1; csn <= 0; mosi <= addr[2];  end
     42 : begin sck <= 0; csn <= 0; mosi <= addr[2];  end
     43 : begin sck <= 0; csn <= 0; mosi <= addr[1];  end
     44 : begin sck <= 1; csn <= 0; mosi <= addr[1];  end
     45 : begin sck <= 0; csn <= 0; mosi <= addr[1];  end
     46 : begin sck <= 0; csn <= 0; mosi <= addr[0];  end
     47 : begin sck <= 1; csn <= 0; mosi <= addr[0];  end
     48 : begin sck <= 0; csn <= 0; mosi <= addr[0];  end
     49 : begin sck <= 0; csn <= 0; mosi <= dout[7];  end
     50 : begin sck <= 1; csn <= 0; mosi <= dout[7];  end
     51 : begin sck <= 0; csn <= 0; mosi <= dout[7];  end
     52 : begin sck <= 0; csn <= 0; mosi <= dout[6];  end
     53 : begin sck <= 1; csn <= 0; mosi <= dout[6];  end
     54 : begin sck <= 0; csn <= 0; mosi <= dout[6];  end
     55 : begin sck <= 0; csn <= 0; mosi <= dout[5];  end
     56 : begin sck <= 1; csn <= 0; mosi <= dout[5];  end
     57 : begin sck <= 0; csn <= 0; mosi <= dout[5];  end
     58 : begin sck <= 0; csn <= 0; mosi <= dout[4];  end
     59 : begin sck <= 1; csn <= 0; mosi <= dout[4];  end
     60 : begin sck <= 0; csn <= 0; mosi <= dout[4];  end
     61 : begin sck <= 0; csn <= 0; mosi <= dout[3];  end
     62 : begin sck <= 1; csn <= 0; mosi <= dout[3];  end
     63 : begin sck <= 0; csn <= 0; mosi <= dout[3];  end
     64 : begin sck <= 0; csn <= 0; mosi <= dout[2];  end
     65 : begin sck <= 1; csn <= 0; mosi <= dout[2];  end
     66 : begin sck <= 0; csn <= 0; mosi <= dout[2];  end
     67 : begin sck <= 0; csn <= 0; mosi <= dout[1];  end
     68 : begin sck <= 1; csn <= 0; mosi <= dout[1];  end
     69 : begin sck <= 0; csn <= 0; mosi <= dout[1];  end
     70 : begin sck <= 0; csn <= 0; mosi <= dout[0];  end
     71 : begin sck <= 1; csn <= 0; mosi <= dout[0];  end
     72 : begin sck <= 0; csn <= 0; mosi <= dout[0];  end
     endcase
end
//
assign adc_pdn[2:0] = 3'b000;
assign adc_rst[2:0] = 3'b000;
assign spi_sclk     = sck ;
assign spi_cs[0]    = ((spi_FSM==1)||(spi_FSM==2)||(spi_FSM==3)) ? csn : 1'b1 ;
assign spi_cs[1]    = ((spi_FSM==4)||(spi_FSM==5)||(spi_FSM==6)) ? csn : 1'b1 ;
assign spi_cs[2]    = ((spi_FSM==7)||(spi_FSM==8)||(spi_FSM==9)) ? csn : 1'b1 ;
assign spi_mosi     = mosi;
//
endmodule
