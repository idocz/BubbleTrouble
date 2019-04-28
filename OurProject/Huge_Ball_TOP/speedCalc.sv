//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	speedCalc	(	
					input	int Xspeed,
					input	int Yspeed,
					
					//ball1
					output int Xspeed1_out,
					
					//ball2
					output int Xspeed2_out,
					
					//both
					output int Yspeed_both

					
);

always_comb
begin

	if(Yspeed < 0)
		Yspeed_both = Yspeed;
	else
		Yspeed_both = -Yspeed;		
		
	Xspeed1_out = Xspeed;
	Xspeed2_out = -Xspeed;	
			
end

endmodule


