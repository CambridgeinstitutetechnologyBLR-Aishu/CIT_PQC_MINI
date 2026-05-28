`default_nettype none

module tt_um_pqc_aishu (
    input  wire [7:0] ui_in,    
    output wire [7:0] uo_out,   
    input  wire [7:0] uio_in,   
    output wire [7:0] uio_out,  
    output wire [7:0] uio_oe,   
    input  wire       ena,      
    input  wire       clk,      
    input  wire       rst_n     
);

    reg [7:0] pqc_out_reg;
    reg [7:0] dummy_gate; // The Anchor
    wire [3:0] a = ui_in[7:4];
    wire [3:0] b = ui_in[3:0];
    wire mode = uio_in[0];

    always @(posedge clk) begin
        if (!rst_n) begin
            pqc_out_reg <= 8'b0;
            dummy_gate <= 8'b0;
        end else begin
            dummy_gate <= dummy_gate + 1; 
            if (mode)
                pqc_out_reg <= (a + b);
            else
                pqc_out_reg <= (a ^ b);
        end
    end

    // We XOR the output with the dummy gate but then AND it with 0
    // This looks like 'logic' to the tool, so it CANNOT delete the clock.
    assign uo_out = pqc_out_reg ^ (dummy_gate & 8'h00);
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
