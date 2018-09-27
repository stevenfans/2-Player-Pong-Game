`timescale 1ns / 1ps
//========================================================================
// 	File name: <vga_sync.v>															//				
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
module vga_sync(clk, reset,
					 hsync, vsync
					, pixel_x, pixel_y, video_on
					 );
					 
	input clk, reset;
	
	output reg  [9:0] pixel_x, pixel_y;
	output hsync, vsync, video_on;
	
	wire v_scan_on, h_scan_on;	
	
	// GENERATE A 25MHZ TICK
	// now needed to generate a 40 ns clock
	reg [1:0] count;
	reg [1:0] n_count;
	wire tick;
	
	assign tick = (count == 3) ? 1'b1: 1'b0; //comparator
	
	// state
	always @ (posedge clk, posedge reset) //flop
		if(reset) count <= 2'b0; 
		else 	    count <= n_count;
		
	always @(*)
		n_count = (tick) ? 2'b0: count + 2'b1; //mux
//////////////////////////////////////////////////////////////
	//WIRES AND REGISTERS DECLARATIONS
	
	//Hsync and vsync  counters
	reg [9:0] H_count, nH_count;
	reg [9:0] V_count, nV_count;
	
	// registers for the syncs
	reg H_sync, V_sync;
	wire nV_sync, nH_sync;
	
	// register for the rgb
	reg [11:0] RGB;
	
	//  signal wires
	wire v_end, h_end, high_signal;
///////////////////////////////////////////////////////////////
	
	// registers
	always @(posedge clk, posedge reset)
		if(reset) begin
			 H_count <= 0;
			 V_count <= 0;
			 H_sync <= 0;
			 V_sync <= 0;
		end
	else
		begin
			 H_count <= nH_count;
			 V_count <= nV_count;
			 H_sync  <= nH_sync;
			 V_sync  <= nV_sync;
		end
	
	// assign the wires to be high or low singals
	assign high_signal = tick;
	
	//status sicnals  / COMPARATORS
	assign h_end = (H_count == 799) ? 1: 0;
	assign v_end = (V_count == 524) ? 1: 0;
	
	// -800 horizontal counter
	always @ (*)
		if(high_signal) //25 MHz
			if (h_end) nH_count = 1'b0;
				else 	  nH_count = H_count + 1'b1;
		else 
			nH_count = H_count;
	
	// 525 vertical counter
	always @ (*) 
		if(h_end & high_signal) // 25 MHz
			if (v_end) nV_count = 1'b0;
				else    nV_count = V_count + 1'b1;
		else
			nV_count = V_count;
			
	// horizontal and vertical sync
	assign nH_sync = (H_count >= 656 && 
							H_count <= 751);
	assign nV_sync = (V_count >= 490 && 
							V_count <= 491);
		
	// register for assigning the counters
	always @(posedge clk, posedge reset)
		if (reset) begin 
			pixel_x <= 10'b0;
			pixel_y <= 10'b0;
			end
		else begin
		pixel_x <= H_count;
		pixel_y <= V_count; 
		end
		
	// assign vert and horiz scan on
	assign h_scan_on = (0<= pixel_x &&  pixel_x < 640);
	assign v_scan_on = (0<= pixel_y &&  pixel_y < 480);
	
	// turn video on/off
	assign video_on = h_scan_on && v_scan_on;
		
	assign hsync   = ~H_sync;
	assign vsync   = ~V_sync; 

endmodule
