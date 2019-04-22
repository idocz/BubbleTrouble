module putin (
    input logic clk,
    input logic resetN,
    input logic [10:0] offsetX, // offset from top left  position 
    input logic [10:0] offsetY,
    input logic InsideRectangle, //input that the pixel is within a bracket 
    output logic drawingRequest, //output that the pixel should be dispalyed 
    output logic [23:0] RGBout, //rgb value form the bitmap 
    output logic [23:0] visible //visible state 
);

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
localparam  int OBJECT_WIDTH_X = 26;
localparam  int OBJECT_HEIGHT_Y = 37;

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'h4D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h8D, 8'h91, 8'h8D, 8'h6D, 8'h6D, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h8D, 8'h8D, 8'h91, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h69, 8'h69, 8'h6D, 8'h8D, 8'h8D, 8'h91, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'h91, 8'h8D, 8'h69, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h49, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'h91, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB2, 8'hB2, 8'hB1, 8'h8D, 8'h6D, 8'h69, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h49, 8'h69, 8'h8D, 8'h8D, 8'hAD, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hD2, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hB1, 8'h8D, 8'h69, 8'h6D, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'h6D, 8'h8D, 8'h8D, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hD1, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hB2, 8'h6D, 8'h8D, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'h92, 8'h6D, 8'h91, 8'h91, 8'h8D, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hD1, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'h8D, 8'h91, 8'h72, 8'hFF, 8'hFF, },
{8'hFF, 8'h72, 8'h91, 8'h8D, 8'hB2, 8'h8D, 8'h8D, 8'hB1, 8'hB1, 8'hD1, 8'hD1, 8'hD2, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hB1, 8'h91, 8'h92, 8'hFF, 8'hFF, },
{8'hFF, 8'h92, 8'h92, 8'h92, 8'hB2, 8'h8D, 8'h8D, 8'hB1, 8'hB1, 8'hD2, 8'hD2, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hF6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hB6, 8'h92, 8'h92, 8'h6D, 8'hFF, },
{8'hFF, 8'hB6, 8'h92, 8'h92, 8'hB2, 8'h8D, 8'h8D, 8'hAD, 8'hB1, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hF6, 8'hF6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hB2, 8'hB2, 8'h72, 8'hFF, },
{8'h6D, 8'hB6, 8'h92, 8'h91, 8'hB1, 8'h8D, 8'h8D, 8'hB1, 8'hB1, 8'hD2, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hF6, 8'hF6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hB6, 8'hB2, 8'h72, 8'hFF, },
{8'h6D, 8'hB6, 8'h92, 8'h92, 8'h91, 8'h8D, 8'h8D, 8'hB1, 8'hB1, 8'hD2, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hF6, 8'hF6, 8'hF6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hB6, 8'hB2, 8'h92, 8'hFF, },
{8'hFF, 8'h92, 8'h91, 8'h91, 8'h91, 8'h91, 8'h8D, 8'hB1, 8'hB1, 8'hB1, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hF6, 8'hF6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hB6, 8'h92, 8'hFF, },
{8'h72, 8'h92, 8'h91, 8'hB2, 8'hB2, 8'h91, 8'hAD, 8'hB1, 8'hB1, 8'hB1, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hF6, 8'hF6, 8'hFA, 8'hF6, 8'hD6, 8'hD6, 8'hD6, 8'hB6, 8'hB2, 8'hB2, 8'h92, },
{8'h8D, 8'h91, 8'h91, 8'hB2, 8'hB2, 8'h91, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hB1, 8'hD2, 8'hD6, 8'hD6, 8'hD6, 8'hB2, 8'hB2, 8'hB2, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hB2, 8'hB2, 8'hD6, 8'hB2, },
{8'h8D, 8'h8D, 8'h92, 8'hB2, 8'h91, 8'h6D, 8'h69, 8'h69, 8'h49, 8'h49, 8'h69, 8'hAD, 8'hB1, 8'hB1, 8'h8D, 8'h69, 8'h6D, 8'h8D, 8'h8D, 8'hB1, 8'hD6, 8'hD6, 8'hB2, 8'hB2, 8'hD6, 8'hD2, },
{8'h6D, 8'h8D, 8'h91, 8'hB2, 8'h8D, 8'h69, 8'h69, 8'h49, 8'h69, 8'h6D, 8'h69, 8'h8D, 8'hD6, 8'hD2, 8'hAD, 8'h8D, 8'h6D, 8'h91, 8'hB1, 8'hB2, 8'hD6, 8'hD6, 8'hD6, 8'hB1, 8'hD6, 8'hB2, },
{8'h6D, 8'h8D, 8'h91, 8'hB2, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hD6, 8'hD6, 8'hD2, 8'hB1, 8'hB2, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'h72, },
{8'hFF, 8'h91, 8'hB2, 8'hB2, 8'h8D, 8'h8D, 8'hB1, 8'hB2, 8'hD6, 8'hB1, 8'h8D, 8'h8D, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'h6D, },
{8'hFF, 8'h91, 8'h91, 8'h91, 8'h8D, 8'hB1, 8'hB1, 8'hB2, 8'hB2, 8'hB1, 8'h8D, 8'h8D, 8'hD6, 8'hF6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hF6, 8'hD6, 8'hD2, 8'hB2, 8'hD6, 8'hB2, 8'hFF, },
{8'hFF, 8'h6D, 8'h91, 8'h91, 8'h8D, 8'h8D, 8'hB1, 8'hB1, 8'hB2, 8'hB1, 8'h8D, 8'h8D, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hB2, 8'hD6, 8'hD6, 8'h92, 8'hFF, },
{8'hFF, 8'hFF, 8'h92, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hB1, 8'hB1, 8'hB1, 8'h8D, 8'h8D, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD2, 8'hB2, 8'hD6, 8'hB6, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h8D, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hB2, 8'h92, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'h8D, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'h69, 8'h8D, 8'hD2, 8'hD6, 8'hD2, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hB2, 8'h72, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'h6D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h69, 8'h8D, 8'hB2, 8'hB2, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'h72, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'h6D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hB2, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'h6D, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hB1, 8'hB2, 8'hB2, 8'hD6, 8'hB2, 8'hB2, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hB2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'h8D, 8'h8D, 8'h69, 8'h69, 8'h69, 8'h89, 8'h8D, 8'hAD, 8'hB2, 8'hB1, 8'h8D, 8'hAD, 8'hD6, 8'hD6, 8'hD2, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h69, 8'h8D, 8'h6D, 8'h8D, 8'h8D, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'hB1, 8'hD6, 8'hD6, 8'hB1, 8'hD2, 8'hD6, 8'hB2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h69, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'hAD, 8'hB1, 8'hD2, 8'hD2, 8'hD6, 8'hD6, 8'hD2, 8'hB2, 8'hB2, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h49, 8'h69, 8'h8D, 8'hB1, 8'hB1, 8'hB1, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hB1, 8'hB1, 8'hB2, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h49, 8'h69, 8'h8D, 8'h8D, 8'hAD, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB2, 8'hD6, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hB1, 8'hB2, 8'hD6, 8'hB2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hB1, 8'hB6, 8'hD6, 8'hD6, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h91, 8'hB2, 8'hD2, 8'hB2, 8'hB2, 8'hD6, 8'hD6, 8'hD6, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h92, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'h72, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'hB2, 8'hD6, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, }
};

wire [7:0] red_sig, green_sig, blue_sig;
assign red_sig     = {object_colors[offsetY][offsetX][7:5] , 5'd0};
assign green_sig   = {object_colors[offsetY][offsetX][4:2] , 5'd0};
assign blue_sig    = {object_colors[offsetY][offsetX][1:0] , 6'd0};


always_ff@(posedge clk)
begin
       RGBout      <= {red_sig,green_sig,blue_sig};
       if (InsideRectangle == 1'b1 && visible == 1'b1 ) begin // inside an external bracket 
            if (object_colors[offsetY][offsetX] != TRANSPARENT_ENCODING)
                drawingRequest <= 1'b1;
            else
                drawingRequest <= 1'b0;
       end
       else
            drawingRequest <= 1'b0;
end

endmodule