//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 



module	mediumBallBitMap	(	
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
localparam  int OBJECT_WIDTH_X = 35;
localparam  int OBJECT_HEIGHT_Y = 35;

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h89, 8'hB2, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'hAD, 8'hCD, 8'h8D, 8'h8D, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h8D, 8'hAD, 8'h89, 8'h89, 8'hCD, 8'hCD, 8'hCD, 8'hB2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h88, 8'hA8, 8'hED, 8'hEC, 8'hEC, 8'hEC, 8'hCD, 8'h8D, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFB, 8'hB6, 8'h72, 8'h69, 8'hCC, 8'hCD, 8'hED, 8'hEC, 8'hAD, 8'h76, 8'h76, 8'h72, 8'h72, 8'h72, 8'h92, 8'hB6, 8'hFB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h92, 8'h72, 8'h76, 8'h9B, 8'hB2, 8'hA8, 8'hCD, 8'hCD, 8'hCD, 8'h76, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'h76, 8'h72, 8'h92, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h72, 8'h76, 8'h9B, 8'h9B, 8'h9B, 8'h97, 8'h91, 8'hCD, 8'h8D, 8'h92, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'h72, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h72, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h96, 8'h8D, 8'h77, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'h92, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h76, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'h92, 8'hFB, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h76, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'h96, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hB6, 8'h72, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'hBA, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'h72, 8'h77, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h96, 8'hFF, 8'hFF, },
{8'hFF, 8'hB6, 8'h76, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h97, 8'hDA, 8'hFF, },
{8'hFF, 8'h92, 8'h77, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'h72, 8'h77, 8'h97, 8'h96, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'hB6, 8'hFF, },
{8'hFF, 8'h92, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h76, 8'h72, 8'h52, 8'h76, 8'h9B, 8'h9B, 8'h76, 8'h72, 8'h76, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h92, 8'hFF, },
{8'hDB, 8'h76, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'h72, 8'h6D, 8'h4D, 8'h9B, 8'h76, 8'h6E, 8'h6E, 8'h97, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h72, 8'hFF, },
{8'hDB, 8'h76, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h97, 8'h97, 8'h72, 8'h49, 8'h49, 8'h97, 8'h72, 8'h6D, 8'h49, 8'h72, 8'h97, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h76, 8'h72, 8'h76, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h72, 8'hDB, },
{8'hDB, 8'h76, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h76, 8'h76, 8'h4E, 8'h72, 8'h9B, 8'h76, 8'h4D, 8'h4E, 8'h76, 8'h77, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'h77, 8'h7B, 8'h96, 8'h97, 8'h9B, 8'h9B, 8'h9B, 8'h72, 8'hFB, },
{8'hDB, 8'h96, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'h72, 8'h76, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h76, 8'h76, 8'h92, 8'h6D, 8'h96, 8'h9B, 8'h76, 8'h9B, 8'h9B, 8'h9B, 8'h72, 8'hFF, },
{8'hDB, 8'h96, 8'h9B, 8'h9B, 8'h77, 8'h72, 8'h77, 8'h7B, 8'h76, 8'h76, 8'h77, 8'h77, 8'h77, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'h77, 8'h76, 8'h76, 8'h96, 8'h92, 8'h92, 8'h92, 8'h89, 8'h72, 8'h76, 8'h76, 8'h9B, 8'h9B, 8'h77, 8'h92, 8'hFF, },
{8'hFF, 8'h92, 8'h9B, 8'h9B, 8'h76, 8'h77, 8'h9B, 8'h6D, 8'h69, 8'hB6, 8'h92, 8'h92, 8'h96, 8'h72, 8'h96, 8'h96, 8'h92, 8'h72, 8'h96, 8'hB6, 8'h6D, 8'hB2, 8'hB6, 8'h8D, 8'h85, 8'h85, 8'h69, 8'h76, 8'h76, 8'h9B, 8'h9B, 8'h9B, 8'h76, 8'hDA, 8'hFF, },
{8'hFF, 8'h96, 8'h97, 8'h9B, 8'h96, 8'h9B, 8'h97, 8'h89, 8'h85, 8'h89, 8'h89, 8'h8D, 8'hB2, 8'h89, 8'h8E, 8'hB6, 8'h8E, 8'h89, 8'h8E, 8'h8E, 8'h85, 8'h85, 8'h89, 8'h8D, 8'h89, 8'h6D, 8'h76, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h92, 8'hFF, 8'hFF, },
{8'hFF, 8'hB6, 8'h76, 8'h9B, 8'h97, 8'h97, 8'h9B, 8'h72, 8'h89, 8'h85, 8'h85, 8'h85, 8'h89, 8'h89, 8'h85, 8'h85, 8'h89, 8'h89, 8'h89, 8'h89, 8'hB2, 8'h8E, 8'h6E, 8'h72, 8'h72, 8'h7B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'hB6, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'h92, 8'h9B, 8'h9B, 8'h77, 8'h9B, 8'h9B, 8'h76, 8'h6E, 8'h69, 8'h92, 8'h92, 8'h6D, 8'h92, 8'h6D, 8'h92, 8'h6E, 8'h96, 8'h72, 8'h72, 8'h76, 8'h77, 8'h7B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h72, 8'hDB, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hB6, 8'h96, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'h77, 8'h76, 8'h76, 8'h76, 8'h76, 8'h76, 8'h76, 8'h77, 8'h7B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'h96, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h97, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h76, 8'h72, 8'h72, 8'h76, 8'h76, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h72, 8'hDB, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h92, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h72, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'h96, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h76, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h96, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h77, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h96, 8'h97, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h76, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h97, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h76, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFB, 8'h92, 8'h96, 8'h9B, 8'h9B, 8'h9B, 8'h97, 8'h76, 8'h97, 8'h9B, 8'h9B, 8'h77, 8'h77, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'h72, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFB, 8'h92, 8'h72, 8'h9B, 8'h9B, 8'h9B, 8'h76, 8'h72, 8'h72, 8'h72, 8'h72, 8'h77, 8'h9B, 8'h9B, 8'h77, 8'h72, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h72, 8'h72, 8'h76, 8'h77, 8'h77, 8'h77, 8'h77, 8'h77, 8'h77, 8'h72, 8'h72, 8'h92, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hB6, 8'h92, 8'h92, 8'h6E, 8'h72, 8'h92, 8'h96, 8'hB6, 8'hFB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, }
};

// pipeline (ff) to get the pixel color from the array 	 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		if (InsideRectangle == 1'b1 && visible == 1'b1 )  // inside an external bracket 
			RGBout <= object_colors[offsetY/2][offsetX/2];	//get RGB from the colors table  
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule