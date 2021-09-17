`timescale 1ns / 1ps
/* ------------------------------------------------ *
 * Title       : CRC32 Testbench                    *
 * Project     : Sequential CRC Generators          *
 * ------------------------------------------------ *
 * File        : testbench_32b.v                    *
 * Author      : Yigit Suoglu                       *
 * Last Edit   : 17/05/2021                         *
 * ------------------------------------------------ *
 * Description : Simulation testbench for the crc   *
 *               modules, 32 bit crc                *
 * ------------------------------------------------ */
`include "Sources/crc.v"
`include "Common/parallel_to_serial.v"

module tb(); // CRC-32/POSIX 
  localparam CRC_SIZE = 32, //Size of CRC value, all following parameters should have this size
           INITAL_VAL = 32'h00000000, //Initial value for CRC reg
             CRC_POLY = 32'h04C11DB7 , //Polynomial for crc calculation
            FINAL_XOR = 32'hFFFFFFFF;
  reg clk, rst, start;
  reg [127:0] data;
  wire enable, serial;
  wire [CRC_SIZE-1:0] crc_s, crc_d;
  integer f, i;
  reg dummy;

  parallel_to_serial #(128,1) data_conv(clk,rst,start,data,serial,enable);

  crc_static  #(CRC_SIZE,INITAL_VAL,CRC_POLY,FINAL_XOR) uut_s(clk,rst,serial,enable,crc_s);
  crc_dynamic #(CRC_SIZE) uut_d(clk,rst,serial,enable,crc_d,INITAL_VAL,CRC_POLY, FINAL_XOR);

  //Generate clock
  always begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //Send reset
  initial begin
    rst <= 0;
    #3
    rst <= 1;
    #10
    rst <= 0;
  end

  initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, clk);
    $dumpvars(1, rst);
    $dumpvars(2, start);
    $dumpvars(3, serial);
    $dumpvars(4, enable);
    $dumpvars(5, crc_s);
    $dumpvars(6, crc_d);
    $dumpvars(7, data);
  end

  initial begin
    f = $fopen("output.tmp.txt","w");
    start = 0;
    data = {128{1'b1}};
    #10
    start = 1;
    $fwrite(f,"%h\n",data);
    #10
    start = 0;
    while (enable == 1) begin
      #10 dummy = 1;
    end
    #30
    data = 128'h0;
    rst = 1;
    #10
    rst = 0;
    start = 1;
    $fwrite(f,"%h\n",data);
    #10
    start = 0;
    while (enable == 1) begin
      #10 dummy = 1;
    end
    for(i = 0; i < 5; i=i+1)
    begin
      #30
      data = {$random,$random,$random,$random};
      rst = 1;
      #10
      rst = 0;
      start = 1;
      $fwrite(f,"%h\n",data);
      #10
      start = 0;
      while (enable == 1) begin
        #10 dummy = 1;
      end
    end
    #30
    $fclose(f); 
    $finish;
  end
  
endmodule
