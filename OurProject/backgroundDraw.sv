//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	backgroundDraw	(	

					input	logic	clk,
					input	logic	resetN,
					input logic [1:0] bgState,
					input 	logic	[10:0]	pixelX,
					input 	logic	[10:0]	pixelY,

					output	logic infoRequest,
					output	logic	[7:0]	BG_RGB
);

const int	xFrameSize	=	639;
const int	yFrameSize	=	479;
const int	bracketOffset =	10;

logic [2:0] redBits;
logic [2:0] greenBits;
logic [1:0] blueBits;
logic [1:0] bgBitMap_tmp;

localparam logic [2:0] LIGHT_COLOR = 3'b111 ;// bitmap of a dark color
localparam logic [2:0] DARK_COLOR = 3'b000 ;// bitmap of a light color

assign BG_RGB =  {redBits , greenBits , blueBits} ; //collect color nibbles to an 8 bit word 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
				redBits <= DARK_COLOR ;	
				greenBits <= DARK_COLOR  ;	
				blueBits <= DARK_COLOR ;	 
	end 
	else begin
	
	if ( bgState == 2'b00 ) // welcome screen
	begin
		greenBits <= 3'b100 ; 
		redBits <= DARK_COLOR ;
		blueBits <= DARK_COLOR;
	end
	else if ( bgState == 2'b01 ) // play mode
	begin
		greenBits <= DARK_COLOR ; 
		redBits <= 3'b100 ;
		blueBits <= DARK_COLOR;
	end
	else // game over
	begin
		greenBits <= DARK_COLOR ; 
		redBits <= DARK_COLOR ;
		blueBits <= 2'b10;
	end
						

	//if (pixelX > 156 && pixelY >= 256 ) // rectangles on part of the screen 
	//			redBits <= DARK_COLOR ; 
				
				 	   		
	end; 	
end 

endmodule

