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
	output logic presentDrop, playerReset,
	output logic immortal, superSpeed, superRope,
	output shortint lives
	
);
	
const int y_FRAME_SIZE =	479;
parameter INITIAL_LIVES = 1;
parameter MAX_IMMORTAL_TIMER = 5;
parameter MAX_ROPE_TIMER = 5;
parameter MAX_SUPERSPEED_TIMER = 5;
	
enum logic [2:0] {welcomeScreen, playMode, gameOver} cur_st, nxt_st;
shortint nxt_lives;
logic [10:0] nxt_ropeX;
logic nxt_ropeActive;
logic [11:0] nxt_gameTime;
logic [2:0] superRopeTimer, nxt_superRopeTimer, immortalTimer, nxt_immortalTimer, superSpeedTimer, nxt_superSpeedTimer;
logic nxt_immortal, nxt_superSpeed, nxt_superRope;


always_ff @(posedge clk or negedge resetN) // State machine logic ////
   begin
	   
   if ( !resetN ) begin // Asynchronic reset
	
		cur_st <= welcomeScreen;
		lives <= INITIAL_LIVES;
		ropeX <= 0;
		ropeActive <= 0;
		gameTime <= 0;
		superRope <= 0;
		superRopeTimer <= 0;
		immortal <= 0;
		immortalTimer <= 0;
		superSpeed <= 0;
		superSpeedTimer <= 0;
		
	end // asynch
	else 
	begin  // Synchronic logic
	
		cur_st <= nxt_st; // Update current state
		lives <= nxt_lives;
		ropeX <= nxt_ropeX;
		ropeActive <= nxt_ropeActive;
		gameTime <= nxt_gameTime;
		superRope <= nxt_superRope;
		superRopeTimer <= nxt_superRopeTimer;
		immortal <= nxt_immortal;
		immortalTimer <= nxt_immortalTimer;
		superSpeed <= nxt_superSpeed;
		superSpeedTimer <= nxt_superSpeedTimer;
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
	
	// Set default values
	
	gameState = 0;	
	playerMoveRight = 0;
	playerMoveLeft = 0;
	playerVisible = 0;
	playerReset = 0;
	ballVisible = 0;
	presentsVisible = 0;
	presentDrop = 0;
	
	nxt_lives = lives;
	nxt_gameTime = gameTime;
	
	nxt_ropeX = ropeX;
	nxt_superRope = superRope;
	nxt_ropeActive = ropeActive;
	nxt_superRopeTimer = superRopeTimer;
	
	nxt_immortal = immortal;
	nxt_immortalTimer = immortalTimer;
	
	nxt_superSpeed = superSpeed;
	nxt_superSpeedTimer = superSpeedTimer;
	
	case (cur_st)
				
		welcomeScreen: begin
		
			gameState = 0;
			nxt_ropeActive = 0;
			nxt_gameTime = 0;
			nxt_lives = INITIAL_LIVES;
			nxt_superRope = 0;
			nxt_immortal = 0;
			nxt_superSpeed = 0;
			
		end // welcomeScreen
							
		playMode: begin
		
			gameState = 1;
			playerVisible = 1;
			ballVisible = 1;
			presentsVisible = 1;
			
			if ( ropeTopY <= 0 && !superRope )
				nxt_ropeActive = 0;
			
			if ( spaceBar && ropeActive == 0) 
			begin
				nxt_ropeActive = 1;
				nxt_ropeX = playerX;
			end
			
			if ( col_player_ball )
			begin
				nxt_lives = lives - 1;
				nxt_immortal = 1;
				nxt_immortalTimer = 3;
				playerReset = 1;
			end
				
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
				
			// Present Collector
			if ( col_present ) 
			begin
			
				if ( presentType == 2'b00 ) // lives
					nxt_lives = lives + 1;
					
				else if ( presentType == 2'b01 ) // super rope
				begin
					nxt_superRope = 1;
					nxt_superRopeTimer = MAX_ROPE_TIMER;
				end
				
				
				else if ( presentType == 2'b10 ) // super speed
				begin
					nxt_superSpeed = 1;
					nxt_superSpeedTimer = MAX_SUPERSPEED_TIMER;
				end
				
				else if ( presentType == 2'b11 ) // immortal
				begin
					nxt_immortal = 1;
					nxt_immortalTimer = MAX_IMMORTAL_TIMER;
				end
					
			end
			
			
			// Super Rope Timer
			if ( secClk && superRope && ropeTopY <= 0 )
			begin
				if ( superRopeTimer > 0 )
					nxt_superRopeTimer = superRopeTimer - 1;
				else
					nxt_superRope = 0;
			end
			
			
			// Immortal Timer
			if ( secClk && immortal )
			begin
				if ( immortalTimer > 0 )
					nxt_immortalTimer = immortalTimer - 1;
				else
					nxt_immortal = 0;
			end
			
			
			// Super Speed Timer
			if ( secClk && superSpeed )
			begin
				if ( superSpeedTimer > 0 )
					nxt_superSpeedTimer = superSpeedTimer - 1;
				else
					nxt_superSpeed = 0;
			end
			
			

		end // playMode
			
		gameOver: begin
		
			gameState = 2;
			nxt_ropeActive = 0;
			
		end // gameOver
	
	endcase
end // always outputs //////////////////////////////


endmodule
