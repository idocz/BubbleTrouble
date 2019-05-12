

module risingEdge	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input	logic	 signal,
	output logic  RE
  ) ;

// Generating a random number by latching a fast counter with the rising edge of an input ( e.g. key pressed )
  
logic signal_d;
	
	
always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			signal_d <= 1'b0;
		end
		
		else begin
			signal_d <= signal;
			if (signal && !signal_d) // rising edge 
				RE <= 1'b1;
			else
				RE <= 1'b0;
		end
	
	end
 
endmodule

