// (c) Technion IIT, Department of Electrical Engineering 2018 
// Updated by Liat Schwartz March 2019 

// Implements a simple traffic lights controller
// by using state machine with present and next states wvf6

module  presentsController (

	input logic clk, resetN,
	input logic dropPresent,
	
	input logic col_player_present1,
	input logic col_rope_present1,
	
	input logic col_player_present2,
	input logic col_rope_present2,
	
	input logic col_player_present3,
	input logic col_rope_present3,

	
	//Visible
	output logic present1Visible,
	output logic present2Visible,
	output logic present3Visible,

	//reset
	output logic present1Reset,
	output logic present2Reset,
	output logic present3Reset,
	
	output logic col_present,
	output logic [1:0] present_type
	
	
);
	
	
const int y_FRAME_SIZE =	479;
	
enum logic [1:0] {inactive, deploy, active} cur_st, nxt_st;



always_ff @(posedge clk or negedge resetN) // State machine logic ////
   begin
	   
   if ( !resetN ) 
	begin // Asynchronic reset
	
		cur_st <= inactive;
		
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
						
			end // inactive
			
			
			deploy: begin
			
			end
			
			active: begin
		
					
			end // active
					
		endcase

end // always next state ///////////////////////////////



always_comb // Update the outputs //////////////////////
  begin

	
	case (cur_st)
				
		inactive: begin

			
		end // inactive
							
		deploy: begin

			
		end
		
		active: begin
		
			
		end // active
	
	endcase
end // always outputs //////////////////////////////
	
	
	
assign col_present = 	col_rope_present1 || col_rope_present2 || col_rope_present3 ||
									col_player_present1 || col_player_present2 || col_player_present3;

	
endmodule
