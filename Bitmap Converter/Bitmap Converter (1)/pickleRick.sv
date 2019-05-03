module pickleRick (
    input logic clk,
    input logic resetN,
    input logic [10:0] offsetX, // offset from top left  position 
    input logic [10:0] offsetY,
    input logic InsideRectangle, //input that the pixel is within a bracket 
    output logic drawingRequest, //output that the pixel should be dispalyed 
    output logic [23:0] RGBout //rgb value form the bitmap 
);

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
localparam  int OBJECT_WIDTH_X = 20;
localparam  int OBJECT_HEIGHT_Y = 34;

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h4D, 8'h4D, 8'h2D, 8'h4D, 8'h96, 8'hFB, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h51, 8'h79, 8'h55, 8'h51, 8'h51, 8'h2C, 8'h6D, 8'hDB, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h4D, 8'h75, 8'h55, 8'h51, 8'h55, 8'h51, 8'h51, 8'h4D, 8'h6D, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'h4D, 8'h51, 8'h51, 8'h51, 8'h55, 8'h79, 8'h79, 8'h55, 8'h51, 8'h2C, 8'hB6, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h2C, 8'h51, 8'h52, 8'h56, 8'h52, 8'h52, 8'h55, 8'h79, 8'h55, 8'h4D, 8'h92, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4D, 8'h51, 8'h51, 8'h71, 8'h55, 8'h56, 8'h52, 8'h52, 8'h52, 8'h51, 8'h51, 8'h4D, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h4D, 8'h95, 8'hFF, 8'hFF, 8'h95, 8'h79, 8'h75, 8'h55, 8'h52, 8'h52, 8'h51, 8'h4D, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h96, 8'h4D, 8'hDF, 8'hDB, 8'hFF, 8'hB6, 8'h75, 8'hBA, 8'hBA, 8'h75, 8'h51, 8'h51, 8'h4D, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h51, 8'hB6, 8'hFF, 8'hFF, 8'hB6, 8'hBA, 8'hFF, 8'hFB, 8'hDB, 8'h51, 8'h2C, 8'h92, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h4D, 8'h51, 8'h71, 8'h96, 8'h96, 8'h75, 8'hBA, 8'hFF, 8'hFF, 8'hFB, 8'h71, 8'h2C, 8'hB6, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h4D, 8'h51, 8'h4D, 8'h71, 8'h75, 8'h75, 8'h79, 8'hBA, 8'hDA, 8'h96, 8'h51, 8'h4D, 8'hDB, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4D, 8'h51, 8'h4D, 8'h24, 8'h49, 8'h92, 8'h75, 8'h75, 8'h75, 8'h71, 8'h51, 8'h51, 8'h4D, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'h4D, 8'h51, 8'h4D, 8'h24, 8'h20, 8'h45, 8'h6D, 8'h4D, 8'h6D, 8'h49, 8'h51, 8'h4D, 8'h92, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h2C, 8'h51, 8'h51, 8'h71, 8'h6D, 8'h89, 8'h85, 8'h24, 8'h20, 8'h24, 8'h51, 8'h4D, 8'hB6, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4D, 8'h51, 8'h51, 8'h51, 8'h75, 8'h79, 8'h96, 8'hB1, 8'h91, 8'h29, 8'h51, 8'h51, 8'h4D, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h4D, 8'h51, 8'h51, 8'h75, 8'h79, 8'h79, 8'h79, 8'h75, 8'h51, 8'h51, 8'h51, 8'h51, 8'h6D, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h51, 8'h51, 8'h51, 8'h75, 8'h79, 8'h79, 8'h79, 8'h51, 8'h51, 8'h51, 8'h51, 8'h2C, 8'hB6, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h2D, 8'h51, 8'h51, 8'h51, 8'h75, 8'h79, 8'h79, 8'h55, 8'h51, 8'h51, 8'h51, 8'h51, 8'h4D, 8'hDB, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h51, 8'h51, 8'h51, 8'h51, 8'h79, 8'h79, 8'h75, 8'h51, 8'h51, 8'h51, 8'h51, 8'h2C, 8'h92, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hB6, 8'h2D, 8'h51, 8'h51, 8'h51, 8'h55, 8'h79, 8'h75, 8'h51, 8'h51, 8'h51, 8'h71, 8'h51, 8'h4D, 8'hDB, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'h4D, 8'h51, 8'h75, 8'h51, 8'h51, 8'h75, 8'h79, 8'h55, 8'h51, 8'h51, 8'h51, 8'h75, 8'h2C, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hB6, 8'h2C, 8'h51, 8'h51, 8'h51, 8'h51, 8'h79, 8'h75, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h4D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'h6D, 8'h51, 8'h51, 8'h51, 8'h51, 8'h75, 8'h75, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h2C, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hDB, 8'h4D, 8'h51, 8'h51, 8'h51, 8'h75, 8'h55, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h4D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hDA, 8'h2C, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h2C, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hDA, 8'h2D, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h71, 8'h51, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hDA, 8'h4D, 8'h55, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h4D, 8'h6D, 8'hFB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hDB, 8'h4D, 8'h75, 8'h75, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h51, 8'h71, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hB6, 8'h51, 8'h75, 8'h75, 8'h55, 8'h51, 8'h51, 8'h2C, 8'h71, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hB6, 8'h6D, 8'h51, 8'h51, 8'h51, 8'h6D, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, }
};

wire [7:0] red_sig, green_sig, blue_sig;
assign red_sig     = {object_colors[offsetY][offsetX][7:5] , 5'd0};
assign green_sig   = {object_colors[offsetY][offsetX][4:2] , 5'd0};
assign blue_sig    = {object_colors[offsetY][offsetX][1:0] , 6'd0};


always_ff@(posedge clk)
begin
       RGBout      <= {red_sig,green_sig,blue_sig};
       if (InsideRectangle == 1'b1 ) begin // inside an external bracket 
            if (object_colors[offsetY][offsetX] != TRANSPARENT_ENCODING)
                drawingRequest <= 1'b1;
            else
                drawingRequest <= 1'b0;
       end
       else
            drawingRequest <= 1'b0;
end

endmodule