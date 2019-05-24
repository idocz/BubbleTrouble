// (c) Technion IIT, Department of Electrical Engineering 2018 
// Updated by Liat Schwartz March 2019 

// Implements a simple traffic lights controller
// by using state machine with present and next states wvf6

module  ballController (

	input logic clk, resetN,
	input logic unitActive,
	input logic [1:0] initialState,
	
	//Huge Ball
	input logic col_player_hugeBall,
	input logic col_rope_hugeBall,
	
	//Big Balls
	input logic col_player_bigBall1,
	input logic col_rope_bigBall1,
	input logic col_player_bigBall2,
	input logic col_rope_bigBall2,
	
	//Medium Balls
	input logic col_player_mediumBall1,
	input logic col_rope_mediumBall1,
	input logic col_player_mediumBall2,
	input logic col_rope_mediumBall2,
	input logic col_player_mediumBall3,
	input logic col_rope_mediumBall3,
	input logic col_player_mediumBall4,
	input logic col_rope_mediumBall4,
	
	//Small Balls
	input logic col_player_smallBall1,
	input logic col_rope_smallBall1,
	input logic col_player_smallBall2,
	input logic col_rope_smallBall2,
	input logic col_player_smallBall3,
	input logic col_rope_smallBall3,
	input logic col_player_smallBall4,
	input logic col_rope_smallBall4,
	input logic col_player_smallBall5,
	input logic col_rope_smallBall5,
	input logic col_player_smallBall6,
	input logic col_rope_smallBall6,
	input logic col_player_smallBall7,
	input logic col_rope_smallBall7,
	input logic col_player_smallBall8,
	input logic col_rope_smallBall8,

	
	//Visible
	output logic hugeBallVisible,
	
	output logic bigBall1Visible,
	output logic bigBall2Visible,
	
	output logic mediumBall1Visible,
	output logic mediumBall2Visible,
	output logic mediumBall3Visible,
	output logic mediumBall4Visible,
	
	output logic smallBall1Visible,
	output logic smallBall2Visible,
	output logic smallBall3Visible,
	output logic smallBall4Visible,
	output logic smallBall5Visible,
	output logic smallBall6Visible,
	output logic smallBall7Visible,
	output logic smallBall8Visible,
	

	//reset
	output logic hugeBallReset,
	
	output logic bigBall1Reset,
	output logic bigBall2Reset,
	
	output logic mediumBall1Reset,
	output logic mediumBall2Reset,
	output logic mediumBall3Reset,
	output logic mediumBall4Reset,
	
	output logic smallBall1Reset,
	output logic smallBall2Reset,
	output logic smallBall3Reset,
	output logic smallBall4Reset,
	output logic smallBall5Reset,
	output logic smallBall6Reset,
	output logic smallBall7Reset,
	output logic smallBall8Reset,
	
	output logic col_rope_ball,
	output logic [1:0] col_ball_type,
	output logic col_player_ball,
	output logic inUse
	
	
);
	
	
const int y_FRAME_SIZE =	479;
	
enum logic [1:0] {inactive, deploy, active} cur_st, nxt_st;

logic nxt_inUse;

logic	nxt_hugeBallVisible;
logic	nxt_bigBall1Visible;
logic	nxt_bigBall2Visible;
logic	nxt_mediumBall1Visible;
logic	nxt_mediumBall2Visible;
logic	nxt_mediumBall3Visible;
logic	nxt_mediumBall4Visible;
logic	nxt_smallBall1Visible;
logic	nxt_smallBall2Visible;
logic	nxt_smallBall3Visible;
logic	nxt_smallBall4Visible;
logic	nxt_smallBall5Visible;
logic	nxt_smallBall6Visible;
logic	nxt_smallBall7Visible;
logic	nxt_smallBall8Visible;


logic	nxt_hugeBallReset;
logic	nxt_bigBall1Reset;
logic	nxt_bigBall2Reset;
logic	nxt_mediumBall1Reset;
logic	nxt_mediumBall2Reset;
logic	nxt_mediumBall3Reset;
logic	nxt_mediumBall4Reset;
logic	nxt_smallBall1Reset;
logic	nxt_smallBall2Reset;
logic	nxt_smallBall3Reset;
logic	nxt_smallBall4Reset;
logic	nxt_smallBall5Reset;
logic	nxt_smallBall6Reset;
logic	nxt_smallBall7Reset;
logic	nxt_smallBall8Reset;


