//Module for loging command ADD
// [ 6:0 ] - opcode: 0110011
// [ 7:11] - rd
// [12:14] - funct3: 000
// [15:19] - rs1
// [20:24] - rs2
// [25:31] - funct7: 0000000

module scr1_tb_log_cmd();
integer i = 0;

localparam [6:0] ADD_OP     = 7'b0110011;
localparam [2:0] ADD_FUNCT3 = 3'b000;
localparam [6:0] ADD_FUNCT7 = 7'b0000000;


logic [4:0] rd;
logic [4:0] rs1;
logic [4:0] rs2;

type_scr1_exu_cmd_s  idu2exu_cmd_i;              // EXU command

assign idu2exu_cmd_i = scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_exu.idu2exu_cmd_i;

assign rd = idu2exu_cmd_i.rd_addr;
assign rs1 = idu2exu_cmd_i.rs1_addr;
assign rs2 = idu2exu_cmd_i.rs2_addr;


logic [31:0] arg_rd;
logic [31:0] arg_rs1;
logic [31:0] arg_rs2;

/*
assign arg_rd = scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_mprf.mprf_int[rd];
assign arg_rs1 = scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_mprf.mprf_int[rs1];
assign arg_rs2 = scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_mprf.mprf_int[rs2];
*/

assign arg_rd  = scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_mprf.exu2mprf_rd_data_i;
assign arg_rs1 = scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_mprf.mprf2exu_rs1_data_o;
assign arg_rs2 = scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_mprf.mprf2exu_rs2_data_o;


logic cmd_detected;

always_ff @(posedge scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_exu.clk) begin
    cmd_detected <= (idu2exu_cmd_i.ialu_cmd  == SCR1_IALU_CMD_ADD)
        && (idu2exu_cmd_i.ialu_op == SCR1_IALU_OP_REG_REG)
        && (idu2exu_cmd_i.rd_wb_sel == SCR1_RD_WB_IALU);
end


always_ff @(posedge scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_exu.clk) begin
    if ( cmd_detected )
    begin   
        $display("#%d.  (rd = rs1 + rs2) %0h = %0h + %0h",++i, arg_rd, arg_rs1, arg_rs2);
    end
end

endmodule 