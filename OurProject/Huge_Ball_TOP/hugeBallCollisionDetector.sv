
module hugeBallCollisionDetector	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	playerRequest,
					input    logic hugeBallRequest,
					input    logic bigBall1Request,
					input    logic bigBall2Request,
					input    logic ropeRequest,
					
					output	logic	col_player_hugeBall,
					output   logic col_rope_hugeBall,
					
					output	logic	col_player_bigBall1,
					output   logic col_rope_bigBall1,
					
					output	logic	col_player_bigBall2,
					output   logic col_rope_bigBall2
);


assign col_player_hugeBall = playerRequest & hugeBallRequest;
assign col_rope_hugeBall   = ropeRequest & hugeBallRequest;

assign col_player_bigBall1 = playerRequest & bigBall1Request;
assign col_rope_bigBall1   = ropeRequest & bigBall1Request;

assign col_player_bigBall2 = playerRequest & bigBall2Request;
assign col_rope_bigBall2   = ropeRequest & bigBall2Request;




endmodule