// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 


// Implements a slow clock as an one-second counter with
// a one-secound output pulse and a 0.5 Hz duty50 output

module secClk      	
	(
   // Input, Output Ports
   input  logic clk, resetN, 
   output logic secClk, duty50
   );
	
	localparam logic [25:0] oneSec = 26'd50000000; // For real one sec clock
	logic  [25:0] oneSecCount = 26'd0;
		
always_ff @( posedge clk or negedge resetN )
begin
	
      if ( !resetN ) 
		begin
			secClk <= 1'b0;
			duty50 <= 1'b0;
			oneSecCount <= 26'd0;
		end 
			
      else 
		begin
		
			oneSecCount <= oneSecCount + 26'd1;
						
			if (oneSecCount >= oneSec) 
			begin
				secClk <= 1'b1;
				duty50 <= !duty50;
				oneSecCount <= 26'd0;
			end
			else 
				secClk <= 1'b0;
			
		end	
end // always

endmodule