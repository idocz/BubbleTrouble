//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	speedCalc	(	
					input	shortint Xspeed,
					input	shortint Yspeed,
					
					//ball1
					output shortint Xspeed1_out,
					
					//ball2
					output shortint Xspeed2_out,
					
					//both
					output shortint Yspeed_both

					
);

always_comb
begin

	if(Yspeed < 0)
		Yspeed_both = Yspeed;
	else
		Yspeed_both = -Yspeed;		
		
	//one ball goes right and another left
	Xspeed1_out = Xspeed;
	Xspeed2_out = -Xspeed;	
			
end

endmodule


