// (c) Technion IIT, Department of Electrical Engineering 2018 
// Updated by Liat Schwartz March 2019 

// Implements a simple traffic lights controller
// by using state machine with present and next states wvf6

module levelStateMachine 	(

	input logic clk, resetN,
	input logic enable,
	input shortint score,
	input logic ball1InUse, ball2InUse, ball3InUse,
	input logic secClk,
	
	//Ball1 output
	output logic ball1Active,
	output logic [1:0] ball1InitialState,
	
	//ball2 output
	output logic ball2Active,
	output logic [1:0] ball2InitialState,
	
	//ball3 output
	output logic ball3Active,
	output logic [1:0] ball3InitialState,
	
	//level
	output logic [3:0] level
);
	
enum logic [3:0] { L0, L1, L2, L3, L4, L5, L6, L7, L8, L9, L10, L11, L12 } cur_st, nxt_st;

logic nxt_ball1Active, nxt_ball2Active, nxt_ball3Active;
logic [1:0] nxt_ball1InitialState, nxt_ball2InitialState, nxt_ball3InitialState;

parameter score2 = 10;
parameter score3 = 10;
parameter score4 = 10;
parameter score5 = 10;
parameter score6 = 10;
parameter score7 = 10;
parameter score8 = 10;
parameter score9 = 10;
parameter score10 = 10;
parameter score11 = 10;
parameter score12 = 10;


always_ff @(posedge clk or negedge resetN) // State machine logic ////
   begin
	   
   if ( !resetN ) begin // Asynchronic reset
	
		cur_st <= L0;
		ball1Active <= 0;
		ball2Active <= 0;
		ball3Active <= 0;
		
		ball1InitialState <= 0;
		ball2InitialState <= 0;
		ball3InitialState <= 0;
	
	end // asynch
	
	else 
	begin  // Synchronic logic
	
		cur_st <= nxt_st; // Update current state
		
		ball1Active <= nxt_ball1Active;
		ball2Active <= nxt_ball2Active;
		ball3Active <= nxt_ball3Active;
		
		ball1InitialState <= nxt_ball1InitialState;
		ball2InitialState <= nxt_ball2InitialState;
		ball3InitialState <= nxt_ball3InitialState;
		
	end 
		
end


always_comb // Update the next state  ////////////////////////////////
begin

	nxt_st = cur_st;	// Set default values
	
	if ( enable )
	begin
	
		if(score > score12)
			nxt_st = L12;
		
		else if(score > score11)
			nxt_st = L11;
			
		else if(score > score10)
			nxt_st = L10;
			
		else if(score > score9)
			nxt_st = L9;
			
		else if(score > score8)
			nxt_st = L8;
			
		else if(score > score7)
			nxt_st = L7;
			
		else if(score > score6)
			nxt_st = L6;
			
		else if(score > score5)
			nxt_st = L5;
			
		else if(score > score4)
			nxt_st = L4;
			
		else if(score > score3)
			nxt_st = L3;
			
		else if(score > score2)
			nxt_st = L2;
			
		else
			nxt_st = L1;
			
	end
	else
		nxt_st = L0;
		
end
	
