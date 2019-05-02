
module presentsCollisionDetector	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	playerRequest,
					input    logic present1Request,
					input    logic present2Request,
					input    logic present3Request,
					input    logic ropeRequest,
					
					output	logic	col_player_present1,
					output   logic col_rope_present1,
					
					output	logic	col_player_present2,
					output   logic col_rope_present2,
					
					output	logic	col_player_present3,
					output   logic col_rope_present3
);


assign col_player_present1 = playerRequest & present1Request;
assign col_rope_present1   = ropeRequest & present1Request;

assign col_player_present2 = playerRequest & present2Request;
assign col_rope_present2   = ropeRequest & present2Request;

assign col_player_present3 = playerRequest & present3Request;
assign col_rope_present3   = ropeRequest & present3Request;




endmodule