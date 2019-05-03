//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 



module	presentBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket
					input logic [1:0] present_type,
					input logic visible, // visible state

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
);
// generating a smiley bitmap 

localparam  int OBJECT_WIDTH_X = 25;
localparam  int OBJECT_HEIGHT_Y = 25;
localparam  int PRESENT_NUM = 4;

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

logic [0:PRESENT_NUM-1] [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [7:0] object_colors = {

{//life

{8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h97, 8'h72, 8'h96, 8'h97, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h72, 8'h4D, 8'h49, 8'h96, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, },
{8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h96, 8'h49, 8'h72, 8'h4D, 8'h4D, 8'h96, 8'hBB, 8'hBB, 8'h72, 8'h49, 8'h4D, 8'h76, 8'h4D, 8'h96, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, },
{8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h97, 8'h4D, 8'h72, 8'h72, 8'h72, 8'h49, 8'h6E, 8'h4D, 8'h4E, 8'h72, 8'h72, 8'h97, 8'h4D, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, },
{8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h4D, 8'h6E, 8'h72, 8'h97, 8'h97, 8'h4E, 8'h72, 8'h97, 8'h76, 8'h97, 8'h76, 8'h4D, 8'hBB, 8'hBB, 8'hBB, 8'h97, 8'h72, 8'h96, 8'hBB, },
{8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h49, 8'h72, 8'h97, 8'h97, 8'h97, 8'h9B, 8'h9B, 8'h97, 8'h97, 8'h97, 8'h72, 8'h4D, 8'h97, 8'h92, 8'h6E, 8'h49, 8'h49, 8'h72, 8'hBB, },
{8'h97, 8'h49, 8'h4D, 8'h4D, 8'h4D, 8'h4D, 8'h49, 8'h72, 8'h9B, 8'h97, 8'h72, 8'h4E, 8'h4D, 8'h4E, 8'h72, 8'h97, 8'h72, 8'h49, 8'h4D, 8'h4E, 8'h72, 8'h97, 8'h4E, 8'h96, 8'hBB, },
{8'h97, 8'h49, 8'h97, 8'h97, 8'h97, 8'h97, 8'h97, 8'h97, 8'h72, 8'h49, 8'h6D, 8'hB2, 8'hB6, 8'h92, 8'h6D, 8'h49, 8'h76, 8'h9B, 8'h97, 8'h97, 8'h97, 8'h97, 8'h4D, 8'hBB, 8'hBB, },
{8'hBB, 8'h4D, 8'h72, 8'h97, 8'h97, 8'h97, 8'h97, 8'h76, 8'h49, 8'hD6, 8'hFB, 8'hDB, 8'hDA, 8'hDB, 8'hFB, 8'hB6, 8'h49, 8'h76, 8'h97, 8'h97, 8'h97, 8'h72, 8'h72, 8'hBB, 8'hBB, },
{8'hBB, 8'h96, 8'h4D, 8'h97, 8'h97, 8'h97, 8'h97, 8'h49, 8'h92, 8'hB6, 8'h72, 8'h72, 8'h6E, 8'h6E, 8'h72, 8'h96, 8'h92, 8'h49, 8'h97, 8'h97, 8'h97, 8'h49, 8'h6E, 8'h49, 8'h72, },
{8'hBB, 8'hBB, 8'h6D, 8'h72, 8'h97, 8'h97, 8'h76, 8'h49, 8'h72, 8'h72, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'h6E, 8'h92, 8'h6D, 8'h72, 8'h9B, 8'h76, 8'h4E, 8'h72, 8'h72, 8'h6E, },
{8'hBB, 8'hBB, 8'hBB, 8'h49, 8'h76, 8'h9B, 8'h72, 8'h91, 8'hB6, 8'h92, 8'hB6, 8'hDA, 8'hFF, 8'hD6, 8'hB6, 8'hB6, 8'hDA, 8'hB6, 8'h49, 8'h97, 8'h97, 8'h97, 8'h9B, 8'h4E, 8'h72, },
{8'hBB, 8'hBB, 8'h6E, 8'h4D, 8'h97, 8'h9B, 8'h4D, 8'hB2, 8'hB6, 8'hDB, 8'hDB, 8'h92, 8'hB6, 8'h92, 8'hDB, 8'hB6, 8'hB6, 8'hDA, 8'h49, 8'h97, 8'h97, 8'h97, 8'h97, 8'h49, 8'h97, },
{8'hBB, 8'h4D, 8'h4D, 8'h97, 8'h97, 8'h97, 8'h49, 8'hB6, 8'hDA, 8'hDA, 8'hDB, 8'hB6, 8'h92, 8'hFF, 8'hB6, 8'hFF, 8'h92, 8'hDB, 8'h6D, 8'h76, 8'h97, 8'h97, 8'h4D, 8'h6E, 8'hBB, },
{8'h72, 8'h49, 8'h97, 8'h9B, 8'h97, 8'h97, 8'h49, 8'hB6, 8'hB6, 8'hDB, 8'hDB, 8'hB6, 8'h92, 8'hFF, 8'hB6, 8'hFF, 8'h92, 8'hDB, 8'h6D, 8'h72, 8'h97, 8'h72, 8'h4D, 8'hBB, 8'hBB, },
{8'h6D, 8'h49, 8'h49, 8'h4E, 8'h77, 8'h97, 8'h49, 8'hDA, 8'hB6, 8'hB6, 8'h92, 8'hB6, 8'hDA, 8'h92, 8'hDB, 8'hB6, 8'hB6, 8'hFF, 8'h6D, 8'h76, 8'h72, 8'h49, 8'h97, 8'hBB, 8'hBB, },
{8'hBB, 8'hBB, 8'h96, 8'h4D, 8'h4D, 8'h72, 8'h49, 8'hDA, 8'hB6, 8'h92, 8'hB2, 8'hDA, 8'hDA, 8'hB6, 8'h92, 8'h92, 8'h92, 8'hDB, 8'h4D, 8'h72, 8'h97, 8'h4D, 8'h49, 8'h4D, 8'h92, },
{8'hBB, 8'hBB, 8'hBB, 8'h4D, 8'h72, 8'h49, 8'h49, 8'hDA, 8'hDB, 8'hDA, 8'hDB, 8'hB2, 8'hB6, 8'hB6, 8'hDA, 8'hB6, 8'hDB, 8'hDB, 8'h49, 8'h49, 8'h72, 8'h9B, 8'h97, 8'h49, 8'h72, },
{8'hBB, 8'hBB, 8'h4D, 8'h72, 8'h72, 8'h91, 8'h6D, 8'hB6, 8'hFB, 8'hDB, 8'hDB, 8'hB2, 8'hB6, 8'hB6, 8'hFF, 8'hFB, 8'hDB, 8'hDA, 8'h49, 8'h92, 8'h4D, 8'h9B, 8'h72, 8'h49, 8'hBB, },
{8'hBB, 8'h92, 8'h4D, 8'h9B, 8'h76, 8'h49, 8'h49, 8'hB6, 8'hDA, 8'hDB, 8'hFF, 8'hB6, 8'h6D, 8'hDA, 8'hFF, 8'hB6, 8'hDA, 8'hB6, 8'h29, 8'h6D, 8'h76, 8'h72, 8'h49, 8'h96, 8'hBB, },
{8'hBB, 8'h49, 8'h72, 8'h76, 8'h76, 8'h72, 8'h4D, 8'h91, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hDA, 8'hB6, 8'h92, 8'hB6, 8'hDA, 8'h6D, 8'h4E, 8'h97, 8'h4D, 8'h6E, 8'hBB, 8'hBB, 8'hBB, },
{8'h97, 8'h4D, 8'h6E, 8'h6E, 8'h72, 8'h49, 8'h72, 8'h49, 8'hDA, 8'hDA, 8'hB6, 8'h92, 8'h92, 8'h92, 8'hB6, 8'hDB, 8'hDA, 8'h29, 8'h77, 8'h76, 8'h49, 8'hBB, 8'hBB, 8'hBB, 8'hBB, },
{8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h49, 8'h76, 8'h4D, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hB6, 8'h92, 8'h49, 8'h4E, 8'h9B, 8'h77, 8'h49, 8'hBB, 8'hBB, 8'hBB, 8'hBB, },
{8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h96, 8'h25, 8'h4D, 8'h49, 8'h4D, 8'h6D, 8'hB6, 8'hB6, 8'hB6, 8'h6D, 8'h6D, 8'h49, 8'h4D, 8'h49, 8'h4E, 8'h4E, 8'h49, 8'hBB, 8'hBB, 8'hBB, 8'hBB, },
{8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h97, 8'h6E, 8'h72, 8'h97, 8'hBB, 8'h92, 8'h4D, 8'h49, 8'h6D, 8'h49, 8'h72, 8'hBB, 8'hBB, 8'h96, 8'h6E, 8'h49, 8'h72, 8'hBB, 8'hBB, 8'hBB, 8'hBB, },
{8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h6D, 8'h92, 8'h6D, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, }

} ,

{ //super rope

{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hDB, 8'h92, 8'h6D, 8'h6D, 8'h6D, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h6D, 8'h6D, 8'h6D, 8'h92, 8'hDB, 8'hFF, 8'hFF, },
{8'hFF, 8'hB6, 8'h69, 8'hA9, 8'hA9, 8'hA9, 8'hA9, 8'h89, 8'h6D, 8'hB6, 8'h92, 8'h6D, 8'h6D, 8'h6D, 8'h92, 8'hB6, 8'h6D, 8'h89, 8'hA9, 8'hA9, 8'hA9, 8'hA9, 8'h69, 8'hB6, 8'hFF, },
{8'hDB, 8'h69, 8'hA9, 8'h69, 8'h89, 8'h89, 8'h69, 8'h89, 8'hA9, 8'h69, 8'h89, 8'h69, 8'h89, 8'h69, 8'h89, 8'h69, 8'hA9, 8'h89, 8'h69, 8'h89, 8'h89, 8'h69, 8'hA9, 8'h69, 8'hDB, },
{8'h92, 8'hA9, 8'h69, 8'hA9, 8'hA9, 8'h89, 8'hA9, 8'hA9, 8'h69, 8'h89, 8'h89, 8'h89, 8'hA9, 8'h89, 8'h89, 8'h89, 8'h69, 8'hA9, 8'hA9, 8'h89, 8'hA9, 8'hA9, 8'h69, 8'hA9, 8'h92, },
{8'h6D, 8'hA9, 8'h89, 8'hA9, 8'h92, 8'hDA, 8'h92, 8'h89, 8'hA9, 8'h49, 8'h89, 8'h89, 8'hA9, 8'h89, 8'h89, 8'h49, 8'hA9, 8'h89, 8'h92, 8'hDA, 8'h92, 8'hA9, 8'h89, 8'hA9, 8'h6D, },
{8'h69, 8'hA9, 8'h89, 8'h89, 8'hDB, 8'h123, 8'hFF, 8'h6D, 8'h69, 8'h89, 8'h89, 8'h89, 8'hA9, 8'h89, 8'h89, 8'h89, 8'h69, 8'h6D, 8'hFF, 8'h123, 8'hDB, 8'h89, 8'h89, 8'hA9, 8'h69, },
{8'h6D, 8'hA9, 8'h69, 8'hA9, 8'h6D, 8'h96, 8'h6D, 8'hA9, 8'hAD, 8'h69, 8'h89, 8'h89, 8'hA9, 8'h89, 8'h89, 8'h69, 8'hAD, 8'hA9, 8'h6D, 8'h96, 8'h6D, 8'hA9, 8'h69, 8'hA9, 8'h6D, },
{8'h96, 8'hA9, 8'h89, 8'h89, 8'hA9, 8'hA9, 8'hA9, 8'h89, 8'h89, 8'h89, 8'h89, 8'h89, 8'hA9, 8'h89, 8'h89, 8'h89, 8'h89, 8'h89, 8'hA9, 8'hA9, 8'hA9, 8'h89, 8'h89, 8'hA9, 8'h96, },
{8'hFF, 8'h6D, 8'hA9, 8'h89, 8'h69, 8'h89, 8'h69, 8'hA9, 8'hA9, 8'h69, 8'h69, 8'h69, 8'h89, 8'h89, 8'h89, 8'h69, 8'hA9, 8'hA9, 8'h69, 8'h89, 8'h69, 8'h89, 8'hA9, 8'h6D, 8'hFF, },
{8'hFF, 8'hDB, 8'h6D, 8'h89, 8'hA9, 8'hA9, 8'hA9, 8'h69, 8'h92, 8'hDB, 8'hB6, 8'hB6, 8'h92, 8'h89, 8'h89, 8'hB6, 8'h92, 8'h69, 8'hA9, 8'hA9, 8'hA9, 8'h89, 8'h6D, 8'hDB, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h92, 8'h92, 8'h92, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h89, 8'h89, 8'hDA, 8'hFF, 8'hDB, 8'h92, 8'h92, 8'h92, 8'hB6, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h89, 8'h89, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h89, 8'h89, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h69, 8'h89, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h8E, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, }

} ,

{ //speed

{8'h6D, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'h25, 8'h00, 8'h92, 8'hFF, 8'hFF, 8'h92, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hB6, 8'h00, 8'h00, 8'h25, 8'hB6, 8'hDA, 8'h49, 8'h24, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'h92, 8'h92, 8'h24, 8'h00, 8'h00, 8'h25, 8'h92, 8'hB6, 8'h6D, 8'h49, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'h6D, 8'h24, 8'h6D, 8'h6D, 8'h49, 8'h00, 8'h00, 8'h24, 8'h6D, 8'hB6, 8'h25, 8'h24, 8'h92, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hDB, 8'h24, 8'h00, 8'h24, 8'h6D, 8'h92, 8'h6D, 8'h25, 8'h00, 8'h24, 8'hB6, 8'h49, 8'h00, 8'h00, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hDA, 8'h49, 8'h24, 8'h00, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'hB6, 8'h49, 8'h00, 8'h00, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hDA, 8'h49, 8'h6D, 8'h92, 8'h6D, 8'h49, 8'h24, 8'h00, 8'h24, 8'hB6, 8'h49, 8'h00, 8'h00, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'h6D, 8'h00, 8'h00, 8'h25, 8'h49, 8'h49, 8'h00, 8'h24, 8'hB6, 8'h49, 8'h00, 8'h00, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h24, 8'h00, 8'h00, 8'h24, 8'h24, 8'h00, 8'h49, 8'hB6, 8'h49, 8'h49, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h6D, 8'h6D, 8'h25, 8'h00, 8'h00, 8'h25, 8'h92, 8'h92, 8'h6D, 8'h6D, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hB6, 8'hB6, 8'h24, 8'h92, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h49, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'h92, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h24, 8'hB6, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h92, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h00, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h49, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h6D, 8'h92, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'hB6, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h49, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h24, 8'hB6, 8'h92, 8'h49, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h49, 8'h6D, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h00, 8'h49, 8'h92, 8'hB6, 8'h6D, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h6D, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h6D, 8'h24, 8'h24, 8'h6D, 8'hB6, 8'h92, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h49, 8'hDB, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h49, 8'h00, 8'h6D, 8'hB6, 8'h92, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hB6, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h49, 8'h00, 8'h6D, 8'hB6, 8'h92, 8'h49, 8'h24, 8'h00, 8'h24, 8'h92, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h49, 8'h00, 8'h49, 8'h92, 8'hB6, 8'hB6, 8'h92, 8'h92, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'h6D, 8'h24, 8'h00, 8'h24, 8'h49, 8'hB6, }

},

{ // immortal
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h71, 8'h4D, 8'h92, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h4C, 8'h75, 8'h71, 8'h4C, 8'h6D, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'h4D, 8'h71, 8'h71, 8'h71, 8'h71, 8'h4C, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h95, 8'hDE, 8'h95, 8'h71, 8'h71, 8'h4C, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h4C, 8'h95, 8'hDA, 8'hBA, 8'hDE, 8'h71, 8'h4C, 8'h4D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h28, 8'h4D, 8'h71, 8'h95, 8'hDA, 8'h71, 8'h4C, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h4C, 8'h28, 8'h24, 8'h4D, 8'h4D, 8'h4D, 8'h4C, 8'h4C, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h4D, 8'h50, 8'h71, 8'h4D, 8'h44, 8'h24, 8'h28, 8'h50, 8'h4C, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h4C, 8'h50, 8'h70, 8'h71, 8'h71, 8'h48, 8'h4C, 8'h50, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h4D, 8'h50, 8'h71, 8'h70, 8'h71, 8'h51, 8'h4C, 8'h50, 8'h4C, 8'h96, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h71, 8'h4C, 8'h50, 8'h71, 8'h71, 8'h71, 8'h50, 8'h50, 8'h50, 8'h4D, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h4C, 8'h50, 8'h71, 8'h71, 8'h70, 8'h50, 8'h4C, 8'h50, 8'h4C, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h4D, 8'h4C, 8'h70, 8'h71, 8'h71, 8'h50, 8'h4C, 8'h4C, 8'h50, 8'h4D, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h71, 8'h4C, 8'h50, 8'h71, 8'h71, 8'h50, 8'h4C, 8'h50, 8'h4C, 8'h4C, 8'h71, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h91, 8'h4C, 8'h50, 8'h71, 8'h71, 8'h71, 8'h4C, 8'h4C, 8'h50, 8'h50, 8'h4D, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h4C, 8'h50, 8'h50, 8'h71, 8'h71, 8'h50, 8'h50, 8'h4C, 8'h50, 8'h4C, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h4C, 8'h4C, 8'h50, 8'h71, 8'h71, 8'h50, 8'h50, 8'h50, 8'h50, 8'h4C, 8'h4D, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h4C, 8'h50, 8'h71, 8'h71, 8'h50, 8'h4C, 8'h50, 8'h50, 8'h50, 8'h4D, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h4C, 8'h50, 8'h71, 8'h71, 8'h50, 8'h4C, 8'h4C, 8'h50, 8'h50, 8'h4C, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'h71, 8'h4C, 8'h50, 8'h71, 8'h50, 8'h4C, 8'h50, 8'h4C, 8'h4C, 8'h4C, 8'h71, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h4C, 8'h50, 8'h50, 8'h50, 8'h50, 8'h50, 8'h50, 8'h4C, 8'h71, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'h71, 8'h4C, 8'h50, 8'h4C, 8'h50, 8'h50, 8'h50, 8'h4C, 8'h71, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'h6D, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4D, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h92, 8'h92, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, }
} 


};





// pipeline (ff) to get the pixel color from the array 	 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		if (InsideRectangle == 1'b1 && visible == 1'b1 )  // inside an external bracket 
			RGBout <= object_colors[present_type][offsetY][offsetX];	//get RGB from the colors table  
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule