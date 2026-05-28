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
    wire [3:0] a = ui_in[7:4];
    wire [3:0] b = ui_in[3:0];
    wire mode = uio_in[0];

    always @(posedge clk) begin
        if (!rst_n) begin
            pqc_out_reg <= 8'b0;
        end else if (ena) begin
            if (mode)
                pqc_out_reg <= a + b; // Standard PQC Adder
            else
                pqc_out_reg <= a ^ b; // PQC Mixer
        end
    end

    assign uo_out = pqc_out_reg;
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
