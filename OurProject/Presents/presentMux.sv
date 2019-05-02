//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	presentMux	(	
					input		logic	clk,
					input		logic	resetN,
					
					// Present 1
					input		logic	[7:0] present1RGB, // two set of inputs per unit
					input		logic	present1Request,
					
					// Present 2
					input    logic [7:0] present2RGB,
					input    logic present2Request,
					
					// Present 3
					input    logic [7:0] present3RGB,
					input    logic present3Request,
					

					output 	logic presentRequest,
					output	logic	[7:0] presentRGBout // full 24 bits color output
);




always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			presentRGBout	<= 8'b0;
	end
	else begin
		if (present1Request == 1'b1 )   
			presentRGBout <= present1RGB;  //first priority 
		
		else if (present2Request == 1'b1)
			presentRGBout <= present2RGB;

		else
			presentRGBout <= present3RGB; // last priority 
		end ;
	end

	assign presentRequest = present1Request || present2Request || present3Request;
	
	
endmodule


