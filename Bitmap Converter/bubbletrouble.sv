module bubbletrouble (
    input logic clk,
    input logic resetN,
    input logic [10:0] offsetX, // offset from top left  position 
    input logic [10:0] offsetY,
    input logic InsideRectangle, //input that the pixel is within a bracket 
    output logic drawingRequest, //output that the pixel should be dispalyed 
    output logic [23:0] RGBout //rgb value form the bitmap 
);

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
localparam  int OBJECT_WIDTH_X = 60;
localparam  int OBJECT_HEIGHT_Y = 20;

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
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