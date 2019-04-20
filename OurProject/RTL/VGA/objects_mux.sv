//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	objects_mux	(	
					input		logic	clk,
					input		logic	resetN,
					
					// player 
					input		logic	[7:0] playerRGB, // two set of inputs per unit
					input		logic	playerDrawingRequest,
					
					//ball
					//input    logic [7:0] ballRGB,
					//input    logic ballDrawingRequest,
					
					//rope
					input    logic [7:0] ropeRGB,
					input    logic ropeDrawingRequest,
					
					// background 
					input		logic	[7:0] backGroundRGB, 

					output	logic	[7:0] redOut, // full 24 bits color output
					output	logic	[7:0] greenOut, 
					output	logic	[7:0] blueOut 
);

logic [7:0] tmpRGB;


assign redOut	  = {tmpRGB[7:5], {5{tmpRGB[5]}}}; //--  extend LSB to create 10 bits per color  
assign greenOut  = {tmpRGB[4:2], {5{tmpRGB[2]}}};
assign blueOut	  = {tmpRGB[1:0], {6{tmpRGB[0]}}};

//
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (playerDrawingRequest == 1'b1 )   
			tmpRGB <= playerRGB;  //first priority 
		
		//else if (ballDrawingRequest == 1'b1)
		//	tmpRGB <= ballRGB;
		
		else if(ropeDrawingRequest == 1'b1)
			tmpRGB <= ropeRGB;
		
		else
			tmpRGB <= backGroundRGB ; // last priority 
		end ;
	end

endmodule


