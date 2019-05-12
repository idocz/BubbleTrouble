

module Chance	
 ( 
	input	logic[5:0]	signal,
	output logic  out
  ) ;

  

parameter devider = 4;
parameter max = 60;
	
always_comb
begin
	
	if( signal <= max/devider)
		out = 1;
	else 
		out = 0;
end
		
 
endmodule

