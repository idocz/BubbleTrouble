module playerBitMap (
    input logic clk,
    input logic resetN,
    input logic [10:0] offsetX, // offset from top left  position 
    input logic [10:0] offsetY,
    input logic InsideRectangle, //input that the pixel is within a bracket 
	 input logic visible,
	 input logic blink,
	 input logic [7:0] bg,
	 
    output logic drawingRequest, //output that the pixel should be dispalyed 
    output logic [7:0] RGBout //rgb value form the bitmap 
);

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
localparam  int OBJECT_WIDTH_X = 40;
localparam  int OBJECT_HEIGHT_Y = 40;

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h6D, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'hB6, 8'h72, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h6D, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h6D, 8'hDF, 8'h96, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h92, 8'hB6, 8'hB6, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h72, 8'hDB, 8'hDF, 8'h92, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h6D, 8'hB6, 8'hDF, 8'hB6, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h72, 8'hDB, 8'hBB, 8'hDB, 8'h72, 8'hBA, 8'hFF, 8'hFF, 8'hB6, 8'h6D, 8'hBB, 8'hDF, 8'hDF, 8'h96, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h92, 8'hDB, 8'hBB, 8'hDB, 8'hBB, 8'h6D, 8'hFF, 8'hB6, 8'h6D, 8'hBB, 8'hDF, 8'hBB, 8'hDF, 8'h92, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'h92, 8'hDF, 8'hBB, 8'hBB, 8'hDF, 8'hB6, 8'h6D, 8'h6D, 8'hDB, 8'hDB, 8'hBB, 8'hBB, 8'hDB, 8'h72, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h6D, 8'h92, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h96, 8'hBF, 8'hBB, 8'hBB, 8'hBB, 8'hDB, 8'h92, 8'hBB, 8'hDF, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h72, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h91, 8'hB6, 8'h92, 8'h92, 8'h92, 8'hB6, 8'hDA, 8'hFF, 8'h92, 8'h96, 8'hDF, 8'hDF, 8'hDF, 8'hDB, 8'hBB, 8'hDB, 8'hDF, 8'hDF, 8'hBB, 8'hBB, 8'hDB, 8'hB7, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h72, 8'hBB, 8'hDF, 8'hDB, 8'hBB, 8'h96, 8'h92, 8'h6D, 8'h6D, 8'hBB, 8'hDB, 8'hB6, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'h96, 8'hBB, 8'hDF, 8'hDF, 8'h96, 8'h92, 8'hFF, 8'hDB, 8'hDA, 8'hB6, 8'h92, 8'h92, 8'h6D, 8'h49, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h96, 8'h92, 8'hDF, 8'hBB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hB6, 8'h72, 8'h96, 8'hB6, 8'hDA, 8'hDB, 8'hDB, 8'hDA, 8'h96, 8'h72, 8'hBB, 8'hDF, 8'h96, 8'h4D, 8'h72, 8'h72, 8'h92, 8'h96, 8'hBA, 8'hBA, 8'h6D, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h72, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hDB, 8'hDB, 8'h96, 8'h92, 8'hDB, 8'hFE, 8'hFB, 8'hDB, 8'hDA, 8'hDB, 8'hFB, 8'hFB, 8'hDA, 8'h72, 8'hBB, 8'hDB, 8'hDB, 8'hDB, 8'hDF, 8'hDF, 8'hDF, 8'hDB, 8'h6D, 8'hBA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h96, 8'hDB, 8'hBB, 8'hBB, 8'hDF, 8'h96, 8'h92, 8'hFB, 8'hDA, 8'hB6, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'hB6, 8'hDB, 8'hDB, 8'h72, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hDF, 8'h72, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h6E, 8'hDB, 8'hBB, 8'hBB, 8'hBB, 8'h92, 8'hDA, 8'h92, 8'h92, 8'hB6, 8'h96, 8'h96, 8'h96, 8'h96, 8'hB6, 8'hB6, 8'h92, 8'hB6, 8'hB6, 8'h96, 8'hDF, 8'hBB, 8'hBB, 8'hDF, 8'hB6, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'hBB, 8'hDF, 8'hDB, 8'h92, 8'hB6, 8'h92, 8'hB6, 8'h92, 8'h92, 8'h92, 8'hB6, 8'hB6, 8'hB6, 8'h92, 8'h92, 8'h96, 8'h92, 8'hB6, 8'h92, 8'hDB, 8'hBB, 8'hBB, 8'hDB, 8'h72, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h72, 8'hDF, 8'hBB, 8'h92, 8'hB6, 8'h92, 8'h92, 8'hB6, 8'hDB, 8'hFB, 8'hFB, 8'hFB, 8'hFB, 8'hFB, 8'hDB, 8'hB6, 8'h92, 8'hB6, 8'h92, 8'hBB, 8'hDB, 8'hDF, 8'h92, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h92, 8'h6D, 8'hB6, 8'hDF, 8'hB7, 8'h92, 8'hDB, 8'hB2, 8'hB6, 8'hB6, 8'hD6, 8'hDB, 8'hFB, 8'hFB, 8'hDA, 8'hB6, 8'hB2, 8'hB6, 8'hB6, 8'hDA, 8'hB6, 8'h96, 8'hDF, 8'hB6, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hB6, 8'h72, 8'h92, 8'hB6, 8'hDB, 8'hDB, 8'hDB, 8'h96, 8'hB6, 8'hB2, 8'hB6, 8'hDA, 8'hDA, 8'hB6, 8'h92, 8'hDB, 8'hDB, 8'h92, 8'hB6, 8'hDB, 8'hDB, 8'hDA, 8'h92, 8'hB6, 8'h92, 8'hDF, 8'h72, 8'h6D, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hDB, 8'h49, 8'h92, 8'hDB, 8'hDF, 8'hDB, 8'hDB, 8'hBB, 8'hDF, 8'h96, 8'h92, 8'hDA, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hDB, 8'h92, 8'h92, 8'hDB, 8'hDB, 8'hB6, 8'h92, 8'h6D, 8'h72, 8'h6D, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hB6, 8'h6D, 8'h72, 8'hBB, 8'hDB, 8'hBB, 8'hBB, 8'hDB, 8'h92, 8'h92, 8'hFE, 8'hFE, 8'h00, 8'h00, 8'hFE, 8'hFE, 8'h92, 8'hB2, 8'hDB, 8'hFE, 8'hFE, 8'h00, 8'hFE, 8'hFE, 8'h92, 8'h72, 8'hBB, 8'hBB, 8'hDB, 8'hDF, 8'hDF, 8'hB6, 8'h6D, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'h00, 8'hDB, 8'h92, 8'h4D, 8'h72, 8'hBB, 8'hBB, 8'hDB, 8'h92, 8'h92, 8'hFE, 8'hFE, 8'h00, 8'h00, 8'hFE, 8'hFE, 8'hB2, 8'hB2, 8'hDB, 8'hFE, 8'hFE, 8'h00, 8'hFE, 8'hFE, 8'h92, 8'h72, 8'hBB, 8'hBB, 8'hDB, 8'hDB, 8'h92, 8'h49, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h4D, 8'hBB, 8'hDB, 8'h92, 8'h92, 8'hDB, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hDB, 8'hB2, 8'hB6, 8'hB6, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hDB, 8'h92, 8'h92, 8'hBB, 8'hBF, 8'hBB, 8'h6E, 8'h6E, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h6E, 8'hBB, 8'hBB, 8'hBB, 8'h92, 8'hDA, 8'h92, 8'hDB, 8'hFE, 8'hFE, 8'hDB, 8'h92, 8'hDA, 8'hDB, 8'h92, 8'hD6, 8'hFE, 8'h00, 8'hDB, 8'h92, 8'hD6, 8'h92, 8'hBB, 8'hBB, 8'h6E, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h6D, 8'hBB, 8'hDF, 8'hBB, 8'hBB, 8'h92, 8'hDB, 8'hDA, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hB6, 8'hDA, 8'hDA, 8'hB6, 8'hB6, 8'hB2, 8'h92, 8'h92, 8'hDA, 8'hDB, 8'h92, 8'hBB, 8'h96, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hB2, 8'h6D, 8'hDB, 8'hDF, 8'hBB, 8'hBB, 8'hBB, 8'h6E, 8'hDB, 8'hB6, 8'hB6, 8'hD6, 8'hD6, 8'hB6, 8'hB6, 8'hB6, 8'hD6, 8'h92, 8'hB6, 8'hB6, 8'hD6, 8'hB6, 8'hB2, 8'hDA, 8'h92, 8'hBB, 8'hB6, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hDA, 8'h92, 8'h92, 8'hBB, 8'hDF, 8'hBB, 8'h72, 8'h6D, 8'hDA, 8'hDA, 8'hB6, 8'hB2, 8'hB2, 8'hB6, 8'hB6, 8'hB6, 8'hD6, 8'hB2, 8'hDA, 8'hB6, 8'hB2, 8'hB2, 8'hD6, 8'hDA, 8'h6D, 8'h6E, 8'hBB, 8'hB6, 8'h6D, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h4D, 8'h72, 8'h92, 8'hB6, 8'h92, 8'h91, 8'hDA, 8'hD6, 8'hB6, 8'hD6, 8'hDB, 8'hDA, 8'h92, 8'hB6, 8'hB6, 8'hFB, 8'hFB, 8'hFB, 8'hDA, 8'hDA, 8'hFB, 8'hB6, 8'h6D, 8'h96, 8'hDF, 8'hDB, 8'h92, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h6D, 8'h6D, 8'hB6, 8'h92, 8'hD6, 8'h92, 8'h44, 8'h69, 8'h92, 8'h8D, 8'hB6, 8'hB2, 8'h92, 8'hDA, 8'hDA, 8'hB6, 8'h8D, 8'h8D, 8'h49, 8'h8D, 8'hDB, 8'h6D, 8'h72, 8'h96, 8'h72, 8'h72, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'hBB, 8'h72, 8'h92, 8'hD6, 8'h44, 8'h44, 8'h65, 8'h69, 8'hB2, 8'h69, 8'h91, 8'h92, 8'h91, 8'h91, 8'h6D, 8'h8D, 8'h45, 8'h44, 8'h40, 8'h8D, 8'hB6, 8'h29, 8'h6D, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h72, 8'hDF, 8'hB6, 8'hB6, 8'h8D, 8'h40, 8'h64, 8'h64, 8'h64, 8'h44, 8'h65, 8'h6D, 8'h6D, 8'h69, 8'h8D, 8'h44, 8'h64, 8'h64, 8'h64, 8'h64, 8'h45, 8'hD6, 8'h49, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h91, 8'h92, 8'hB6, 8'h92, 8'hB6, 8'h8D, 8'h60, 8'h84, 8'h64, 8'h64, 8'h64, 8'h64, 8'h44, 8'h44, 8'h44, 8'h44, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h69, 8'hD6, 8'h6D, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h92, 8'h92, 8'h72, 8'h92, 8'hB2, 8'h44, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h89, 8'h65, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h40, 8'hB2, 8'h92, 8'h6D, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'hD6, 8'h8D, 8'h40, 8'h64, 8'h64, 8'h64, 8'h60, 8'h89, 8'hA9, 8'h60, 8'h64, 8'h64, 8'h64, 8'h44, 8'h44, 8'hB1, 8'hDA, 8'h6D, 8'h92, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'hD6, 8'h8D, 8'h69, 8'h69, 8'h65, 8'h89, 8'h89, 8'hAD, 8'h69, 8'h69, 8'h69, 8'h69, 8'h8D, 8'hB2, 8'hD6, 8'h6D, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'hB2, 8'hB6, 8'hB2, 8'h6D, 8'h6D, 8'h6D, 8'h91, 8'h8D, 8'h6D, 8'h6D, 8'hB6, 8'hB6, 8'h92, 8'h92, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h6D, 8'hB6, 8'hDA, 8'h6D, 8'h91, 8'hDA, 8'hB6, 8'h6D, 8'hD6, 8'h92, 8'h49, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h8D, 8'h69, 8'h92, 8'h6D, 8'h6D, 8'h49, 8'h6D, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hB6, 8'hDA, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, }
};
// pipeline (ff) to get the pixel color from the array 	 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		if (InsideRectangle == 1'b1 && visible == 1'b1  ) 	// inside an external bracket 
		begin
			if( blink == 1'b0 )
				RGBout <= object_colors[offsetY][offsetX];	//get RGB from the colors table  
			else
				RGBout <= bg;
		end
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule