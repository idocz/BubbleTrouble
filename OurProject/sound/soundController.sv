
// (c) Technion IIT, Department of Electrical Engineering 2018 
// Updated by Liat Schwartz March 2019 

// Implements a simple traffic lights controller
// by using state machine with present and next states wvf6

module soundController	(

	input logic clk, resetN,
	input logic col_player_ball, col_rope_ball, col_present, ropeDeploy,
	input logic[1:0] gameState,
	input logic slowClk,

	output logic [3:0] tone,
	output logic soundEnable
	
);
	


	
enum logic [2:0] {idle, playerBall, ropeBall, present, rope} cur_st, nxt_st;

logic [2:0] timer, nxt_timer;
logic [3:0] nxt_tone;



always_ff @(posedge clk or negedge resetN) // State machine logic ////
begin
	   
   if ( !resetN ) begin // Asynchronic reset
	
		cur_st <= idle;
		timer <= 0;
		tone <= 0;
		
	end // asynch
	else 
	begin  // Synchronic logic
	
		cur_st <= nxt_st; // Update current state
		timer <= nxt_timer;
		tone <= nxt_tone;
		
	end 
		
end


	
always_comb // Update the next state  ////////////////////////////////
begin
	nxt_st = cur_st;	// Set default values
	case (cur_st)
				
		idle: 
		begin
			
			if ( gameState == 1 )
			begin
			
				if ( col_player_ball )
					nxt_st = playerBall;
					
				else if ( col_rope_ball )
					nxt_st = ropeBall;
					
				else if ( col_present )
					nxt_st = ropeBall;
				
				else if ( ropeDeploy )
					nxt_st = ropeBall;
			
			end
			
			
		end //idle
		
		playerBall:
		begin
		
			if( timer == 0 )
				nxt_st = idle;
				
		end // playerBall
		
		ropeBall:
		begin
		
			if( timer == 0 )
				nxt_st = idle;
				
		end // ropeBall
		
		present:
		begin
		
			if( timer == 0 )
				nxt_st = idle;
				
		end // present
		
		rope:
		begin
		
			if( timer == 0 )
				nxt_st = idle;
				
		end // rope
						
				
	endcase

end // always next state ///////////////////////////////



always_comb // Update the outputs //////////////////////
begin
	
	// Set default values
	
	soundEnable = 0;	
	nxt_tone = tone;
	nxt_timer = timer;

	
	case (cur_st)
		
		idle: 
		begin
		
			if ( col_player_ball || col_rope_ball || col_present )
				nxt_timer = 2;
			else if ( ropeDeploy )
				nxt_timer = 1;
				
					
		end //idle
		
		playerBall:
		begin
			soundEnable = 1;
			if( timer == 2 )
				nxt_tone = 11;
				
			if ( timer == 1 )
				nxt_tone = 5;
				
			if ( slowClk )
				nxt_timer = timer - 1;

		end // playerBall	
		
		ropeBall:
		begin
			soundEnable = 1;
			if( timer == 2 )
				nxt_tone = 0;
				
			if ( timer == 1 )
				nxt_tone = 7;
				
			if ( slowClk )
				nxt_timer = timer - 1;

		end // ropeBall	

		
		present:
		begin
			soundEnable = 1;
			if( timer == 2 )
				nxt_tone = 4;
				
			if ( timer == 1 )
				nxt_tone = 11;
				
			if ( slowClk )
				nxt_timer = timer - 1;

		end // present	

		
		rope:
		begin
			soundEnable = 1;
			if( timer == 1 )
				nxt_tone = 9;
				
			if ( slowClk )
				nxt_timer = timer - 1;

		end // rope	


		
		
	endcase	
		
		

end // always outputs //////////////////////////////


endmodule
