


module collisionDetector	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	playerRequest, 
					input 	logic	ballRequest, 
					
					output	logic	col_player_ball
);


assign col_player_ball = playerRequest & ballRequest;


endmodule