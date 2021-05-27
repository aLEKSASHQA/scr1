//Module for loging command ADD
// [ 6:0 ] - opcode: 0110011
// [ 7:11] - rd
// [12:14] - funct3: 000
// [15:19] - rs1
// [20:24] - rs2
// [25:31] - funct7: 0000000

module scr1_tb_log_cmd();
integer i = 0;

localparam [6:0] ADD_OP = 7'b0110011;
localparam [2:0] ADD_FUNCT3 = 3'b000;
localparam [6:0] ADD_FUNCT7 = 7'b0000000;


logic [4:0] rd;
logic [4:0] rs1;
logic [4:0] rs2;

assign rd = scr1_top_tb_ahb.i_top.i_imem_ahb.imem_rdata[11 : 7];
assign rs1 = scr1_top_tb_ahb.i_top.i_imem_ahb.imem_rdata[19 : 15];
assign rs2 = scr1_top_tb_ahb.i_top.i_imem_ahb.imem_rdata[24 : 20];

always_ff @(posedge scr1_top_tb_ahb.i_top.i_imem_ahb.clk) begin
    if (scr1_top_tb_ahb.i_top.i_imem_ahb.imem_resp == 2'b01) begin
        // valid data from ahb router
        if (
            (scr1_top_tb_ahb.i_top.i_imem_ahb.imem_rdata[6 : 0] == ADD_OP)  &&
            (scr1_top_tb_ahb.i_top.i_imem_ahb.imem_rdata[14 : 12] == ADD_FUNCT3) &&
            (scr1_top_tb_ahb.i_top.i_imem_ahb.imem_rdata[31 : 25] == ADD_FUNCT7)
        ) begin
            $display("#%d. (rd = rs1 + rs2)  |  x%0d = x%0d + x%0d",++i, rd, rs1, rs2);
        end
    end
end

endmodule 