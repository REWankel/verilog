module ADV7123_NTSC_colorbar (
    input            sclk,     // 100MHz
    input            rst_n,
    output reg [9:0] red,
    output reg [9:0] green,
    output reg [9:0] blue,
    output reg       blank_n,  // to ADV7123 BLANK_N
    output reg       sync_n    // to ADV7123 SYNC_N
);
////////////////////////////////////////////////////////////////
parameter H_TOTAL = 6360;//63.6us * 100MHz = 6360
parameter V_TOTAL = 525; //525 line
////////////////////////////////////////////////////////////////
reg [11:0] h_cnt;
reg  [9:0] v_cnt;
////////////////////////////////////////////////////////////////
always @(posedge sclk or negedge rst_n) 
begin
     if (!rst_n)
        h_cnt <= 0;
     else if (h_cnt == H_TOTAL-1)
        h_cnt <= 0;
     else
        h_cnt <= h_cnt + 1;
end
////////////////////////////////////////////////////////////////
always @(posedge sclk or negedge rst_n) 
begin
     if (!rst_n)
        v_cnt <= 0;
     else if (h_cnt == H_TOTAL-1) 
     begin
        if (v_cnt == V_TOTAL-1)
           v_cnt <= 0;
        else
           v_cnt <= v_cnt + 1;
     end
end
////////////////////////////////////////////////////////////////
always @(posedge sclk or negedge rst_n) 
begin
     if (!rst_n)
     begin
          /*SYNC  Level*/
