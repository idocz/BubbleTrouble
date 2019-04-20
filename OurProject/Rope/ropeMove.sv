//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018


module ropeMove	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic deploy,
					output	logic	[10:0] topY, // output the top Y of the rope 
					output logic movingUp

					
);


// a module used to generate a ball trajectory.  

parameter int INITIAL_Y = 26;
parameter int INITIAL_Y_SPEED = -150;

const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n 
const int	x_FRAME_SIZE	=	639 * MULTIPLIER;
const int	y_FRAME_SIZE	=	479 * MULTIPLIER;


 // local parameters 
int Yspeed, topY_tmp;
logic movingUp_tmp;




// position calculate 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topY_tmp	<= y_FRAME_SIZE;
	end
	else begin
		movingUp_tmp = (deploy == 1'b1 || (topY_tmp != y_FRAME_SIZE && topY_tmp >= 0)); //Legal blocking assignment
			
		if (startOfFrame == 1'b1 && movingUp_tmp == 1'b1) begin // perform only 30 times per second  
			topY_tmp  <= topY_tmp + Yspeed;				
		end
		else if (startOfFrame == 1'b1 && movingUp_tmp == 1'b0) begin //
			topY_tmp <= y_FRAME_SIZE;
		end
			
	end
end




assign 	topY = topY_tmp / MULTIPLIER ;  
assign   movingUp = movingUp_tmp;  


endmodule
