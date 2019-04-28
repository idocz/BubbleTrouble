//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	ballMux	(	
					input		logic	clk,
					input		logic	resetN,
					
					// Huge Ball 
					input		logic	[7:0] hugeBallRGB, // two set of inputs per unit
					input		logic	hugeBallRequest,
					
					// Big Ball 1
					input    logic [7:0] biGBall1RGB,
					input    logic bigBall1Request,
					
					// Big Ball 2
					input    logic [7:0] biGBall2RGB,
					input    logic bigBall2Request,
					

					output 	logic ballRequest,
					output	logic	[7:0] ballRGBout // full 24 bits color output
);




always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			ballRGBout	<= 8'b0;
	end
	else begin
		if (bigBall1Request == 1'b1 )   
			ballRGBout <= biGBall1RGB;  //first priority 
		
		else if (bigBall2Request == 1'b1)
			ballRGBout <= biGBall2RGB;

		else
			ballRGBout <= hugeBallRGB; // last priority 
		end ;
	end

	assign ballRequest = hugeBallRequest || bigBall1Request || bigBall2Request;
	
	
endmodule