//                                                           blank_n <= 1'b0; sync_n <= 1'b0; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; // Black
          /*BLANK Level*/
                                                             blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; // Black
	 end
     /*Equalizing Pulses*/
     else if (((v_cnt >=   1-1)&&(  3-1 >= v_cnt))||  //line #  1~#  3
              ((v_cnt >=   7-1)&&(  9-1 >= v_cnt))||  //line #  7~#  9
              ((v_cnt >= 264-1)&&(265-1 >= v_cnt))||  //line #264~#265
              ((v_cnt >= 270-1)&&(271-1 >= v_cnt)))   //line #270~#271
     begin
          /*SYNC  Level*/
          if      ((h_cnt >=    0)&&( 230-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b0; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >=  230)&&(3180-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*SYNC  Level*/
          else if ((h_cnt >= 3180)&&(3410-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b0; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >= 3410)&&(6360-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
     end
     /*Serration Pulses*/
     else if (((v_cnt >=   4-1)&&(  6-1 >= v_cnt))||  //line #  4~#  6
	            ((v_cnt >= 267-1)&&(268-1 >= v_cnt)))   //line #267~#268
     begin
          /*SYNC  Level*/
          if      ((h_cnt >=    0)&&(2730-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b0; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >= 2730)&&(3180-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*SYNC  Level*/
          else if ((h_cnt >= 3180)&&(5910-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b0; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >= 5910)&&(6360-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
     end
     /*Blanked Video*/
     else if (((v_cnt >=  10-1)&&( 20-1 >= v_cnt))||  //line # 10~# 20
              ((v_cnt >= 273-1)&&(282-1 >= v_cnt)))   //line #273~#282
     begin
          /*SYNC  Level*/
          if      ((h_cnt >=    0)&&( 470-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b0; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >=  470)&&(6360-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          end
     /*Normal Video*/
     else if (((v_cnt >=  21-1)&&(262-1 >= v_cnt))||  //line # 21~#262
              ((v_cnt >= 284-1)&&(525-1 >= v_cnt)))   //line #284~#525
     begin
          /*SYNC  Level*/
          if      ((h_cnt >=    0)&&( 470-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b0; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >=  470)&&(1090-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*Active Video*/
          else if ((h_cnt >= 1090)&&(1730-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b1}}; green <= {10{1'b1}}; blue <= {10{1'b1}}; end // White
          else if ((h_cnt >= 1730)&&(2370-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b1}}; green <= {10{1'b1}}; blue <= {10{1'b0}}; end // Yellow
          else if ((h_cnt >= 2370)&&(3010-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b1}}; blue <= {10{1'b1}}; end // Cyan
          else if ((h_cnt >= 3010)&&(3650-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b1}}; blue <= {10{1'b0}}; end // Green
          else if ((h_cnt >= 3650)&&(4290-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b1}}; green <= {10{1'b0}}; blue <= {10{1'b1}}; end // Magenta
          else if ((h_cnt >= 4290)&&(4930-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b1}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Red
          else if ((h_cnt >= 4930)&&(5570-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b1}}; end // Blue
          else if ((h_cnt >= 5570)&&(6210-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >= 6210)&&(6360-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
     end
     /*Special case*/
     else if  (v_cnt == 263-1)                        //line #263
     begin
          /*SYNC  Level*/
          if      ((h_cnt >=    0)&&( 470-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b0; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >=  470)&&(1090-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*Active Video*/
          else if ((h_cnt >= 1090)&&(1730-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b1}}; green <= {10{1'b1}}; blue <= {10{1'b1}}; end // White
          else if ((h_cnt >= 1730)&&(2370-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b1}}; green <= {10{1'b1}}; blue <= {10{1'b0}}; end // Yellow
          else if ((h_cnt >= 2370)&&(3010-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b1}}; blue <= {10{1'b1}}; end // Cyan
          else if ((h_cnt >= 3010)&&(3180-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b1}}; blue <= {10{1'b0}}; end // Green
          /*SYNC  Level*/
          else if ((h_cnt >= 3180)&&(3410-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b0; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >= 3410)&&(6360-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
     end
     /*Special case*/
     else if  (v_cnt == 266-1)                        //line #266
     begin
          /*SYNC  Level*/
          if      ((h_cnt >=    0)&&( 230-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b0; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >=  230)&&(3180-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*SYNC  Level*/
          else if ((h_cnt >= 3180)&&(5910-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b0; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >= 5910)&&(6360-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
     end
     /*Special case*/
     else if  (v_cnt == 269-1)                        //line #269
     begin
          /*SYNC  Level*/
          if      ((h_cnt >=    0)&&(2730-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b0; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >= 2730)&&(3180-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*SYNC  Level*/
          else if ((h_cnt >= 3180)&&(3410-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b0; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >= 3410)&&(6360-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
     end
     /*Special case*/
     else if  (v_cnt == 272-1)                        //line #272
     begin
          /*SYNC  Level*/
          if      ((h_cnt >=    0)&&( 230-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b0; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >=  230)&&(6360-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
     end
     /*Special case*/
     else if  (v_cnt == 283-1)                        //line #283
     begin
          /*SYNC  Level*/
          if      ((h_cnt >=    0)&&( 470-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b0; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >=  470)&&(3180-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*Active Video*/
          else if ((h_cnt >= 3180)&&(3650-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b1}}; blue <= {10{1'b0}}; end // Green
          else if ((h_cnt >= 3650)&&(4290-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b1}}; green <= {10{1'b0}}; blue <= {10{1'b1}}; end // Magenta
          else if ((h_cnt >= 4290)&&(4930-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b1}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Red
          else if ((h_cnt >= 4930)&&(5570-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b1}}; end // Blue
          else if ((h_cnt >= 5570)&&(6210-1 >= h_cnt)) begin blank_n <= 1'b1; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
          /*BLANK Level*/
          else if ((h_cnt >= 6210)&&(6360-1 >= h_cnt)) begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
     end
     /*Other condition*/
     else                                              begin blank_n <= 1'b0; sync_n <= 1'b1; red <= {10{1'b0}}; green <= {10{1'b0}}; blue <= {10{1'b0}}; end // Black
////////////////////////////////////////////////////////////////
end
////////////////////////////////////////////////////////////////
endmodule
////////////////////////////////////////////////////////////////
