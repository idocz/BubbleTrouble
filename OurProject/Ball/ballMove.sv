//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018


module ballMove	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					output	logic	[10:0]	topLeftX,// output the top left corner 
					output	logic	[10:0]	topLeftY
					
);


// a module used to generate a ball trajectory.  

parameter int INITIAL_X = 26;
parameter int INITIAL_Y = 26;
parameter int INITIAL_X_SPEED = 100;
parameter int INITIAL_Y_SPEED = 0;
parameter int g = 1;

const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n 
const int	x_FRAME_SIZE	=	639 * MULTIPLIER;
const int	y_FRAME_SIZE	=	479 * MULTIPLIER;


int Xspeed, topLeftX_tmp; // local parameters 
int Yspeed, topLeftY_tmp;


//  calculation x Axis speed 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
		Xspeed	<= INITIAL_X_SPEED;
	else 	begin
			
			if ((topLeftX_tmp <= 0 ) && (Xspeed < 0) ) // hit left border while moving right
				Xspeed <= -Xspeed ; 
			
			if ( (topLeftX_tmp >= x_FRAME_SIZE) && (Xspeed > 0 )) // hit right border while moving left
				Xspeed <= -Xspeed ; 
	end
end


//  calculation Y Axis speed using gravity

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		Yspeed	<= INITIAL_Y_SPEED;
	end 
	else begin
		if (startOfFrame == 1'b1) 
			Yspeed <= Yspeed  + g ; // gravity force 
			
			
		if ((topLeftY_tmp <= 0 ) && (Yspeed < 0 )) // hit top border heading up
			Yspeed <= 0.5*(-Yspeed) ; 
			
		if ( ( topLeftY_tmp >= y_FRAME_SIZE) && (Yspeed > 0 )) //hit bottom border heading down 
			Yspeed <= 0.5*(-Yspeed) ; 
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
	else begin
		if (startOfFrame == 1'b1) begin // perform only 30 times per second 
				topLeftX_tmp  <= topLeftX_tmp + Xspeed;  
				topLeftY_tmp  <= topLeftY_tmp + Yspeed; 
			end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_tmp / MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_tmp / MULTIPLIER ;    


endmodule
