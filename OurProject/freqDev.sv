// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 


// Implements a slow clock as an one-second counter with
// a one-secound output pulse and a 0.5 Hz duty50 output

module freqDev      	
	(
   // Input, Output Ports
   input  logic clk, resetN, 
   output logic slowClk, duty50
   );
	
	parameter devider = 2; // For real one sec clock
	logic  [25:0] count = 26'd0;
		
always_ff @( posedge clk or negedge resetN )
begin
	
      if ( !resetN ) 
		begin
			slowClk <= 1'b0;
			duty50 <= 1'b0;
			count <= 26'd0;
		end 
			
      else 
		begin
		
			count <= count + 26'd1;
						
			if (count >= devider) 
			begin
				slowClk <= 1'b1;
				duty50 <= !duty50;
				count <= 26'd0;
			end
			else 
				slowClk <= 1'b0;
			
		end	
end // always

endmodule