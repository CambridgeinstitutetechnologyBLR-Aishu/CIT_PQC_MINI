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

    wire [3:0] a = ui_in[7:4];
    wire [3:0] b = ui_in[3:0];
    wire mode = uio_in[0];
    wire [7:0] pqc_arith = (a + b) % 13;
    wire [7:0] pqc_logic = (a ^ b) << 1;

    // The Fix: Use clk and rst_n in a dummy way so the tool routes them
    wire dummy = clk & rst_n & ena;

    assign uo_out = (mode ? pqc_arith : pqc_logic) ^ {7'b0, (dummy & 1'b0)};
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
