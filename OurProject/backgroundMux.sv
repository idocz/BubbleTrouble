//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module backgroundMux	(	
					
					input		logic	[7:0] welcomeRGB,
					input    logic [7:0] playmodeRGB,
					input    logic [7:0] gameoverRGB,
					
					input 	logic [1:0] selector,

					output	logic	[7:0] backGround
);


always_comb
begin


	case ( selector )
	
		0 : begin
			backGround = welcomeRGB;
		end
		
		1 : begin
			backGround = playmodeRGB;
		end
		
		2 : begin
			backGround = gameoverRGB;
		end
			
	endcase

end

endmodule


