`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:11:29 04/23/2018 
// Design Name: 
// Module Name:    Pong_Finished 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Pong_Finished(clk, reset, button,switch, hsync, vsync, RGB,
							D0, D1, D2, D3, D4, D5, D6, D7, anodes, 
							hex_out, cheat);
						
	input 		  clk, reset,cheat;
	input  [3:0]  button; 
	input  [11:0] switch;
	input 		  D0, D1, D2, D3, D4, D5, D6, D7; 
	output [7:0] anodes;
	output [6:0] hex_out; 
	output 		 hsync, vsync; 
	output [11:0] RGB;
	
	// wires and registers
	wire [9:0] pix_x, pix_y;
	wire on_vid;
	reg [11:0] ps_rgb;
   wire [11:0]	ns_rgb;
	wire [3:0] counter, counter2; 
	
	vga_sync syncrhonization(.clk(clk), .reset(reset),
									 .hsync(hsync), .vsync(vsync),
									 .pixel_x(pix_x), .pixel_y(pix_y), 
									 .video_on(on_vid)
									 );

    pong_animated animate_me (.clk(clk),  .reset(reset), 
									  .sw(button),.video_on(on_vid), 
									  .pixl_x(pix_x), .pixl_y(pix_y),
									  .RGB(ns_rgb),
									  .color_sw(switch),
									  .score1_counter(counter),
									  .score2_counter(counter2),
									  .cheat(cheat)
									  );					 

 Display_controller display (.clk(clk), .reset(reset), 
									 .d0(counter2), .d1(4'b0), .d2(4'b0), 
									 .d3(4'b0), .d4(counter),.d5(4'b0), 
									 .d6(4'b0), .d7(4'b0), 
									 .anodes(anodes), 
								    .hex_out(hex_out)
									 ); 

	//rgb buffer registers
	always @(posedge clk, posedge reset)
		if (reset) ps_rgb <= 12'hFFF;
		else ps_rgb <= ns_rgb;

	 assign RGB = ps_rgb;
	 
endmodule
