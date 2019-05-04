// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 


// Implements a slow clock as an one-second counter with
// a one-secound output pulse and a 0.5 Hz duty50 output

module blinkClk      	
	(
   // Input, Output Ports
   input  logic clk, resetN, 
   output logic blinkClk, blinkDuty50
   );
	
	localparam logic [25:0] blinkTime = 26'd5000000; // For real one sec clock
	logic  [25:0] blinkCount = 26'd0;
		
always_ff @( posedge clk or negedge resetN )
begin
	
      if ( !resetN ) 
		begin
			blinkClk <= 1'b0;
			blinkDuty50 <= 1'b0;
			blinkCount <= 26'd0;
		end 
			
      else 
		begin
		
			blinkCount <= blinkCount + 26'd1;
						
			if (blinkCount >= blinkTime) 
			begin
				blinkClk <= 1'b1;
				blinkDuty50 <= !blinkDuty50;
				blinkCount <= 26'd0;
			end
			else 
				blinkClk <= 1'b0;
			
		end	
end // always

endmodule