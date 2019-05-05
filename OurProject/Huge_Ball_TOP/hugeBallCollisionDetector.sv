
module hugeBallCollisionDetector	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	playerRequest,
					
					input    logic hugeBallRequest,
					
					input    logic bigBall1Request,
					input    logic bigBall2Request,
					
					input 	logic mediumBall1Request,
					input 	logic mediumBall2Request,
					input 	logic mediumBall3Request,
					input 	logic mediumBall4Request,
					
					input 	logic smallBall1Request,
					input 	logic smallBall2Request,
					input 	logic smallBall3Request,
					input 	logic smallBall4Request,
					input 	logic smallBall5Request,
					input 	logic smallBall6Request,
					input 	logic smallBall7Request,
					input 	logic smallBall8Request,
					
					input    logic ropeRequest,
					
					// Huge Ball
					output	logic	col_player_hugeBall,
					output   logic col_rope_hugeBall,
					
					// Big Balls
					output	logic	col_player_bigBall1,
					output   logic col_rope_bigBall1,
					
					output	logic	col_player_bigBall2,
					output   logic col_rope_bigBall2,
					
					//Medium Balls
					
					output	logic col_player_mediumBall1,
					output	logic col_rope_mediumBall1,
					
					output	logic col_player_mediumBall2,
					output	logic col_rope_mediumBall2,
					
					output	logic col_player_mediumBall3,
					output	logic col_rope_mediumBall3,
					
					output	logic col_player_mediumBall4,
					output	logic col_rope_mediumBall4,
					
					//Small Balls
					output	logic col_player_smallBall1,
					output	logic col_rope_smallBall1,
					
					output	logic col_player_smallBall2,
					output	logic col_rope_smallBall2,
					
					output	logic col_player_smallBall3,
					output	logic col_rope_smallBall3,
					
					output	logic col_player_smallBall4,
					output	logic col_rope_smallBall4,
					
					output	logic col_player_smallBall5,
					output	logic col_rope_smallBall5,
					
					output	logic col_player_smallBall6,
					output	logic col_rope_smallBall6,
					
					output	logic col_player_smallBall7,
					output	logic col_rope_smallBall7,
					
					output	logic col_player_smallBall8,
					output	logic col_rope_smallBall8
					
);


//Huge Ball
assign col_player_hugeBall = playerRequest & hugeBallRequest;
assign col_rope_hugeBall   = ropeRequest & hugeBallRequest;


//Big Balls
assign col_player_bigBall1 = playerRequest & bigBall1Request;
assign col_rope_bigBall1   = ropeRequest & bigBall1Request;

assign col_player_bigBall2 = playerRequest & bigBall2Request;
assign col_rope_bigBall2   = ropeRequest & bigBall2Request;


//Medium Balls
assign col_player_mediumBall1 = playerRequest & mediumBall1Request;
assign col_rope_mediumBall1   = ropeRequest & mediumBall1Request;

assign col_player_mediumBall2 = playerRequest & mediumBall2Request;
assign col_rope_mediumBall2   = ropeRequest & mediumBall2Request;

assign col_player_mediumBall3 = playerRequest & mediumBall3Request;
assign col_rope_mediumBall3   = ropeRequest & mediumBall3Request;

assign col_player_mediumBall4 = playerRequest & mediumBall4Request;
assign col_rope_mediumBall4   = ropeRequest & mediumBall4Request;


//Small Balls
assign col_player_smallBall1 = playerRequest & smallBall1Request;
assign col_rope_smallBall1   = ropeRequest & smallBall1Request;

assign col_player_smallBall2 = playerRequest & smallBall2Request;
assign col_rope_smallBall2   = ropeRequest & smallBall2Request;

assign col_player_smallBall3 = playerRequest & smallBall3Request;
assign col_rope_smallBall3   = ropeRequest & smallBall3Request;

assign col_player_smallBall4 = playerRequest & smallBall4Request;
assign col_rope_smallBall4   = ropeRequest & smallBall4Request;

assign col_player_smallBall5 = playerRequest & smallBall5Request;
assign col_rope_smallBall5   = ropeRequest & smallBall5Request;

assign col_player_smallBall6 = playerRequest & smallBall6Request;
assign col_rope_smallBall6   = ropeRequest & smallBall6Request;

assign col_player_smallBall7 = playerRequest & smallBall7Request;
assign col_rope_smallBall7   = ropeRequest & smallBall7Request;

assign col_player_smallBall8 = playerRequest & smallBall8Request;
assign col_rope_smallBall8   = ropeRequest & smallBall8Request;



endmodule