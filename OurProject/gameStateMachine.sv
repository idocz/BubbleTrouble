// (c) Technion IIT, Department of Electrical Engineering 2018 
// Updated by Liat Schwartz March 2019 

// Implements a simple traffic lights controller
// by using state machine with present and next states wvf6

module gameStateMachine 	(

	input logic clk, resetN,
	input logic rightArrow, leftArrow, spaceBar,
	input logic col_player_ball,
	input logic [10:0] playerX,
	
	output logic [1:0] gameState,
	output logic playerMoveRight, playerMoveLeft, ropeDeploy, playerVisible, ballVisible,
	output logic [10:0] ropeX
	
);
	
	
enum logic [2:0] {welcomeScreen, playMode, gameOver} cur_st, nxt_st;
logic [2:0] lives, nxt_lives;
logic [10:0] nxt_ropeX;



always_ff @(posedge clk or negedge resetN) // State machine logic ////
   begin
	   
   if ( !resetN ) begin // Asynchronic reset
		cur_st <= welcomeScreen;
		lives <= 1;
		ropeX <= 0;
		
	end // asynch
	else 
	begin 				// Synchronic logic	
		cur_st <= nxt_st; // Update current state
		lives <= nxt_lives;
		ropeX <= nxt_ropeX;
	end 
		
end


	
always_comb // Update the next state  ////////////////////////////////
begin
		nxt_st = cur_st;	// Set default values
		
		case (cur_st)
					
			welcomeScreen: begin
				if ( spaceBar )
					nxt_st = playMode;
			end // welcomeScreen
							
			playMode: begin
				if ( lives <= 0 )
					nxt_st = gameOver;
			end // playMode
			
			gameOver: begin
				if ( spaceBar )
					nxt_st = welcomeScreen;
			end // gameOver
					
		endcase

end // always next state ///////////////////////////////



always_comb // Update the outputs //////////////////////
  begin
	
	gameState = 0;	// Set default values
	nxt_lives = lives;
	playerMoveRight = 0;
	playerMoveLeft = 0;
	ropeDeploy = 0;
	playerVisible = 0;
	ballVisible = 0;
	nxt_ropeX = ropeX;
	
	case (cur_st)
				
		welcomeScreen: begin
			gameState = 0;
		end // welcomeScreen
							
		playMode: begin
			gameState = 1;
			playerVisible = 1;
			ballVisible = 1;
			if ( col_player_ball )
				nxt_lives = lives - 1;
			if ( rightArrow )
				playerMoveRight = 1;
			if ( leftArrow )
				playerMoveLeft = 1;
			if ( spaceBar ) begin
				ropeDeploy = 1;
				nxt_ropeX = playerX;
			end
		end // playMode
			
		gameOver: begin
			gameState = 2;
		end // gameOver
	
	endcase
end // always outputs //////////////////////////////
	
endmodule