always_ff @(posedge clk or negedge resetN) // State machine logic ////
   begin
	   
   if ( !resetN ) 
	begin // Asynchronic reset
	
		cur_st <= inactive;
		inUse <= 0;
		
		//Huge Ball
		hugeBallVisible <= 0;
		//Big Balls
		bigBall1Visible <= 0;
		bigBall2Visible <= 0;
		//Medium Balls
		mediumBall1Visible <= 0;
		mediumBall2Visible <= 0;
		mediumBall3Visible <= 0;
		mediumBall4Visible <= 0;
		//Small Balls
		smallBall1Visible <= 0;
		smallBall2Visible <= 0;
		smallBall3Visible <= 0;
		smallBall4Visible <= 0;
		smallBall5Visible <= 0;
		smallBall6Visible <= 0;
		smallBall7Visible <= 0;
		smallBall8Visible <= 0;
		
		//Huge Ball
		hugeBallReset <= 0;
		//Big Balls
		bigBall1Reset <= 0;
		bigBall2Reset <= 0;
		//Medium Balls
		mediumBall1Reset <= 0;
		mediumBall2Reset <= 0;
		mediumBall3Reset <= 0;
		mediumBall4Reset <= 0;
		smallBall1Reset <= 0;
		smallBall2Reset <= 0;
		smallBall3Reset <= 0;
		smallBall4Reset <= 0;
		smallBall5Reset <= 0;
		smallBall6Reset <= 0;
		smallBall7Reset <= 0;
		smallBall8Reset <= 0;

		
	end // asynch
	else 
	begin 				// Synchronic logic
	
		cur_st <= nxt_st; // Update current state
		inUse <= nxt_inUse;
		
		//Huge Ball
		hugeBallVisible <= nxt_hugeBallVisible;
		//Big Balls
		bigBall1Visible <= nxt_bigBall1Visible;
		bigBall2Visible <= nxt_bigBall2Visible;
		//Medium Balls
		mediumBall1Visible <= nxt_mediumBall1Visible;
		mediumBall2Visible <= nxt_mediumBall2Visible;
		mediumBall3Visible <= nxt_mediumBall3Visible;
		mediumBall4Visible <= nxt_mediumBall4Visible;
		//Small Balls
		smallBall1Visible <= nxt_smallBall1Visible;
		smallBall2Visible <= nxt_smallBall2Visible;
		smallBall3Visible <= nxt_smallBall3Visible;
		smallBall4Visible <= nxt_smallBall4Visible;
		smallBall5Visible <= nxt_smallBall5Visible;
		smallBall6Visible <= nxt_smallBall6Visible;
		smallBall7Visible <= nxt_smallBall7Visible;
		smallBall8Visible <= nxt_smallBall8Visible;
		
		//Huge Ball
		hugeBallReset <= nxt_hugeBallReset;
		//Big Balls
		bigBall1Reset <= nxt_bigBall1Reset;
		bigBall2Reset <= nxt_bigBall2Reset;
		//Medium Balls
		mediumBall1Reset <= nxt_mediumBall1Reset;
		mediumBall2Reset <= nxt_mediumBall2Reset;
		mediumBall3Reset <= nxt_mediumBall3Reset;
		mediumBall4Reset <= nxt_mediumBall4Reset;
		//Small Balls
		smallBall1Reset <= nxt_smallBall1Reset;
		smallBall2Reset <= nxt_smallBall2Reset;
		smallBall3Reset <= nxt_smallBall3Reset;
		smallBall4Reset <= nxt_smallBall4Reset;
		smallBall5Reset <= nxt_smallBall5Reset;
		smallBall6Reset <= nxt_smallBall6Reset;
		smallBall7Reset <= nxt_smallBall7Reset;
		smallBall8Reset <= nxt_smallBall8Reset;
		
	end 
		
end


	
always_comb // Update the next state  ////////////////////////////////
begin

		nxt_st = cur_st;	// Set default values
		
		case (cur_st)
					
			inactive: begin
			
				if ( unitActive ) //input signal of reset
					nxt_st = deploy;
						
			end // inactive
			
			
			deploy: begin
				nxt_st = active;
			
			end
			
			active: begin
			
				if ( !unitActive ) //terminate the ball
					nxt_st = inactive;
					
			end // active
					
		endcase

end // always next state ///////////////////////////////



