


module collisionDetector	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	playerRequest, 
					input 	logic	ballRequest, 
					input    logic ropeRequest,
					
					output	logic	col_player_ball,
					output   logic col_rope_ball
);


assign col_player_ball = playerRequest & ballRequest;
assign col_rope_ball   = ropeRequest & ropeRequest;

endmodule