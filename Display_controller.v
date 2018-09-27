`timescale 1ns / 1ps
//========================================================================
// 	File name: <Display_controller.v>											//
//																								//	
// 	Created by Steven Phan on 2/14/18											//
//		Copyright 2018 Steven Phan. All rights reserved.						//
//																								//
//																								//
//		In submitting this file for class work at CSULB							//	
//		I am confirming that this is my work and the work						//	
// 	of no one else. In subinmitting this code I acknowledge that		//
//		plagiarism in student project work is subject to dismissal 			//
// 	from the class.																	//
//========================================================================
module Display_controller(clk, reset, d0, d1, d2, d3, d4, d5, d6, d7, anodes, 
								 hex_out);
		
		// signal declarations
		input clk, reset;
		input  [3:0] d0, d1, d2, d3, d4, d5, d6, d7;

		output [6:0] hex_out; 
		output [7:0] anodes;
		wire   [3:0] y;// hex decoder

		wire		  ticking;
		wire [2:0] select;


		//pxl clk
		Pixel_clk	ld_clk(.clk_in(clk), .reset(reset),.tick(ticking));

		// pix controller
		Pixel_controller led_controller(.clk(clk), .reset(reset), .anodes(anodes), 
												  .select(select),.tick (ticking));

		// mux
		ad_mux     mux(.d0(d0), .d1(d1), .d2(d2), .d3(d3),.d4(d4), 
								.d5(d5), .d6(d6), .d7(d7), .sel(select),  .y(y));
		// 7 seg
		hex_to_7seg	seg(.state(y), .hex_out(hex_out));


endmodule
