


module collisionDetector	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	playerRequest, 
					
					input    logic col_player_ball1,
					input    logic col_rope_ball1,
					input 	logic [1:0] col_ball1_type,
					
					input    logic col_player_ball2,
					input    logic col_rope_ball2,
					input 	logic [1:0] col_ball2_type,
					
					input    logic col_player_ball3,
					input    logic col_rope_ball3,
					input 	logic [1:0] col_ball3_type,
					
					input 	logic col_present,
					input 	logic immortal,
					
					output	logic	col_player_ball,
					output   logic col_rope_ball,
					output 	logic [1:0] col_ball_type,
					output 	logic col_present_out
);



always_comb
begin

	col_rope_ball = 0;
	col_ball_type = 0;
	col_present_out = col_present;
	col_player_ball = col_player_ball1 || col_player_ball2 || col_player_ball3; //any collision of player with ball
	
	//collision of ball with rope
	if ( col_rope_ball1 )
	begin
		col_rope_ball = 1;
		col_ball_type = col_ball1_type;
	end
	else if ( col_rope_ball2 )
	begin
		col_rope_ball = 1;
		col_ball_type = col_ball2_type;
	end
	else if ( col_rope_ball3 )
		begin
		col_rope_ball = 1;
		col_ball_type = col_ball3_type;
	end
	
	
end


endmodule