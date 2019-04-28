


module collisionDetector	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	playerRequest, 
					input    logic col_player_ball1,
					input    logic col_rope_ball1,
					
					output	logic	col_player_ball1_out,
					output   logic col_rope_ball1_out
);


assign col_player_ball1_out = col_player_ball1;
assign col_rope_ball1_out   = col_rope_ball1;

endmodule