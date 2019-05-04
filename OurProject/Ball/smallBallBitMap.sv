//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 



module	smallBallBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket
					input logic visible, // visible state

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
);
// generating a smiley bitmap 

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
localparam  int OBJECT_WIDTH_X = 20;
localparam  int OBJECT_HEIGHT_Y = 20;

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h9B, 8'h56, 8'h32, 8'h12, 8'h12, 8'h36, 8'h56, 8'h9B, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hBB, 8'h32, 8'h13, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h37, 8'h56, 8'hBB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'h9B, 8'h12, 8'h17, 8'h12, 8'h0E, 8'h12, 8'h17, 8'h17, 8'h12, 8'h0E, 8'h12, 8'h37, 8'h57, 8'h9B, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hBB, 8'h12, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h36, 8'hBB, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'h32, 8'h17, 8'h17, 8'h17, 8'h17, 8'h12, 8'h29, 8'h0E, 8'h13, 8'h2D, 8'h0E, 8'h17, 8'h17, 8'h17, 8'h17, 8'h36, 8'hFF, 8'hFF, },
{8'hFF, 8'h97, 8'h12, 8'h17, 8'h17, 8'h17, 8'h17, 8'h09, 8'h20, 8'h05, 8'h0E, 8'h24, 8'h05, 8'h17, 8'h17, 8'h17, 8'h17, 8'h13, 8'h9B, 8'hFF, },
{8'hFF, 8'h52, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h0E, 8'h05, 8'h0E, 8'h12, 8'h09, 8'h12, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h56, 8'hFF, },
{8'hFF, 8'h32, 8'h17, 8'h17, 8'h12, 8'h13, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h32, 8'hDF, },
{8'hDB, 8'h12, 8'h17, 8'h12, 8'h2E, 8'h56, 8'h56, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h17, 8'h36, 8'h52, 8'h0E, 8'h12, 8'h17, 8'h12, 8'hDB, },
{8'hDB, 8'h12, 8'h17, 8'h12, 8'h49, 8'h88, 8'hB1, 8'h96, 8'h37, 8'h17, 8'h17, 8'h17, 8'h76, 8'hB1, 8'h84, 8'h45, 8'h0E, 8'h17, 8'h12, 8'hDB, },
{8'hFF, 8'h32, 8'h17, 8'h12, 8'h65, 8'h80, 8'h80, 8'h89, 8'h8D, 8'h76, 8'h76, 8'h91, 8'h89, 8'h80, 8'h80, 8'h64, 8'h0E, 8'h17, 8'h32, 8'hDF, },
{8'hFF, 8'h52, 8'h17, 8'h17, 8'h49, 8'h80, 8'h80, 8'h80, 8'h80, 8'h84, 8'h84, 8'h80, 8'h80, 8'h80, 8'h80, 8'h49, 8'h12, 8'h17, 8'h56, 8'hFF, },
{8'hFF, 8'h96, 8'h12, 8'h17, 8'h12, 8'h65, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h64, 8'h12, 8'h17, 8'h13, 8'h96, 8'hFF, },
{8'hFF, 8'hFF, 8'h32, 8'h17, 8'h17, 8'h12, 8'h6D, 8'h89, 8'hA9, 8'hC4, 8'hC5, 8'hC9, 8'h89, 8'h6D, 8'h32, 8'h17, 8'h17, 8'h32, 8'hDF, 8'hFF, },
{8'hFF, 8'hFF, 8'hBB, 8'h12, 8'h17, 8'h17, 8'h17, 8'h36, 8'h56, 8'h76, 8'h72, 8'h56, 8'h36, 8'h17, 8'h17, 8'h17, 8'h12, 8'hBB, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'h96, 8'h32, 8'h17, 8'h17, 8'h13, 8'h12, 8'h17, 8'h17, 8'h12, 8'h17, 8'h17, 8'h17, 8'h12, 8'h96, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hBB, 8'h52, 8'h12, 8'h13, 8'h0E, 8'h12, 8'h0E, 8'h12, 8'h13, 8'h12, 8'h32, 8'hBA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h96, 8'h52, 8'h32, 8'h12, 8'h12, 8'h32, 8'h52, 8'h96, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, }
};

// pipeline (ff) to get the pixel color from the array 	 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		if (InsideRectangle == 1'b1 && visible == 1'b1 )  // inside an external bracket 
			RGBout <= object_colors[offsetY][offsetX];	//get RGB from the colors table  
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule