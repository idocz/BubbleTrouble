// (c) Technion IIT, Department of Electrical Engineering 2018 
// Updated by Liat Schwartz March 2019 

// Implements a simple traffic lights controller
// by using state machine with present and next states wvf6

module  ballController (

	input logic clk, resetN,
	
	output logic available
);
	
const int y_FRAME_SIZE =	479;
	
enum logic [1:0] {inactive, active} cur_st, nxt_st;



always_ff @(posedge clk or negedge resetN) // State machine logic ////
   begin
	   
   if ( !resetN ) begin // Asynchronic reset
		cur_st <= active;
		
	end // asynch
	else 
	begin 				// Synchronic logic	
		cur_st <= nxt_st; // Update current state
	end 
		
end


	
always_comb // Update the next state  ////////////////////////////////
begin

		nxt_st = cur_st;	// Set default values
		
		case (cur_st)
					
			inactive: begin
					nxt_st = inactive;
			end // inactive
							
			active: begin
					nxt_st = active;
			end // active
					
		endcase

end // always next state ///////////////////////////////



always_comb // Update the outputs //////////////////////
  begin
	
	available = 0;
	
	case (cur_st)
				
		inactive: begin
			available = 0;
		end // inactive
							
		active: begin
			available = 1;
		end // active
	
	endcase
end // always outputs //////////////////////////////
	
endmodule
