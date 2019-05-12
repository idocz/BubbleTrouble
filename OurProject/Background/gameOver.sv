//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	gameOver	(	

					input	logic	clk,
					input	logic	resetN,
					input 	logic	[10:0]	pixelX,
					input 	logic	[10:0]	pixelY,
					input    logic visible,

					output	logic drawingRequest,
					output	logic	[7:0]	gameOverRGB
);


parameter topLeftX = 170;
parameter topLeftY = 10;
parameter size = 5;

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 


int offsetX;
int offsetY;

assign offsetX = pixelX - topLeftX;
assign offsetY = pixelY - topLeftY;


localparam  int OBJECT_WIDTH_X = 57;
localparam  int OBJECT_HEIGHT_Y = 30;

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFB, 8'hFF, 8'hFF, 8'hFB, 8'hFB, 8'hFB, 8'hFB, 8'hFF, 8'hFF, 8'hFB, 8'hFB, 8'hFB, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCE, 8'hCD, 8'hCD, 8'hC9, 8'hC9, 8'hED, 8'hE9, 8'hE9, 8'hCD, 8'hFB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCD, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD6, 8'hC9, 8'hC9, 8'hC9, 8'hFB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC9, 8'hC9, 8'hC9, 8'hD2, 8'hFF, 8'hCE, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE5, 8'hCD, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFB, 8'hFB, 8'hC9, 8'hE5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hA5, 8'hDB, 8'hFF, 8'hFF, 8'hFB, 8'hF6, 8'hC5, 8'hE5, 8'hC5, 8'hC5, 8'hC1, 8'hCE, 8'hFB, 8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hC1, 8'hE5, 8'hC5, 8'hD2, 8'hFB, 8'hFF, 8'hFB, 8'hD6, 8'hC5, 8'hE1, 8'hE1, 8'hCD, 8'hFF, 8'hCD, 8'hE5, 8'hE5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hA5, 8'hC5, 8'hC5, 8'hC5, 8'hA9, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hCE, 8'hC5, 8'hE5, 8'hC5, 8'hB2, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB2, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hCE, 8'hC5, 8'hE5, 8'hC5, 8'hB2, 8'hCE, 8'hE5, 8'hE5, 8'hC5, 8'hD6, 8'hFF, 8'hFF, 8'hD2, 8'hC5, 8'hE5, 8'hE5, 8'hC5, 8'hCD, 8'hFF, 8'hCD, 8'hC5, 8'hE5, 8'hE5, 8'hE5, 8'hC9, 8'hFF, 8'hCD, 8'hE5, 8'hE5, 8'hC9, 8'hB6, 8'hD6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hFF, },
{8'hFF, 8'hFB, 8'hF6, 8'hC9, 8'hE5, 8'hC5, 8'hA5, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFB, 8'hD2, 8'hC9, 8'hE5, 8'hA5, 8'hA9, 8'hFB, 8'hD6, 8'hA5, 8'hC5, 8'hC5, 8'hCE, 8'hFA, 8'hFF, 8'hD2, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hC9, 8'hD2, 8'hC9, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hCD, 8'hFF, 8'hCD, 8'hE5, 8'hE5, 8'hC5, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hD6, 8'hE5, 8'hE5, 8'hE5, 8'hB2, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD6, 8'hE5, 8'hE5, 8'hE5, 8'hB2, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hC9, 8'hE5, 8'hE5, 8'hC9, 8'hDF, 8'hF2, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hC5, 8'hE5, 8'hE5, 8'hE5, 8'hC9, 8'hFF, 8'hCD, 8'hE5, 8'hE5, 8'hC5, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hD6, 8'hFF, 8'hFF, 8'hFB, 8'hCE, 8'hCE, 8'hCE, 8'hCE, 8'hD2, 8'hFF, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCD, 8'hE5, 8'hE5, 8'hC9, 8'hDF, 8'hF2, 8'hE5, 8'hE5, 8'hC5, 8'hA9, 8'hC9, 8'hE5, 8'hA9, 8'hAE, 8'hC5, 8'hE5, 8'hE5, 8'hC9, 8'hFF, 8'hCD, 8'hE5, 8'hE5, 8'hE5, 8'hC9, 8'hED, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hD2, 8'hFF, },
{8'hFF, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hD6, 8'hFF, 8'hFF, 8'hD6, 8'hC5, 8'hE5, 8'hE5, 8'hE5, 8'hC5, 8'hD6, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC9, 8'hE5, 8'hE5, 8'hC9, 8'hDF, 8'hF2, 8'hE5, 8'hE5, 8'hC5, 8'hDB, 8'hD6, 8'hC5, 8'hB2, 8'hFF, 8'hC9, 8'hE5, 8'hE5, 8'hC9, 8'hFF, 8'hCD, 8'hE5, 8'hE5, 8'hE5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hA9, 8'hDF, },
{8'hFF, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hD2, 8'hFF, 8'hFF, 8'hDB, 8'h8E, 8'hC9, 8'hE5, 8'hE5, 8'hC5, 8'hDA, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE9, 8'hE9, 8'hC9, 8'hC9, 8'hE5, 8'hE5, 8'hE5, 8'hC9, 8'hDF, 8'hF2, 8'hE5, 8'hE5, 8'hC5, 8'hDB, 8'hDB, 8'hB2, 8'hDA, 8'hFB, 8'hC9, 8'hE5, 8'hE5, 8'hC9, 8'hFF, 8'hCD, 8'hE5, 8'hE5, 8'hC5, 8'hAE, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hB6, 8'hFF, },
{8'hFF, 8'hD2, 8'hC5, 8'hC5, 8'hE5, 8'hD2, 8'hFB, 8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hE5, 8'hE5, 8'hC5, 8'hDA, 8'hFA, 8'hE5, 8'hE5, 8'hE5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hE5, 8'hE5, 8'hC9, 8'hDF, 8'hF2, 8'hE5, 8'hE5, 8'hC5, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFB, 8'hC9, 8'hE5, 8'hE5, 8'hC9, 8'hFF, 8'hCD, 8'hE5, 8'hE5, 8'hC5, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFB, 8'hB6, 8'hCD, 8'hE5, 8'hE5, 8'hC9, 8'hDB, 8'hFF, 8'hFF, 8'hD2, 8'hE5, 8'hE5, 8'hC5, 8'hDA, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hAE, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hC9, 8'hE5, 8'hE5, 8'hC9, 8'hDF, 8'hD2, 8'hE5, 8'hE5, 8'hC5, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFB, 8'hC9, 8'hE5, 8'hE5, 8'hC9, 8'hFF, 8'hCD, 8'hE5, 8'hE5, 8'hC5, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hA5, 8'hC5, 8'hE5, 8'hD2, 8'hF6, 8'hF6, 8'hCE, 8'hE5, 8'hE5, 8'hC5, 8'hDA, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hEE, 8'hE5, 8'hE5, 8'hC9, 8'hDF, 8'hF2, 8'hE5, 8'hE5, 8'hC5, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFB, 8'hC9, 8'hE5, 8'hE5, 8'hC9, 8'hFF, 8'hED, 8'hE5, 8'hE5, 8'hE5, 8'hCD, 8'hCE, 8'hCE, 8'hEE, 8'hCE, 8'hEE, 8'hF2, 8'hD2, 8'hD6, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hC9, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hC5, 8'hD6, 8'hF6, 8'hC5, 8'hE5, 8'hC5, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCE, 8'hC5, 8'hE5, 8'hC9, 8'hDB, 8'hD2, 8'hC5, 8'hC5, 8'hC5, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFB, 8'hC9, 8'hC5, 8'hC5, 8'hC9, 8'hFF, 8'hCD, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hA9, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD6, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hDB, 8'hDB, 8'h8E, 8'h8E, 8'hAE, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD6, 8'hAE, 8'hAE, 8'hB2, 8'hDB, 8'hDB, 8'hB2, 8'hB2, 8'hB2, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD6, 8'hB2, 8'hB2, 8'hB6, 8'hFF, 8'hD6, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hD6, 8'hF2, 8'hF2, 8'hF2, 8'hD2, 8'hD2, 8'hD2, 8'hD2, 8'hD2, 8'hDB, 8'hFF, 8'hFF, 8'hFB, 8'hD2, 8'hCE, 8'hD2, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hCE, 8'hCE, 8'hD2, 8'hFF, 8'hD6, 8'hEE, 8'hEE, 8'hEE, 8'hEE, 8'hEE, 8'hEE, 8'hEE, 8'hEE, 8'hF2, 8'hF2, 8'hF2, 8'hD6, 8'hFF, 8'hD2, 8'hEE, 8'hEE, 8'hF2, 8'hF2, 8'hEE, 8'hF2, 8'hF2, 8'hF2, 8'hF2, 8'hD2, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hCE, 8'hE5, 8'hE5, 8'hC5, 8'hC5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hCE, 8'hFF, 8'hFF, 8'hF6, 8'hE5, 8'hE5, 8'hC5, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC9, 8'hE5, 8'hE5, 8'hC9, 8'hDF, 8'hF2, 8'hE5, 8'hE5, 8'hE5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hAD, 8'hFF, 8'hCD, 8'hE5, 8'hE5, 8'hE5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hE5, 8'hC5, 8'hD6, 8'hFF, 8'hFF, },
{8'hFF, 8'hF6, 8'hC9, 8'hE9, 8'hE5, 8'hA9, 8'hAE, 8'hAE, 8'h8D, 8'h8D, 8'hC9, 8'hE5, 8'hE5, 8'hC9, 8'hDB, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hB2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCD, 8'hE5, 8'hE5, 8'hC9, 8'hDF, 8'hF2, 8'hE5, 8'hE5, 8'hC5, 8'h8E, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'h92, 8'hB6, 8'hFF, 8'hCD, 8'hE5, 8'hE5, 8'hC9, 8'hB2, 8'hB2, 8'hB2, 8'hB2, 8'hAE, 8'hC5, 8'hE5, 8'hC5, 8'hCE, 8'hFF, },
{8'hFF, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hE5, 8'hE5, 8'hC5, 8'hD6, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCE, 8'hE5, 8'hE5, 8'hC9, 8'hDF, 8'hF2, 8'hE5, 8'hE5, 8'hC5, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC9, 8'hE5, 8'hE5, 8'hC9, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC9, 8'hE5, 8'hE5, 8'hCD, 8'hFF, },
{8'hFF, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hE5, 8'hE5, 8'hC5, 8'hD6, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCE, 8'hE5, 8'hE5, 8'hC9, 8'hDB, 8'hF2, 8'hE5, 8'hE5, 8'hC5, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC9, 8'hE5, 8'hE5, 8'hC9, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hE9, 8'hE5, 8'hE5, 8'hCD, 8'hFF, },
{8'hFF, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hE5, 8'hE5, 8'hC5, 8'hD6, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hC9, 8'hD6, 8'hFF, 8'hD6, 8'hD2, 8'hC9, 8'hE5, 8'hE5, 8'hC9, 8'hDB, 8'hD2, 8'hE5, 8'hE5, 8'hE5, 8'hCE, 8'hF2, 8'hD2, 8'hD2, 8'hF2, 8'hEE, 8'hF2, 8'hD2, 8'hD6, 8'hFF, 8'hC9, 8'hE5, 8'hE5, 8'hC9, 8'hDB, 8'hFF, 8'hFF, 8'hD6, 8'hCE, 8'hE5, 8'hE5, 8'hE5, 8'hCD, 8'hFF, },
{8'hFF, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF2, 8'hE5, 8'hE5, 8'hC5, 8'hD6, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hC5, 8'hDB, 8'hD2, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hC9, 8'hDB, 8'hF2, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hC5, 8'hC5, 8'hC5, 8'hE5, 8'hC5, 8'hE5, 8'hC5, 8'hA9, 8'hFF, 8'hE9, 8'hE5, 8'hE5, 8'hC9, 8'hDB, 8'hFF, 8'hFF, 8'hC9, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hCD, 8'hFF, },
{8'hFF, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF2, 8'hE5, 8'hE5, 8'hC5, 8'hD6, 8'hFB, 8'hAD, 8'hC9, 8'hE5, 8'hE5, 8'hE5, 8'hC9, 8'hE9, 8'hE5, 8'hE5, 8'hE5, 8'hAD, 8'hB2, 8'hDF, 8'hF2, 8'hE5, 8'hE5, 8'hC5, 8'hAD, 8'hB2, 8'hAE, 8'hAE, 8'hAE, 8'hAE, 8'hAE, 8'hAE, 8'hB2, 8'hFF, 8'hE9, 8'hE5, 8'hE5, 8'hE5, 8'hC9, 8'hED, 8'hCD, 8'hE5, 8'hE5, 8'hA9, 8'hAE, 8'hAE, 8'hB2, 8'hFF, },
{8'hFF, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hE5, 8'hE5, 8'hE5, 8'hD6, 8'hFF, 8'hFF, 8'hD2, 8'hC5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hC5, 8'hA5, 8'hD6, 8'hFF, 8'hFF, 8'hF2, 8'hE5, 8'hE5, 8'hC5, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hE9, 8'hE5, 8'hE5, 8'hE5, 8'hC5, 8'hE5, 8'hE5, 8'hE5, 8'hC5, 8'hD2, 8'hFB, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hF6, 8'hE5, 8'hE5, 8'hE5, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF2, 8'hE5, 8'hE5, 8'hE5, 8'hD6, 8'hFF, 8'hFF, 8'hDB, 8'hB2, 8'hC9, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hCD, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hF2, 8'hE5, 8'hE5, 8'hC5, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hE9, 8'hE5, 8'hE5, 8'hC9, 8'hB6, 8'hCD, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hC9, 8'hDB, 8'hFF, 8'hFF, },
{8'hFF, 8'hD6, 8'hC5, 8'hC5, 8'hE5, 8'hCE, 8'hFB, 8'hFA, 8'hFB, 8'hFB, 8'hEE, 8'hE5, 8'hC5, 8'hA9, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCD, 8'hA5, 8'hE5, 8'hC5, 8'hA9, 8'hB2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF2, 8'hE5, 8'hE5, 8'hE5, 8'hCE, 8'hF6, 8'hF2, 8'hF6, 8'hF6, 8'hF6, 8'hF2, 8'hF2, 8'hFB, 8'hFF, 8'hE9, 8'hE5, 8'hE5, 8'hC9, 8'hFF, 8'hD6, 8'hA9, 8'hE5, 8'hE5, 8'hE5, 8'hC5, 8'hD2, 8'hFB, 8'hFF, },
{8'hFF, 8'hFF, 8'hB6, 8'hCD, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hAE, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDF, 8'hD6, 8'hC5, 8'hC9, 8'hDB, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hC5, 8'hE5, 8'hC9, 8'hFF, 8'hCD, 8'hE5, 8'hE5, 8'hC9, 8'hDB, 8'hFF, 8'hDB, 8'hCD, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hC9, 8'hDF, },
{8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hA9, 8'hA9, 8'hA9, 8'hA9, 8'hA9, 8'hA9, 8'hA9, 8'hA9, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'h8E, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'h8E, 8'h8E, 8'h8E, 8'h8E, 8'h8E, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hAE, 8'h8D, 8'hB2, 8'hFF, 8'hD6, 8'h8D, 8'h8D, 8'h8E, 8'hDB, 8'hFF, 8'hFF, 8'hD6, 8'hAD, 8'h8D, 8'h8D, 8'h89, 8'hAE, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDF, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDF, 8'hDF, 8'hDF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, }
};

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		gameOverRGB <=	8'hFF;
	end
	else begin
		if ((offsetX  >= 0) &&  (offsetX < OBJECT_WIDTH_X*size) && (offsetY  >= 0) &&  (offsetY < OBJECT_HEIGHT_Y*size) && visible  )  // inside an external bracket 
			gameOverRGB <= object_colors[offsetY/size][offsetX/size];	//get RGB from the colors table  
		else 
			gameOverRGB <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

// decide if to draw the pixel or not 
assign drawingRequest = (gameOverRGB != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   


endmodule

