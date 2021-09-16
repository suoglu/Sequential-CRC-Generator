`timescale 1ns / 1ps
/* ------------------------------------------------ *
 * Title       : CRC Testbench                      *
 * Project     : Sequential CRC Generators          *
 * ------------------------------------------------ *
 * File        : testbench.v                        *
 * Author      : Yigit Suoglu                       *
 * Last Edit   : 16/05/2021                         *
 * ------------------------------------------------ *
 * Description : Simulation testbench for the crc   *
 *               modules                            *
 * ------------------------------------------------ */
`include "Sources/crc.v"
`include "Common/parallel_to_serial.v"

module tb();
  reg clk, rst, start;
  reg [127:0] data;
  wire enable, serial;
  wire [31:0] crc_s, crc_d;
  integer f;

  parallel_to_serial #(128,1) data_conv(clk,rst,start,data,serial,enable);

  crc_static  #(32,32'h0,32'h04C11DB7,32'hFFFFFFFF) uut_s(clk,rst,serial,enable,crc_s);
  crc_dynamic #(32) uut_d(clk,rst,serial,enable,crc_d,32'h0,32'h04C11DB7, 32'hFFFFFFFF);

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
    #2500
    $finish;
  end

  initial begin
    f = $fopen("output.tmp.txt","w");
    start = 0;
    data = 128'h73713cb13141af131d313d3231398810;
    #10
    start = 1;
    $fwrite(f,"%h\n",data);
    #10
    start = 0;
    $fclose(f); 
  end
  
endmodule
