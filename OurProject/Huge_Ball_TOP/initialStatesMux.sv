//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	initialStatesMux	(	

					input logic [10:0] ballInitialX,
					input logic [10:0] ballInitialY,
					input	shortint ballInitialXSpeed,
					input	shortint ballInitialYSpeed,
					
					input logic [10:0] unitInitialX,
					input logic [10:0] unitInitialY,
					input	shortint unitInitialXSpeed,
					input	shortint unitInitialYSpeed,
					
					input logic [1:0] initialState,
					
					
					output logic [10:0] initialX,
					output logic [10:0] initialY,
					output	shortint initialXSpeed,
					output	shortint initialYSpeed
										
);


parameter state = 0;

always_comb
begin

	//checks if the current ball is reset with initial states or a ball's split
	if ( initialState == state ) //initial reset
	begin
		initialX = unitInitialX;
		initialY = unitInitialY;
		initialXSpeed = unitInitialXSpeed;
		initialYSpeed = unitInitialYSpeed;
	end
	else //ball's split
	begin
		initialX = ballInitialX;
		initialY = ballInitialY;
		initialXSpeed = ballInitialXSpeed;
		initialYSpeed = ballInitialYSpeed;
	end
		
end

endmodule


