//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018


module presentMove	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz
					input logic [10:0] initialX, initialY,
					input shortint initialYspeed,
					
					output	logic	[10:0]	topLeftX,// output the top left corner 
					output	logic	[10:0]	topLeftY

);


// a module used to generate a ball trajectory.  

parameter int g = 1;
parameter PRESENT_HEIGHT = 20;

const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n 
const int	x_FRAME_SIZE	=	639 * MULTIPLIER;
const int	y_FRAME_SIZE	=	479 * MULTIPLIER;


int topLeftX_tmp; // local parameters 
int Yspeed_tmp, topLeftY_tmp;



//  calculation Y Axis speed using gravity

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		Yspeed_tmp	<= initialYspeed;
	end 
	else 
	begin
	
		if ( topLeftY_tmp <= (y_FRAME_SIZE - PRESENT_HEIGHT * MULTIPLIER) )
		begin
			if (startOfFrame == 1'b1) 
				Yspeed_tmp <= Yspeed_tmp  + g ; // gravity force 
		end
		else
			Yspeed_tmp <= 0 ; 
			
	end 
end

// position calculate 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_tmp	<= initialX * MULTIPLIER;
		topLeftY_tmp	<= initialY * MULTIPLIER;
	end
	else begin
		if (startOfFrame == 1'b1) begin // perform only 30 times per second   
				topLeftY_tmp  <= topLeftY_tmp + Yspeed_tmp; 
		end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_tmp / MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_tmp / MULTIPLIER ;  


endmodule
