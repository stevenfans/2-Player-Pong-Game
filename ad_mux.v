`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//Author:	Cody Hang-Ming Huang
//Email:		codyhuang12406@gmail.com
//Filename:	ad_mux.v
//Date:		March 10, 2017
//Version:	1.1	
//Notes:		Fixed syntax errors
//Purpose:  This is a 4 to 1 mux multiplexing the 4bit inputs which are (D) and
//				outputs a Y which send the signal to the hex to 7 decoder.
//
//////////////////////////////////////////////////////////////////////////////////
module ad_mux(D0, D1, D2, D3, D4, D5, D6, D7, select, Y);
input  [ 3:0] D0;
input  [ 3:0] D1;
input  [ 3:0] D2;
input  [ 3:0] D3;
input  [ 3:0] D4;
input  [ 3:0] D5;
input  [ 3:0] D6;
input  [ 3:0] D7;
input  [ 2:0] select;

output reg [ 3:0] Y;

//takes in the 4bit states and outputs as(y) to the hex-7 decoder
always @ *
	case(select)
		3'b000:  Y = D0;
		3'b001:  Y = D1;
		3'b010:  Y = D2;
		3'b011:  Y = D3;
		3'b100:  Y = D4;
		3'b101:  Y = D5;
		3'b110:  Y = D6;
		3'b111:  Y = D7;
		default: Y = D0;
	endcase 
	


endmodule
