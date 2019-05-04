// (c) Technion IIT, Department of Electrical Engineering 2018 
// Updated by Liat Schwartz March 2019 

// Implements a simple traffic lights controller
// by using state machine with present and next states wvf6

module  ballController (

	input logic clk, resetN,
	input logic unitActive,
	
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
	

	
	//Visible
	output logic hugeBallVisible,
	
	output logic bigBall1Visible,
	output logic bigBall2Visible,
	
	output logic mediumBall1Visible,
	output logic mediumBall2Visible,
	output logic mediumBall3Visible,
	output logic mediumBall4Visible,
	

	//reset
	output logic hugeBallReset,
	
	output logic bigBall1Reset,
	output logic bigBall2Reset,
	
	output logic mediumBall1Reset,
	output logic mediumBall2Reset,
	output logic mediumBall3Reset,
	output logic mediumBall4Reset,
	
	output logic col_rope_ball,
	output logic col_player_ball
	
	
);
	
	
const int y_FRAME_SIZE =	479;
	
enum logic [1:0] {inactive, deploy, active} cur_st, nxt_st;


logic	nxt_hugeBallVisible;
logic	nxt_bigBall1Visible;
logic	nxt_bigBall2Visible;
logic	nxt_mediumBall1Visible;
logic	nxt_mediumBall2Visible;
logic	nxt_mediumBall3Visible;
logic	nxt_mediumBall4Visible;


logic	nxt_hugeBallReset;
logic	nxt_bigBall1Reset;
logic	nxt_bigBall2Reset;
logic	nxt_mediumBall1Reset;
logic	nxt_mediumBall2Reset;
logic	nxt_mediumBall3Reset;
logic	nxt_mediumBall4Reset;


always_ff @(posedge clk or negedge resetN) // State machine logic ////
   begin
	   
   if ( !resetN ) 
	begin // Asynchronic reset
	
		cur_st <= inactive;
		
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

		
	end // asynch
	else 
	begin 				// Synchronic logic
	
		cur_st <= nxt_st; // Update current state
		
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
	
	
	case (cur_st)
				
		inactive: begin
		
			nxt_hugeBallVisible = 0;
			nxt_bigBall1Visible = 0;
			nxt_bigBall2Visible = 0;
			nxt_mediumBall1Visible = 0;
			nxt_mediumBall2Visible = 0;
			nxt_mediumBall3Visible = 0;
			nxt_mediumBall4Visible = 0;
			
			nxt_hugeBallReset = 0;
			nxt_bigBall1Reset = 0;
			nxt_bigBall2Reset = 0;
			nxt_mediumBall1Reset = 0;
			nxt_mediumBall2Reset = 0;
			nxt_mediumBall3Reset = 0;
			nxt_mediumBall4Reset = 0;
			
		end // inactive
							
		deploy: begin
		
			nxt_hugeBallVisible = 1;
			nxt_hugeBallReset = 1;
			
			nxt_bigBall1Visible = 0;
			nxt_bigBall2Visible = 0;
			
			nxt_mediumBall1Visible = 0;
			nxt_mediumBall2Visible = 0;
			nxt_mediumBall3Visible = 0;
			nxt_mediumBall4Visible = 0;
			
		end
		
		active: begin
		
			//Huge Ball
			if ( col_rope_hugeBall )
			begin
				nxt_hugeBallVisible = 0;
				
				nxt_bigBall1Visible = 1;
				nxt_bigBall1Reset = 1;
				
				nxt_bigBall2Visible = 1;
				nxt_bigBall2Reset = 1;
			
			end
			
			
			
			//Big Ball 1
			if ( col_rope_bigBall1 )
			begin
				nxt_bigBall1Visible = 0;
				
				nxt_mediumBall1Visible = 1;
				nxt_mediumBall1Reset = 1;
				
				nxt_mediumBall2Visible = 1;
				nxt_mediumBall2Reset = 1;
				
			end
			
			//Big Ball 2
			if ( col_rope_bigBall2 )
			begin
				nxt_bigBall2Visible = 0;
				
				nxt_mediumBall3Visible = 1;
				nxt_mediumBall3Reset = 1;
				
				nxt_mediumBall4Visible = 1;
				nxt_mediumBall4Reset = 1;
				
			end
			
			
			
			//Medium Ball 1
			if ( col_rope_mediumBall1 )
			begin
				nxt_mediumBall1Visible = 0;
			end
			
			//Medium Ball 2
			if ( col_rope_mediumBall2 )
			begin
				nxt_mediumBall2Visible = 0;
			end
			
			//Medium Ball 3
			if ( col_rope_mediumBall3 )
			begin
				nxt_mediumBall3Visible = 0;
			end
			
			//Medium Ball 4
			if ( col_rope_mediumBall4 )
			begin
				nxt_mediumBall4Visible = 0;
			end
			
		end // active
	
	endcase
end // always outputs //////////////////////////////
	
	
	
assign col_rope_ball = 	col_rope_hugeBall || 
								col_rope_bigBall1 || col_rope_bigBall2 ||
								col_rope_mediumBall1 || col_rope_mediumBall2 || col_rope_mediumBall3 || col_rope_mediumBall4;
								
								
assign col_player_ball = col_player_hugeBall || 
									col_player_bigBall1 || col_player_bigBall2 ||
									col_player_mediumBall1 || col_player_mediumBall2 || col_player_mediumBall3 || col_player_mediumBall4;

	
endmodule
