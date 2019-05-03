// (c) Technion IIT, Department of Electrical Engineering 2018 
// Updated by Liat Schwartz March 2019 

// Implements a simple traffic lights controller
// by using state machine with present and next states wvf6

module  sSegController (

	input logic clk, resetN,
	input logic [11:0] gameTime,
	
	output logic LampTest, darkN,
	output logic [3:0] HexIn4,
	output logic [3:0] HexIn3,
	output logic [3:0] HexIn2,
	output logic [3:0] HexIn1
	
);
	

	
always_comb 
begin

	LampTest = 0;
	darkN = 1;
	HexIn1 = 0;
	HexIn2 = 0;
	HexIn3 = 0;
	HexIn4 = 0;
	
	if( gameTime > 0 )
	begin
		HexIn1 = gameTime % 10;
		HexIn2 = (gameTime / 10) % 10;
		HexIn3 = (gameTime / 100) % 10;
		HexIn4 = (gameTime / 1000) % 10;
	end
	else
		darkN = 0;
		

end 
	
endmodule