always_comb // Update the outputs //////////////////////
  begin
	
	col_rope_ball = 0;
	col_ball_type = 0;
	nxt_inUse = inUse;
				
	//Huge Ball
	nxt_hugeBallVisible = hugeBallVisible;
	//Big Balls
	nxt_bigBall1Visible = bigBall1Visible;
	nxt_bigBall2Visible = bigBall2Visible;
	//Medium Balls
	nxt_mediumBall1Visible = mediumBall1Visible;
	nxt_mediumBall2Visible = mediumBall2Visible;
	nxt_mediumBall3Visible = mediumBall3Visible;
	nxt_mediumBall4Visible = mediumBall4Visible;
	//Small Balls
	nxt_smallBall1Visible = smallBall1Visible;
	nxt_smallBall2Visible = smallBall2Visible;
	nxt_smallBall3Visible = smallBall3Visible;
	nxt_smallBall4Visible = smallBall4Visible;
	nxt_smallBall5Visible = smallBall5Visible;
	nxt_smallBall6Visible = smallBall6Visible;
	nxt_smallBall7Visible = smallBall7Visible;
	nxt_smallBall8Visible = smallBall8Visible;
	
	
	//Huge Ball
	nxt_hugeBallReset = hugeBallReset;
	//Big Balls
	nxt_bigBall1Reset = bigBall1Reset;
	nxt_bigBall2Reset = bigBall2Reset;
	//Medium Balls
	nxt_mediumBall1Reset = mediumBall1Reset;
	nxt_mediumBall2Reset = mediumBall2Reset;
	nxt_mediumBall3Reset = mediumBall3Reset;
	nxt_mediumBall4Reset = mediumBall4Reset;
	//Small Balls
	nxt_smallBall1Reset = smallBall1Reset;
	nxt_smallBall2Reset = smallBall2Reset;
	nxt_smallBall3Reset = smallBall3Reset;
	nxt_smallBall4Reset = smallBall4Reset;
	nxt_smallBall5Reset = smallBall5Reset;
	nxt_smallBall6Reset = smallBall6Reset;
	nxt_smallBall7Reset = smallBall7Reset;
	nxt_smallBall8Reset = smallBall8Reset;
	
	
	case (cur_st)
				
		inactive: begin
		
			nxt_inUse = 0;
			
			nxt_hugeBallVisible = 0;
			nxt_bigBall1Visible = 0;
			nxt_bigBall2Visible = 0;
			nxt_mediumBall1Visible = 0;
			nxt_mediumBall2Visible = 0;
			nxt_mediumBall3Visible = 0;
			nxt_mediumBall4Visible = 0;
			nxt_smallBall1Visible = 0;
			nxt_smallBall2Visible = 0;
			nxt_smallBall3Visible = 0;
			nxt_smallBall4Visible = 0;
			nxt_smallBall5Visible = 0;
			nxt_smallBall6Visible = 0;
			nxt_smallBall7Visible = 0;
			nxt_smallBall8Visible = 0;
			
			
			nxt_hugeBallReset = 0;
			nxt_bigBall1Reset = 0;
			nxt_bigBall2Reset = 0;
			nxt_mediumBall1Reset = 0;
			nxt_mediumBall2Reset = 0;
			nxt_mediumBall3Reset = 0;
			nxt_mediumBall4Reset = 0;
			nxt_smallBall1Reset = 0;
			nxt_smallBall2Reset = 0;
			nxt_smallBall3Reset = 0;
			nxt_smallBall4Reset = 0;
			nxt_smallBall5Reset = 0;
			nxt_smallBall6Reset = 0;
			nxt_smallBall7Reset = 0;
			nxt_smallBall8Reset = 0;
			
		end // inactive
							
		deploy: begin
		
			nxt_inUse = 1;
			
			case ( initialState )
			
				0 : begin // start with small ball
					nxt_smallBall1Visible = 1;
					nxt_smallBall1Reset = 1;
				end
				
				1 : begin //start with medium ball
					nxt_mediumBall1Visible = 1;
					nxt_mediumBall1Reset = 1;
				end
				
				2 : begin //start with big ball
					nxt_bigBall1Visible = 1;
					nxt_bigBall1Reset = 1;
				end
				
				3 : begin //start with huge ball
					nxt_hugeBallVisible = 1;
					nxt_hugeBallReset = 1;
				end

				
			endcase
							
		end
		
		active: begin
		
			//inUse = 1 if any sub-ball is active, 0 otherwise.
			
			if ( hugeBallVisible || 
					bigBall1Visible || bigBall2Visible ||
					mediumBall1Visible || mediumBall2Visible || mediumBall3Visible || mediumBall4Visible ||
					smallBall1Visible || smallBall2Visible || smallBall3Visible || smallBall4Visible || 
					smallBall5Visible || smallBall6Visible || smallBall7Visible || smallBall8Visible )
			begin
				nxt_inUse = 1; 
			end
			else
			begin
				nxt_inUse = 0;
			end
			
			
			//Huge Ball
			if ( col_rope_hugeBall )
			begin
			
				col_rope_ball = 1;
				col_ball_type = 3;
				
				nxt_hugeBallVisible = 0;
				
				nxt_bigBall1Visible = 1;
				nxt_bigBall1Reset = 1;
				
				nxt_bigBall2Visible = 1;
				nxt_bigBall2Reset = 1;
			
			end
			
			
			
			//Big Ball 1
			else if ( col_rope_bigBall1 )
			begin
			
				col_rope_ball = 1;
				col_ball_type = 2;
			
				nxt_bigBall1Visible = 0;
				
				nxt_mediumBall1Visible = 1;
				nxt_mediumBall1Reset = 1;
				
				nxt_mediumBall2Visible = 1;
				nxt_mediumBall2Reset = 1;
				
			end
			
			//Big Ball 2
			else if ( col_rope_bigBall2 )
			begin
			
				col_rope_ball = 1;
				col_ball_type = 2;
				
				nxt_bigBall2Visible = 0;
				
				nxt_mediumBall3Visible = 1;
				nxt_mediumBall3Reset = 1;
				
				nxt_mediumBall4Visible = 1;
				nxt_mediumBall4Reset = 1;
				
			end
			
			
			
			//Medium Ball 1
			else if ( col_rope_mediumBall1 )
			begin
			
				col_rope_ball = 1;
				col_ball_type = 1;
				
				nxt_mediumBall1Visible = 0;
				
				nxt_smallBall1Visible = 1;
				nxt_smallBall1Reset = 1;
				
				nxt_smallBall2Visible = 1;
				nxt_smallBall2Reset = 1;
			end
			
			//Medium Ball 2
			else if ( col_rope_mediumBall2 )
			begin
			
				col_rope_ball = 1;
				col_ball_type = 1;
				
				nxt_mediumBall2Visible = 0;
				
				nxt_smallBall3Visible = 1;
				nxt_smallBall3Reset = 1;
				
				nxt_smallBall4Visible = 1;
				nxt_smallBall4Reset = 1;
			end
			
			//Medium Ball 3
			else if ( col_rope_mediumBall3 )
			begin
			
				col_rope_ball = 1;
				col_ball_type = 1;
				
				nxt_mediumBall3Visible = 0;
				
				nxt_smallBall5Visible = 1;
				nxt_smallBall5Reset = 1;
				
				nxt_smallBall6Visible = 1;
				nxt_smallBall6Reset = 1;
			end
			
			//Medium Ball 4
			else if ( col_rope_mediumBall4 )
			begin
			
				col_rope_ball = 1;
				col_ball_type = 1;
				
				nxt_mediumBall4Visible = 0;
				
				nxt_smallBall7Visible = 1;
				nxt_smallBall7Reset = 1;
				
				nxt_smallBall8Visible = 1;
				nxt_smallBall8Reset = 1;
			end
			
			
			//Small Ball 1
			else if ( col_rope_smallBall1 )
			begin
				col_rope_ball = 1;
				col_ball_type = 0;
				nxt_smallBall1Visible = 0;
			end
			
			//Small Ball 2
			else if ( col_rope_smallBall2 )
			begin
				col_rope_ball = 1;
				col_ball_type = 0;
				nxt_smallBall2Visible = 0;
			end
			
			//Small Ball 3
			else if ( col_rope_smallBall3 )
			begin
				col_rope_ball = 1;
				col_ball_type = 0;
				nxt_smallBall3Visible = 0;
			end
			
			//Small Ball 4
			else if ( col_rope_smallBall4 )
			begin
				col_rope_ball = 1;
				col_ball_type = 0;
				nxt_smallBall4Visible = 0;
			end
			
			//Small Ball 5
			else if ( col_rope_smallBall5 )
			begin
				col_rope_ball = 1;
				col_ball_type = 0;
				nxt_smallBall5Visible = 0;
			end
			
			//Small Ball 6
			else if ( col_rope_smallBall6 )
			begin
				col_rope_ball = 1;
				col_ball_type = 0;
				nxt_smallBall6Visible = 0;
			end
			
			//Small Ball 7
			else if ( col_rope_smallBall7 )
			begin
				col_rope_ball = 1;
				col_ball_type = 0;
				nxt_smallBall7Visible = 0;
			end
			
			//Small Ball 8
			else if ( col_rope_smallBall8 )
			begin
				col_rope_ball = 1;
				col_ball_type = 0;
				nxt_smallBall8Visible = 0;
			end
			
		end // active
	
	endcase
end // always outputs //////////////////////////////
	
	
//check if any collision with player has occured.
assign col_player_ball = col_player_hugeBall || 
									col_player_bigBall1 || col_player_bigBall2 ||
									col_player_mediumBall1 || col_player_mediumBall2 || col_player_mediumBall3 || col_player_mediumBall4 ||
									col_player_smallBall1 || col_player_smallBall2 || col_player_smallBall3 || col_player_smallBall4 ||
									col_player_smallBall5 || col_player_smallBall6 || col_player_smallBall7 || col_player_smallBall8;

									
endmodule
