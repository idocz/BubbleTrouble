//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module displayMux	(	
					
					input		logic	welcomeRequest,
					input		logic	[7:0] welcomeRGB,
					
					input		logic	playmodeRequest,
					input    logic [7:0] playmodeRGB,
					
					input		logic	gameoverRequest,
					input    logic [7:0] gameoverRGB,
					
					input 	logic [1:0] selector,

					output	logic infoRequest,
					output	logic	[7:0] backGround
);


always_comb
begin

	infoRequest = 0;
	backGround = welcomeRGB;

	case ( selector )
	
		0 : begin
			infoRequest = welcomeRequest;
			backGround = welcomeRGB;
		end
		
		1 : begin
			infoRequest = playmodeRequest;
			backGround = playmodeRGB;
		end
		
		2 : begin
			infoRequest = gameoverRequest;
			backGround = gameoverRGB;
		end
			
	endcase

end

endmodule


