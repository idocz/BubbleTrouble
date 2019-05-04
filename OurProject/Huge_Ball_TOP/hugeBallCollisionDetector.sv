
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
					output	logic col_rope_mediumBall4
					
					//Small Balls
					
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


endmodule