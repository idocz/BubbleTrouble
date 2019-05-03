// (c) Technion IIT, Department of Electrical Engineering 2018 
// Updated by Liat Schwartz March 2019 

// Implements a simple traffic lights controller
// by using state machine with present and next states wvf6

module gameStateMachine 	(

	input logic clk, resetN,
	input logic rightArrow, leftArrow, spaceBar,
	input logic col_player_ball, col_rope_ball, col_present,
	input logic [10:0] playerX, ropeTopY,
	input logic secClk,
	input logic [1:0] presentType,

	output logic [11:0] gameTime,
	output logic [1:0] gameState,
	output logic playerMoveRight, playerMoveLeft, ropeActive, playerVisible, ballVisible, presentsVisible,
	output logic [10:0] ropeX,
	output logic presentDrop,
	output logic immortal
	
);
	
const int y_FRAME_SIZE =	479;
parameter INITIAL_LIVES = 1;
	
enum logic [2:0] {welcomeScreen, playMode, gameOver} cur_st, nxt_st;
shortint lives, nxt_lives;
logic [10:0] nxt_ropeX;
logic nxt_ropeActive;
logic [11:0] nxt_gameTime;
logic superRope, nxt_superRope;
logic [2:0] superRopeTimer, nxt_superRopeTimer;
logic nxt_immortal;


always_ff @(posedge clk or negedge resetN) // State machine logic ////
   begin
	   
   if ( !resetN ) begin // Asynchronic reset
		cur_st <= welcomeScreen;
		lives <= INITIAL_LIVES;
		superRope <= 0;
		ropeX <= 0;
		ropeActive <= 0;
		gameTime <= 0;
		superRopeTimer <= 0;
		immortal <= 0;
		
	end // asynch
	else 
	begin 				// Synchronic logic	
		cur_st <= nxt_st; // Update current state
		lives <= nxt_lives;
		ropeX <= nxt_ropeX;
		ropeActive <= nxt_ropeActive;
		gameTime <= nxt_gameTime;
		superRope <= nxt_superRope;
		superRopeTimer <= nxt_superRopeTimer;
		immortal <= nxt_immortal;
	end 
		
end


	
always_comb // Update the next state  ////////////////////////////////
begin
		nxt_st = cur_st;	// Set default values
		
		case (cur_st)
					
			welcomeScreen: 
			begin
		
				if ( spaceBar )
					nxt_st = playMode;
					
			end // welcomeScreen
							
			playMode: 
			begin
			
				if ( lives <= 0 )
					nxt_st = gameOver;
					
			end // playMode
			
			gameOver: 
			begin
			
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
	nxt_ropeActive = ropeActive;
	playerVisible = 0;
	ballVisible = 0;
	presentsVisible = 0;
	nxt_ropeX = ropeX;
	nxt_gameTime = gameTime;
	presentDrop = 0;
	nxt_superRope = superRope;
	nxt_superRopeTimer = superRopeTimer;
	nxt_immortal = immortal;
	
	case (cur_st)
				
		welcomeScreen: begin
		
			gameState = 0;
			nxt_ropeActive = 0;
			nxt_gameTime = 0;
			nxt_lives = INITIAL_LIVES;
			
		end // welcomeScreen
							
		playMode: begin
		
			gameState = 1;
			playerVisible = 1;
			ballVisible = 1;
			presentsVisible = 1;
			
			if ( ropeTopY <= 0 && !superRope )
				nxt_ropeActive = 0;
			else if ( ropeTopY <= 0 && superRope )
				nxt_superRopeTimer = 5;
			
			if ( spaceBar && ropeActive == 0) 
			begin
				nxt_ropeActive = 1;
				nxt_ropeX = playerX;
			end
			
			if ( col_player_ball )
				nxt_lives = lives - 1;
				
			if ( col_rope_ball )
			begin
				nxt_ropeActive = 0;
				nxt_superRope = 0;
			end
				
			if ( rightArrow )
				playerMoveRight = 1;
				
			if ( leftArrow )
				playerMoveLeft = 1;
			
			if ( secClk )
				nxt_gameTime = gameTime + 1;
				
			if ( gameTime % 3 == 0 && secClk )
				presentDrop = 1;
				
			if ( col_present ) 
			begin
			
				if ( presentType == 2'b00 ) // lives
					nxt_lives = lives + 1;
					
				else if ( presentType == 2'b01 ) // super rope
					nxt_superRope = 1;
					
				//else if ( presentType == 2'b10 ) // super speed
				
				else if ( presentType == 2'b11 ) // immortal
					nxt_immortal = 1;

			end
			
		
			if ( secClk && superRope && ropeTopY <= 0 )
			begin
				if ( superRopeTimer > 0 )
					nxt_superRopeTimer = superRopeTimer - 1;
				else
					nxt_superRope = 0;
			end
			

		end // playMode
			
		gameOver: begin
		
			gameState = 2;
			nxt_ropeActive = 0;
			
		end // gameOver
	
	endcase
end // always outputs //////////////////////////////


endmodule
