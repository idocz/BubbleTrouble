//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	speedCalc	(	
					input		logic [10:0]	Xspeed,
					input		logic [10:0]   Yspeed,
					
					//ball1
					output   logic [10:0] Xspeed1_out,
					
					//ball2
					output   logic [10:0] Xspeed2_out,
					
					//both
					output   logic [10:0] Yspeed_both

					
);




always_comb
begin

Yspeed_both = (Yspeed < 0) ? Yspeed : -Yspeed;
Xspeed1_out = Xspeed;
Xspeed2_out = -Xspeed; 


end
endmodule


