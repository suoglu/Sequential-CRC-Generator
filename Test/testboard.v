`timescale 1ns / 1ps
/* ------------------------------------------------ *
 * Title       : CRC16 Testboard                    *
 * Project     : Sequential CRC Generators          *
 * ------------------------------------------------ *
 * File        : testboard.v                        *
 * Author      : Yigit Suoglu                       *
 * Last Edit   : 17/05/2021                         *
 * ------------------------------------------------ *
 * Description : Tester module for CRC generators   *
 * ------------------------------------------------ */

module testboard(
  input clk,
  input rst,
  input RsRx,
  output [1:0] led,
  output [3:0] an,
  output [6:0] seg);
  wire [15:0] crc1, crc0;
  wire uart_en, clk_uart, uart_newdata;
  wire [7:0] uart_data;
  wire serial, serial_working;
  assign led[1] = crc1 != crc0;
  assign led[0] = serial_working;

  parallel_to_serial serialier(clk,rst,uart_newdata,uart_data,serial,serial_working);
  
  uart_clk_gen uart_clk(clk,rst,uart_en,clk_uart, 1'b1, 3'd2);
  uart_rx uart_core(clk,rst,RsRx,clk_uart,uart_en,1'b1,1'b0,2'd0,uart_data,,,uart_newdata);

  ssdController4 ssd_cntrl(clk, rst, 4'b1111, crc0[15:12], crc0[11:8], crc0[7:4], crc0[3:0], seg, an);

  localparam CRC_SIZE = 16, //Size of CRC value, all following parameters should have this size
           INITAL_VAL = 16'hFFFF, //Initial value for CRC reg
             CRC_POLY = 16'h1021, //Polynomial for crc calculation
            FINAL_XOR = 16'h0;

  crc_static  #(CRC_SIZE,INITAL_VAL,CRC_POLY,FINAL_XOR) uut_s(clk,rst,serial,serial_working,crc0);
  crc_dynamic #(CRC_SIZE) uut_d(clk,rst,serial,serial_working,crc1,INITAL_VAL,CRC_POLY, FINAL_XOR);
endmodule
