//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module displayMux	(	
					input logic resetN,
					input logic clk,					
					input		logic	titleRequest,
					input		logic	[7:0] titleRGB,
					input    logic gameOverRequest,
					input    logic [7:0] gameOverRGB,
					input    logic lifeRequest,
					input    logic [7:0] lifeRGB,
					input    logic levelRequest,
					input    logic [7:0] levelRGB,
					input    logic pressSpaceRequest,
					input    logic [7:0] pressSpaceRGB,
					input    logic scoreRequest,
					input    logic [7:0] scoreRGB,
					
					output   logic infoRequest,
					output   logic [7:0] infoRGB
					
);

assign infoRequest = titleRequest | gameOverRequest | lifeRequest | levelRequest | pressSpaceRequest | scoreRequest ;
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			infoRGB	<= 8'b0;
	end
	else begin
	
		//first priority
		
		if (titleRequest == 1'b1)
			infoRGB <= titleRGB;
			
		else if( gameOverRequest == 1'b1)
			infoRGB <= gameOverRGB;
		
		else if ( lifeRequest == 1'b1 )
			infoRGB <= lifeRGB;
		
		else if ( levelRequest == 1'b1 )
			infoRGB <= levelRGB;
		
		else if ( scoreRequest == 1'b1 )
			infoRGB <= scoreRGB;
		
		else
			infoRGB <= pressSpaceRGB;
			
			
	end
end

endmodule


