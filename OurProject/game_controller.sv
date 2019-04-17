


module game_controller	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	drawing_request_1, 
					input 	logic	drawing_request_2, 
					
					output	logic	collision
);


assign collision = drawing_request_1 & drawing_request_2;


endmodule