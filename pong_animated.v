`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:18:38 04/18/2018 
// Design Name: 
// Module Name:    pong_animated 
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
module pong_animated(clk, reset, sw, video_on, pixl_x, pixl_y, RGB,
							color_sw,  score1_counter, score2_counter,
							cheat);

	input  clk, reset, video_on, cheat;
	input [3:0] sw; 
	input [11:0] color_sw; 
	input [9:0] pixl_x, pixl_y;
	
	output [3:0] score1_counter, score2_counter;
	reg    [3:0] score1_counter, score2_counter;	
	
	output[11:0] RGB; 
	reg   [11:0] RGB;
	
	parameter velocityP = 3;
	
	wire restart, restart2; 
	// 60 Hz 
	// one tick every time screenm finishes
	wire tick_60Hz; 
	
	assign tick_60Hz = (pixl_x == 0 ) && (pixl_y == 481);
	
//***********************************************************
	parameter top_boundary    = 1,
				 bottom_boundary = 480, 
				 right_boundary  = 640;
//**********PADDLE UPDATES AND TURN ON HUEHUE*****************
// 
	parameter 	leftpaddle = 600,
					rightpaddle = 603,
					big_pad = 400;
					
	
	wire pad_on; 
	wire [11:0] pad_rgb;
	
	//register for the top of the paddle
	reg [9:0] paddle_top_reg, n_paddle_top_reg;
	wire [9:0] top_pad, bot_pad; 
	
	assign top_pad = paddle_top_reg; 
	assign bot_pad = top_pad + 71;

	//turning on the paddle
	assign pad_on = (leftpaddle <= pixl_x) && (pixl_x <= rightpaddle) &&
						 (top_pad <= pixl_y) && (pixl_y <= bot_pad);
	assign pad_rgb = 12'h0F0; //GREEN
	
	// upadating the y-axis of the paddle
	always @ (*)
	begin
		n_paddle_top_reg = paddle_top_reg;// paddles doesnt move
		
		if(tick_60Hz)
			if (sw[1] & (bot_pad < 480))  // down 
				n_paddle_top_reg = paddle_top_reg + velocityP;
			else if (sw[0] & (top_pad > 1 ))//velocityP))			// up
				n_paddle_top_reg = paddle_top_reg - velocityP;
	end
	//****************PLAYER 2 PADDLE CODE **********************
	parameter left_paddle_2 = 40,		
				 right_paddle_2 = 43; 
				 
	wire pad_on_2; 
	wire [11:0] pad_rgb_2; 
	// registers for the top of the 2nd paddle
	reg [9:0] paddle_top_reg_2, n_paddle_top_reg_2; 
	wire [9:0] top_pad_2, bot_pad_2; 
	
	assign top_pad_2 = paddle_top_reg_2; 
	assign bot_pad_2 = (cheat)? (top_pad_2 + big_pad) :
										 (top_pad_2 + 72 ); 
	
	//turning on the paddle 
	assign pad_on_2 = (left_paddle_2 <= pixl_x) && (pixl_x<= right_paddle_2) &&
							 (top_pad_2 <= pixl_y) && (pixl_y <= bot_pad_2); 
	assign pad_rgb_2 = 12'h0F0; 
	
		// upadating the y-axis of the paddle
	always @ (*)
	begin
		n_paddle_top_reg_2 = paddle_top_reg_2;// paddles doesnt move
		
		if(tick_60Hz)
			if (sw[3]  & (bot_pad_2 < 480))     // down 
				n_paddle_top_reg_2 = paddle_top_reg_2 + velocityP;
				
			else if (sw[2] & (top_pad_2 > 1 )) // up
				n_paddle_top_reg_2 = paddle_top_reg_2 - velocityP;
	end
	
//**************************************************************
//************BALL UPDATES AND TURNS ON BALL *******************
//**************************************************************
	//paramerter for the ball
	parameter 	ball_size =  8,
					pos_speed =  1,
					neg_speed = -1; 
	
	wire 			ball_on;
	wire [11:0] ball_rgb; 
	
	// registers for the boundries
	wire [9:0] top_ball, bot_ball;
	wire [9:0] left_ball, right_ball;
	
	// registers to track
	reg  [9:0]  ball_x_reg, ball_y_reg;
	wire [9:0]  n_ball_x_reg, n_ball_y_reg;
	// registers for speed change
	reg [9:0] delta_x,  delta_y; 
	reg [9:0] n_delta_x, n_delta_y; 
	
	// SET THE BOUNDRIES
	assign top_ball = ball_y_reg; 
	assign bot_ball = top_ball + ball_size -1;
	assign left_ball = ball_x_reg;
	assign right_ball = left_ball + ball_size - 1; 
	
	// turn the ball on 
	assign ball_on = (top_ball <= pixl_y)  && (pixl_y <= bot_ball) &&
						  (left_ball <= pixl_x) && (pixl_x <= right_ball); 
	assign ball_rgb = 12'hF00; // BLUE	
	
	// assign the new positions to the registers
	assign n_ball_x_reg = (tick_60Hz) ? (ball_x_reg + delta_x) : ball_x_reg; 
	assign n_ball_y_reg = (tick_60Hz) ? (ball_y_reg + delta_y) : ball_y_reg; 
	
	// changing the velocity
	always @ (*)  
		begin
			n_delta_x = delta_x; // no chance
			n_delta_y = delta_y; 
			
			if (top_ball <= 1 ) //when the ball hits the top
				n_delta_y = pos_speed; // positive y
				
			else if (bot_ball >= 479) // when the ball hits the bottom
				n_delta_y = neg_speed; //negative y
				
		// ball hitting the left paddle
			else if ((right_paddle_2 > left_ball) && (left_ball> left_paddle_2) &&
						(top_pad_2 <= bot_ball) && (top_ball <= bot_pad_2))
				n_delta_x = pos_speed;
			
			// ball hitting the right paddle
			else if ((600 <= right_ball)  && (right_ball <= 603) &&
						(top_pad <= bot_ball) && (top_ball <= bot_pad))
				n_delta_x = neg_speed; 	
			
			end
	
	//***************************************************
	// everytime the ball hits the rightside of the ball
	assign restart  = (right_ball==639) ? 1'b1 : 1'b0;
	assign restart2 = (left_ball == 1 ) ? 1'b1 : 1'b0; 
 	always @(posedge clk)
		if (reset) 
			begin
					score1_counter <= 0; 
					score2_counter <= 0;
			end
		else if (restart) 
			score1_counter <= score1_counter + 1'b1; 
		else if (restart2)
			score2_counter <= score2_counter + 1'b1; 

//**************************************************************************
	
// FLIPITPY FLOP FLOP
	always @ ( posedge clk, posedge reset)
		if(reset)
			begin
				paddle_top_reg <= 220;
				paddle_top_reg_2 <= 220; 
				ball_x_reg 		<= 36;
				ball_y_reg 		<= 0;
				delta_x 			<= 1;
				delta_y 			<= 1;			
			end 	
	else if (restart)
		 begin
				paddle_top_reg <= n_paddle_top_reg;
				paddle_top_reg_2 <= n_paddle_top_reg_2;				
				ball_x_reg 		<= 36;
				ball_y_reg 		<= 0;
				delta_x 			<= 1;
				delta_y 			<= 1;			
			end
			
	else if (restart2)
		 begin
				paddle_top_reg <= n_paddle_top_reg;
				paddle_top_reg_2 <= n_paddle_top_reg_2;				
				ball_x_reg 		<= 444;
				ball_y_reg 		<= 0;
				delta_x 			<= -1;
				delta_y 			<= -1;			
			end
		else 
			begin
				paddle_top_reg <= n_paddle_top_reg;
				paddle_top_reg_2 <= n_paddle_top_reg_2;
				ball_x_reg 		<= n_ball_x_reg;
				ball_y_reg 		<= n_ball_y_reg;
				delta_x 		   <= n_delta_x;
				delta_y    		<= n_delta_y; 
			end 
			
/****************************************************************************/
//**********************MULTIPLEXER CIRCUIT***********************************/
//****************************************************************************/
	always @(*)
	if (~video_on)
		RGB = 12'h000; //blank wall
	else 
		if (pad_on_2)
			RGB = pad_rgb_2; 
		else if (pad_on)
			RGB = pad_rgb;
		else if (ball_on)
			RGB = ball_rgb; 
		else 
			RGB = color_sw; 
	
endmodule