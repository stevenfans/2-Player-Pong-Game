`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:45:38 02/14/2018 
// Design Name: 
// Module Name:    AISO 
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
module AISO(clk, reset, reset_s );

	//signal declarations
	input wire clk, reset;
	output wire reset_s;
	
	reg [1:0] sync;
	
	assign reset_s = ~sync[0];
	
	// flop
	always @(posedge reset, posedge clk)
		if(reset) sync = 2'b0;
		else sync = {1'b1, sync[1]};

endmodule 