always_comb //update outputs
begin

		nxt_ball1Active = ball1Active;
		nxt_ball2Active = ball2Active;
		nxt_ball3Active = ball3Active;
		
		nxt_ball1InitialState = ball1InitialState;
		nxt_ball2InitialState = ball2InitialState;
		nxt_ball3InitialState = ball3InitialState;
		
		case (cur_st)
					
			L0: 
			begin
				nxt_ball1Active = 0;
				nxt_ball2Active = 0;
				nxt_ball3Active = 0;
			end
			
			
			L1: 
			begin
			
				if( !ball1InUse )
				begin
				
					nxt_ball1InitialState = 0;
					
					if ( ball1Active == 0 )
						nxt_ball1Active = 1;
					else
						nxt_ball1Active = 0;
						
				end
				
			end 
							
			L2: 
			begin
			
				if( !ball1InUse )
				begin
					nxt_ball1InitialState = 0;
					
					if ( ball1Active == 0 )
						nxt_ball1Active = 1;
					else
						nxt_ball1Active = 0;
						
				end
				
				if( !ball2InUse )
				begin
					nxt_ball2InitialState = 0;
					
					if ( ball2Active == 0 )
						nxt_ball2Active = 1;
					else
						nxt_ball2Active = 0;
						
				end	

				
			end  
			
			L3: 
			begin
			
				if( !ball1InUse )
				begin
					nxt_ball1InitialState = 0;
					
					if ( ball1Active == 0 )
						nxt_ball1Active = 1;
					else
						nxt_ball1Active = 0;
						
				end
				
				if( !ball2InUse )
				begin
					nxt_ball2InitialState = 0;
					
					if ( ball2Active == 0 )
						nxt_ball2Active = 1;
					else
						nxt_ball2Active = 0;
						
				end
			
				if( !ball3InUse )
				begin
					nxt_ball3InitialState = 0;
					
					if ( ball3Active == 0 )
						nxt_ball3Active = 1;
					else
						nxt_ball3Active = 0;
						
				end	
			
			end  

			L4: 
			begin
			
				if( !ball1InUse )
				begin
					nxt_ball1InitialState = 1;
					
					if ( ball1Active == 0 )
						nxt_ball1Active = 1;
					else
						nxt_ball1Active = 0;
						
				end
				
			end 
							
			L5: 
			begin
			
				if( !ball1InUse )
				begin
					nxt_ball1InitialState = 1;
					
					if ( ball1Active == 0 )
						nxt_ball1Active = 1;
					else
						nxt_ball1Active = 0;
						
				end
				
				if( !ball2InUse )
				begin
					nxt_ball2InitialState = 1;
					
					if ( ball2Active == 0 )
						nxt_ball2Active = 1;
					else
						nxt_ball2Active = 0;
						
				end	
				
			end  
			
			L6: 
			begin
			
				if( !ball1InUse )
				begin
					nxt_ball1InitialState = 1;
					
					if ( ball1Active == 0 )
						nxt_ball1Active = 1;
					else
						nxt_ball1Active = 0;
						
				end
				
				if( !ball2InUse )
				begin
					nxt_ball2InitialState = 1;
					
					if ( ball2Active == 0 )
						nxt_ball2Active = 1;
					else
						nxt_ball2Active = 0;
						
				end
			
				if( !ball3InUse )
				begin
					nxt_ball3InitialState = 1;
					
					if ( ball3Active == 0 )
						nxt_ball3Active = 1;
					else
						nxt_ball3Active = 0;
						
				end	
			
			end 			

			L7: 
			begin
			
				if( !ball1InUse )
				begin
					nxt_ball1InitialState = 2;
					
					if ( ball1Active == 0 )
						nxt_ball1Active = 1;
					else
						nxt_ball1Active = 0;
						
				end
				
			end 
							
			L8: 
			begin
			
				if( !ball1InUse )
				begin
					nxt_ball1InitialState = 2;
					
					if ( ball1Active == 0 )
						nxt_ball1Active = 1;
					else
						nxt_ball1Active = 0;
						
				end
				
				if( !ball2InUse )
				begin
					nxt_ball2InitialState = 2;
					
					if ( ball2Active == 0 )
						nxt_ball2Active = 1;
					else
						nxt_ball2Active = 0;
						
				end	
				
			end  
			
			L9: 
			begin
			
				if( !ball1InUse )
				begin
					nxt_ball1InitialState = 2;
					
					if ( ball1Active == 0 )
						nxt_ball1Active = 1;
					else
						nxt_ball1Active = 0;
						
				end
				
				if( !ball2InUse )
				begin
					nxt_ball2InitialState = 2;
					
					if ( ball2Active == 0 )
						nxt_ball2Active = 1;
					else
						nxt_ball2Active = 0;
						
				end
			
				if( !ball3InUse )
				begin
					nxt_ball3InitialState = 2;
					
					if ( ball3Active == 0 )
						nxt_ball3Active = 1;
					else
						nxt_ball3Active = 0;
						
				end	
			
			end 

			L10: 
			begin
			
				if( !ball1InUse )
				begin
					nxt_ball1InitialState = 3;
					
					if ( ball1Active == 0 )
						nxt_ball1Active = 1;
					else
						nxt_ball1Active = 0;
						
				end
				
			end 
							
			L11: 
			begin
			
				if( !ball1InUse )
				begin
					nxt_ball1InitialState = 3;
					
					if ( ball1Active == 0 )
						nxt_ball1Active = 1;
					else
						nxt_ball1Active = 0;
						
				end
				
				if( !ball2InUse )
				begin
					nxt_ball2InitialState = 3;
					
					if ( ball1Active == 0 )
						nxt_ball2Active = 1;
					else
						nxt_ball2Active = 0;
						
				end	
				
			end  
			
			L12: 
			begin
			
				if( !ball1InUse )
				begin
					nxt_ball1InitialState = 3;
					
					if ( ball1Active == 0 )
						nxt_ball1Active = 1;
					else
						nxt_ball1Active = 0;
						
				end
				
				if( !ball2InUse )
				begin
					nxt_ball2InitialState = 3;
					
					if ( ball2Active == 0 )
						nxt_ball2Active = 1;
					else
						nxt_ball2Active = 0;
						
				end
			
				if( !ball3InUse )
				begin
					nxt_ball3InitialState = 3;
					
					if ( ball3Active == 0 )
						nxt_ball3Active = 1;
					else
						nxt_ball3Active = 0;
						
				end	
			
			end 
					
		endcase

end 

assign level = cur_st;

endmodule
