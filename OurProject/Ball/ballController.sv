// (c) Technion IIT, Department of Electrical Engineering 2018 
// Updated by Liat Schwartz March 2019 

// Implements a simple traffic lights controller
// by using state machine with present and next states wvf6

module  ballController (

	input logic clk, resetN,
	input logic unitActive,
	
	input logic col_player_hugeBall,
	input logic col_rope_hugeBall,
	
	input logic col_player_bigBall1,
	input logic col_rope_bigBall1,
	
	input logic col_player_bigBall2,
	input logic col_rope_bigBall2,

	
	//Visible
	output logic hugeBallVisible,
	output logic bigBall1Visible,
	output logic bigBall2Visible,
	output logic col_rope_ball,
	output logic col_player_ball
	
);
	
	
const int y_FRAME_SIZE =	479;
	
enum logic [1:0] {inactive, deploy, active} cur_st, nxt_st;


logic	nxt_hugeBallVisible;
logic	nxt_bigBall1Visible;
logic	nxt_bigBall2Visible;


always_ff @(posedge clk or negedge resetN) // State machine logic ////
   begin
	   
   if ( !resetN ) 
	begin // Asynchronic reset
	
		cur_st <= inactive;
		hugeBallVisible <= 0;
		bigBall1Visible <= 0;
		bigBall2Visible <= 0;
		
	end // asynch
	else 
	begin 				// Synchronic logic
	
		cur_st <= nxt_st; // Update current state
		hugeBallVisible <= nxt_hugeBallVisible;
		bigBall1Visible <= nxt_bigBall1Visible;
		bigBall2Visible <= nxt_bigBall2Visible;
		
	end 
		
end


	
always_comb // Update the next state  ////////////////////////////////
begin

		nxt_st = cur_st;	// Set default values
		
		case (cur_st)
					
			inactive: begin
			
				if ( unitActive )
					nxt_st = deploy;
						
			end // inactive
			
			
			deploy: begin
				nxt_st = active;
			
			end
			
			active: begin
			
				if ( unitActive == 1'b0 )
					nxt_st = inactive;
					
			end // active
					
		endcase

end // always next state ///////////////////////////////



always_comb // Update the outputs //////////////////////
  begin
	
	nxt_hugeBallVisible = hugeBallVisible;
	nxt_bigBall1Visible = bigBall1Visible;
	nxt_bigBall2Visible = bigBall2Visible;
	
	case (cur_st)
				
		inactive: begin
			nxt_hugeBallVisible = 0;
			nxt_bigBall1Visible = 0;
			nxt_bigBall2Visible = 0;
		end // inactive
							
		deploy: begin
			nxt_hugeBallVisible = 1;
			nxt_bigBall1Visible = 0;
			nxt_bigBall2Visible = 0;
		end
		
		active: begin
		
			if ( col_rope_hugeBall )
			begin
				nxt_hugeBallVisible = 0;
				nxt_bigBall1Visible = 1;
				nxt_bigBall2Visible = 1;
			end
			
			if ( col_rope_bigBall1 )
			begin
				nxt_bigBall1Visible = 0;
			end
			
			if ( col_rope_bigBall2 )
			begin
				nxt_bigBall2Visible = 0;
			end
			
		end // active
	
	endcase
end // always outputs //////////////////////////////
	
	
	
assign col_rope_ball = 	col_rope_hugeBall || col_rope_bigBall1 || col_rope_bigBall2;
assign col_player_ball = 	col_player_hugeBall || col_player_bigBall1 || col_player_bigBall2;

	
endmodule
