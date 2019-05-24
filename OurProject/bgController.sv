//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	bgController	(
					input logic[1:0] gameState,
					output logic titleVisible,
					output logic gameOverVisible,
					output logic lifeVisible,
					output logic levelVisible,
					output logic pressSpaceVisible,
					output logic scoreVisible
);

always_comb
begin


	titleVisible = 0;
	gameOverVisible = 0;
	lifeVisible = 0;
	levelVisible = 0;
	pressSpaceVisible = 0;
	scoreVisible = 0;
	
	//assemble the background accoring to the game state.
	if( gameState == 0)
	begin
		titleVisible = 1;
		pressSpaceVisible = 1;
	end
		
	if( gameState == 1 )
	begin
		lifeVisible = 1;
		levelVisible = 1;
		scoreVisible = 1;
	end
	
	if( gameState == 2 )
		gameOverVisible = 1;
		
		
end

endmodule

