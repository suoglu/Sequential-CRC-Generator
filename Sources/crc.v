`timescale 1ns / 1ps
/* ------------------------------------------------ *
 * Title       : Sequential CRC Generators          *
 * Project     : Sequential CRC Generators          *
 * ------------------------------------------------ *
 * File        : crc.v                              *
 * Author      : Yigit Suoglu                       *
 * Last Edit   : 16/05/2021                         *
 * ------------------------------------------------ *
 * Description : Modules for generating crc values  *
 * ------------------------------------------------ *
 * Revisions                                        *
 *     v1      : Inital version                     *
 * ------------------------------------------------ */

//Calcuates crc values for only one configuration
module crc_static#(
  parameter CRC_SIZE = 16, //Size of CRC value, all following parameters should have this size
  parameter INITAL_VAL = 16'hFFFF, //Initial value for CRC reg
  parameter CRC_POLY = 16'h1021, //Polynomial for crc calculation
  parameter FINAL_XOR = 16'h0 //xor for the calculated crc16 result 
)(
  input clk,
  input rst, //or clear
  input data, //data input to crc calculation
  input valid, //data is a valid value
  output [CRC_SIZE-1:0] crc_out //calculated crc value
);
  integer i;
  reg [CRC_SIZE-1:0] crcBuffer;
  reg [CRC_SIZE-1:0] crcBuffer_next;
  wire nextBit; //Next bit for crc calculations


  //Handle crc calculation
  always@(posedge clk) begin
    if(rst) begin
      crcBuffer <= INITAL_VAL;
    end else begin
      crcBuffer <= (valid) ? crcBuffer_next : crcBuffer;
    end
  end

 
  assign nextBit = data ^ crcBuffer[CRC_SIZE-1];
  always@* begin
    crcBuffer_next[0] = nextBit;
    for(i = 1; i < CRC_SIZE; i=i+1) begin
      crcBuffer_next[i] = crcBuffer[i-1] ^ (nextBit & CRC_POLY[i]);
    end
  end


  //Apply final xor if needed
  assign crc_out = crcBuffer ^ FINAL_XOR;
endmodule


//crc configurations can be change in use
module crc_dynamic#(
  parameter CRC_SIZE = 16 //Size of CRC value, all following parameters should have this size
)(
  input clk,
  input rst, //or clear
  input data, //data input to crc calculation
  input valid, //data is a valid value
  output [CRC_SIZE-1:0] crc_out, //calculated crc value
  //Configurations
  input [CRC_SIZE-1:0] initial_value,
  input [CRC_SIZE-1:0] crc_poly,
  input [CRC_SIZE-1:0] final_xor
);
  integer i;
  reg [CRC_SIZE-1:0] crcBuffer;
  reg [CRC_SIZE-1:0] crcBuffer_next;
  wire nextBit; //Next bit for crc calculations


  //Handle crc calculation
  always@(posedge clk) begin
    if(rst) begin
      crcBuffer <= initial_value;
    end else begin
      crcBuffer <= (valid) ? crcBuffer_next : crcBuffer;
    end
  end

 
  assign nextBit = data ^ crcBuffer[CRC_SIZE-1];
  always@* begin
    crcBuffer_next[0] = nextBit;
    for(i = 1; i < CRC_SIZE; i=i+1) begin
      crcBuffer_next[i] = crcBuffer[i-1] ^ (nextBit & crc_poly[i]);
    end
  end


  //Apply final xor if needed
  assign crc_out = crcBuffer ^ final_xor;
endmodule
