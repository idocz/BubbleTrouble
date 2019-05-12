

module risingEdge15
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input	logic	 signal1,
	input	logic	 signal2,
	input	logic	 signal3,
	input	logic	 signal4,
	input	logic	 signal5,
	input	logic	 signal6,
	input	logic	 signal7,
	input	logic	 signal8,
	input	logic	 signal9,
	input	logic	 signal10,
	input	logic	 signal11,
	input	logic	 signal12,
	input	logic	 signal13,
	input	logic	 signal14,
	input	logic	 signal15,
	input	logic	 signal16,
	input	logic	 signal17,

	
	
	output logic  RE1,
	output logic  RE2,
	output logic  RE3,
	output logic  RE4,
	output logic  RE5,
	output logic  RE6,
	output logic  RE7,
	output logic  RE8,
	output logic  RE9,
	output logic  RE10,
	output logic  RE11,
	output logic  RE12,
	output logic  RE13,
	output logic  RE14,
	output logic  RE15,
	output logic  RE16,
	output logic  RE17

	
	
  ) ;

  
logic signal_d1, signal_d2, signal_d3, signal_d4, signal_d5, signal_d6, signal_d7, 
		signal_d8, signal_d9, signal_d10, signal_d11, signal_d12, signal_d13, signal_d14,
		signal_d15, signal_d16, signal_d17;
	
	
always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			RE1 <= 1'b0;
			RE2 <= 1'b0;
			RE3 <= 1'b0;
			RE4 <= 1'b0;
			RE5 <= 1'b0;
			RE6 <= 1'b0;
			RE7 <= 1'b0;
			RE8 <= 1'b0;
			RE9 <= 1'b0;
			RE10 <= 1'b0;
			RE11 <= 1'b0;
			RE12 <= 1'b0;
			RE13 <= 1'b0;
			RE14 <= 1'b0;
			RE15 <= 1'b0;
			RE16 <= 1'b0;
			RE17 <= 1'b0;
			
		end
		else begin
		// Rising Edge for signal1
			signal_d1 <= signal1;
			if (signal1 && !signal_d1) // rising edge 
				RE1 <= 1'b1;
			else
				RE1 <= 1'b0;
			
		// Rising Edge for signal2
			signal_d2 <= signal2;
			if (signal2 && !signal_d2) // rising edge 
				RE2 <= 1'b1;
			else
				RE2 <= 1'b0;
			
		// Rising Edge for signal3
			signal_d3 <= signal3;
			if (signal3 && !signal_d3) // rising edge 
				RE3 <= 1'b1;
			else
				RE3 <= 1'b0;
			
		// Rising Edge for signal4
			signal_d4 <= signal4;
			if (signal4 && !signal_d4) // rising edge 
				RE4 <= 1'b1;
			else
				RE4 <= 1'b0;
			
		// Rising Edge for signal5
			signal_d5 <= signal5;
			if (signal5 && !signal_d5) // rising edge 
				RE5 <= 1'b1;
			else
				RE5 <= 1'b0;
			
		// Rising Edge for signal6
			signal_d6 <= signal6;
			if (signal6 && !signal_d6) // rising edge 
				RE6 <= 1'b1;
			else
				RE6 <= 1'b0;
			
		// Rising Edge for signal7
			signal_d7 <= signal7;
			if (signal7 && !signal_d7) // rising edge 
				RE7 <= 1'b1;
			else
				RE7 <= 1'b0;
			
		// Rising Edge for signal8
			signal_d8 <= signal8;
			if (signal8 && !signal_d8) // rising edge 
				RE8 <= 1'b1;
			else
				RE8 <= 1'b0;
			
		// Rising Edge for signal9
			signal_d9 <= signal9;
			if (signal9 && !signal_d9) // rising edge 
				RE9 <= 1'b1;
			else
				RE9 <= 1'b0;
			
		// Rising Edge for signal10
			signal_d10 <= signal10;
			if (signal10 && !signal_d10) // rising edge 
				RE10 <= 1'b1;
			else
				RE10 <= 1'b0;
			
		// Rising Edge for signal11
			signal_d11 <= signal11;
			if (signal11 && !signal_d11) // rising edge 
				RE11 <= 1'b1;
			else
				RE11 <= 1'b0;
			
		// Rising Edge for signal12
			signal_d12 <= signal12;
			if (signal12 && !signal_d12) // rising edge 
				RE12 <= 1'b1;
			else
				RE12 <= 1'b0;
			
		// Rising Edge for signal13
			signal_d13 <= signal13;
			if (signal13 && !signal_d13) // rising edge 
				RE13 <= 1'b1;
			else
				RE13 <= 1'b0;
			
		// Rising Edge for signal14
			signal_d14 <= signal14;
			if (signal14 && !signal_d14) // rising edge 
				RE14 <= 1'b1;
			else
				RE14 <= 1'b0;
			
		// Rising Edge for signal15
			signal_d15 <= signal15;
			if (signal15 && !signal_d15) // rising edge 
				RE15 <= 1'b1;
			else
				RE15 <= 1'b0;
			
		// Rising Edge for signal16
			signal_d16 <= signal16;
			if (signal16 && !signal_d16) // rising edge 
				RE16 <= 1'b1;
			else
				RE16 <= 1'b0;
			
		// Rising Edge for signal17
			signal_d17 <= signal17;
			if (signal17 && !signal_d17) // rising edge 
				RE17 <= 1'b1;
			else
				RE17 <= 1'b0;	
				
		end
	
	end
 
endmodule

