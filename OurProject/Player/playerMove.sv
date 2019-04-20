module playerMove 	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input logic	 startOfFrame,
	input	logic	 rightArrow,
	input	logic	 leftArrow,
	output	logic	[10:0]	topLeftX,
	output	logic	[10:0]	topLeftY
);


 
parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 420;
parameter int X_SPEED = 30;
parameter int playerWidth = 26 ;


const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n 
const int	x_FRAME_SIZE	=	639 * MULTIPLIER;
const int	y_FRAME_SIZE	=	479 * MULTIPLIER;


int Xspeed, topLeftX_tmp, topLeftY_tmp; // local parameters 



//  calculation x Axis speed 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
		Xspeed	<= 0;
	else 	begin
	
			if ( rightArrow == 1'b1 && leftArrow == 1'b0)
				Xspeed <= X_SPEED ;
			else if ( leftArrow == 1'b1 && rightArrow == 1'b0 )
				Xspeed <= -X_SPEED ;
			else
				Xspeed <= 0 ;
				
	end
end



// position calculate 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_tmp	<= INITIAL_X * MULTIPLIER;
		topLeftY_tmp	<= INITIAL_Y * MULTIPLIER;
	end
	
	else if (startOfFrame == 1'b1) begin // perform only 30 times per second 
	
			if(topLeftX_tmp >= 5 && topLeftX <= (635 - playerWidth))
					topLeftX_tmp  <= topLeftX_tmp + Xspeed; 
					
			else if(topLeftX_tmp < 5 && rightArrow == 1'b1)
				topLeftX_tmp  <= topLeftX_tmp + Xspeed;
				
			else if((topLeftX_tmp > (635 - playerWidth)) && leftArrow == 1'b1)
				topLeftX_tmp  <= topLeftX_tmp + Xspeed;

	end
end


//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_tmp / MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_tmp / MULTIPLIER ; 

endmodule

