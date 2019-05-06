//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	playmodeInfo	(	

					input	logic	clk,
					input	logic	resetN,
					input 	logic	[10:0]	offsetX,
					input 	logic	[10:0]	offsetY,
					input		logic InsideRectangle,

					output	logic drawingRequest,
					output	logic	[7:0]	INFO_RGB
);


localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
localparam  int TITLE_OBJECT_WIDTH_X = 60;
localparam  int TITLE_OBJECT_HEIGHT_Y = 20;

logic [0:TITLE_OBJECT_HEIGHT_Y-1] [0:TITLE_OBJECT_WIDTH_X-1] [8-1:0] title = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hDA, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hB6, 8'h25, 8'h49, 8'hB6, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h6D, 8'h92, 8'hFF, 8'h6D, 8'hDA, 8'hFF, 8'hB6, 8'h6D, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hDA, 8'hFF, 8'hDA, 8'h6D, 8'hDB, 8'h49, 8'hB6, 8'h49, 8'hDB, 8'h6D, 8'hB6, 8'hFF, 8'hDB, 8'h49, 8'hB6, 8'hB6, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h49, 8'h49, 8'hFF, 8'hB6, 8'h92, 8'hFF, 8'hDB, 8'h6D, 8'hDB, 8'h49, 8'hFF, 8'h6D, 8'hDB, 8'h92, 8'h92, 8'hFF, 8'hFF, 8'h25, 8'h6D, 8'hB6, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hB6, 8'hDB, 8'h6D, 8'h49, 8'h6D, 8'hFF, 8'h92, 8'h6D, 8'hDB, 8'h92, 8'h6D, 8'hB6, 8'h6D, 8'hFF, 8'hFF, 8'h49, 8'hFF, 8'h49, 8'h49, 8'h24, 8'hB6, 8'hB6, 8'h92, 8'hFF, 8'hFF, 8'h49, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hFF, 8'hFF, 8'h6D, 8'h25, 8'h24, 8'h6D, 8'hB6, 8'h49, 8'hDB, 8'h49, 8'hDA, 8'h6D, 8'hDA, 8'hFF, 8'hFF, 8'h49, 8'hDA, 8'h6D, 8'hFF, 8'hFF, 8'h49, 8'hDB, 8'h49, 8'hB6, 8'hB6, 8'h49, 8'hB6, 8'h6D, 8'hFF, 8'hFF, 8'h49, 8'hB6, 8'hB6, 8'hDB, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'h49, 8'h49, 8'h92, 8'hFF, 8'hFF, 8'hDB, 8'hB6, 8'h6D, 8'hFF, 8'hDB, 8'h49, 8'hFF, 8'h6D, 8'hDA, 8'h6D, 8'hDA, 8'hFF, 8'hFF, 8'h49, 8'hB6, 8'h49, 8'hFF, 8'hFF, 8'h6D, 8'hDB, 8'h6D, 8'hDA, 8'hDB, 8'h49, 8'hDA, 8'h25, 8'h6D, 8'h92, 8'h92, 8'h49, 8'h6D, 8'hDB, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h6D, 8'h92, 8'hFF, 8'h92, 8'h92, 8'hFF, 8'hDB, 8'h49, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h49, 8'hFF, 8'hFF, 8'h49, 8'h25, 8'h49, 8'hFF, 8'h6D, 8'hB6, 8'hFF, 8'hFF, 8'h49, 8'hDB, 8'h49, 8'hDA, 8'hDB, 8'h49, 8'hFF, 8'h92, 8'h49, 8'h49, 8'hB6, 8'hFF, 8'h92, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'h6D, 8'h49, 8'h92, 8'hFF, 8'h49, 8'hB6, 8'h49, 8'hB6, 8'hB6, 8'h92, 8'hFF, 8'hFF, 8'h49, 8'hB6, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'hFF, 8'hFF, 8'h49, 8'hB6, 8'h6D, 8'hB6, 8'hB6, 8'h6D, 8'hFF, 8'hB6, 8'h49, 8'hFF, 8'hB6, 8'h49, 8'h49, 8'h92, 8'hFF, 8'hDB, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hB6, 8'hDB, 8'hFF, 8'h92, 8'h92, 8'hB6, 8'h6D, 8'hDA, 8'h49, 8'hFF, 8'h6D, 8'hFF, 8'h92, 8'hB6, 8'hB6, 8'h6D, 8'hFF, 8'hFF, 8'h49, 8'h49, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'hDB, 8'hFF, 8'h6D, 8'hDA, 8'hDA, 8'h49, 8'hFF, 8'h49, 8'h49, 8'h49, 8'hB6, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'h49, 8'h49, 8'h49, 8'hFF, 8'h6D, 8'hB6, 8'hFF, 8'hB6, 8'h6D, 8'hDA, 8'h6D, 8'hDB, 8'h49, 8'hFF, 8'h6D, 8'h49, 8'h24, 8'h92, 8'hDB, 8'h6D, 8'hFF, 8'hFF, 8'h6D, 8'hDA, 8'h123, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'hB6, 8'hFF, 8'h92, 8'hB6, 8'hFF, 8'h92, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'h49, 8'hFF, 8'h6D, 8'hB6, 8'h92, 8'h92, 8'hFF, 8'hDA, 8'h6D, 8'hDB, 8'h25, 8'h49, 8'h25, 8'hDB, 8'h6D, 8'h92, 8'hDB, 8'h49, 8'hDA, 8'h6D, 8'hFF, 8'hFF, 8'h6D, 8'h92, 8'hB6, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'h49, 8'hB6, 8'h49, 8'hDA, 8'hB6, 8'h6D, 8'hFF, 8'hDB, 8'h49, 8'hFF, 8'h49, 8'hFF, 8'hB6, 8'h6D, 8'h92, 8'h92, 8'hFF, 8'h49, 8'hDA, 8'h49, 8'h6D, 8'h6D, 8'h92, 8'h49, 8'h6D, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'h49, 8'h49, 8'h49, 8'h6D, 8'hB6, 8'h6D, 8'hFF, 8'hFF, 8'h49, 8'hFF, 8'h49, 8'hDB, 8'h92, 8'h6D, 8'hB6, 8'h25, 8'h49, 8'h6D, 8'hFF, 8'h92, 8'h92, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'h6D, 8'hB6, 8'hFF, 8'h49, 8'hDA, 8'h49, 8'hDB, 8'hB6, 8'h6D, 8'hFF, 8'h6D, 8'h49, 8'h49, 8'hDB, 8'hFF, 8'hB6, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'h92, 8'h92, 8'hB6, 8'h49, 8'hFF, 8'h92, 8'h49, 8'h49, 8'hDA, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hB6, 8'h49, 8'h6D, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, }
};



always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		INFO_RGB <=	8'hFF;
	end
	else begin
		if (InsideRectangle == 1'b1 )  // inside an external bracket 
			INFO_RGB <= title[offsetY/5][offsetX/5];	//get RGB from the colors table  
		else 
			INFO_RGB <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

// decide if to draw the pixel or not 
assign drawingRequest = (INFO_RGB != TRANSPARENT_ENCODING ) ? 1'b0 : 1'b0 ; // get optional transparent command from the bitmpap   


endmodule

