`timescale 1ns/1ns
`include "axi_interface.sv"
`include "axi_rtl.sv"
`include "axi_test_pkg.sv"

module axi_tb_top;
import uvm_pkg::*;

bit clk,rst;
axi_interface duvif(clk,rst);

 axi4_lite_slave #(
        .DATA_WIDTH (32),
        .ADDR_WIDTH (32),
        .MEM_DEPTH  (16),
        .DEFAULT_PROT(3'b000)
    ) DUV (
        .ACLK    (clk),
        .ARESETn (rst),

        .AWADDR  (duvif.AWADDR),
        .AWPROT  (duvif.AWPROT),
        .AWVALID (duvif.AWVALID),
        .AWREADY (duvif.AWREADY),

        .WDATA   (duvif.WDATA),
        .WSTRB   (duvif.WSTRB),
        .WVALID  (duvif.WVALID),
        .WREADY  (duvif.WREADY),

        .BRESP   (duvif.BRESP),
        .BVALID  (duvif.BVALID),
        .BREADY  (duvif.BREADY),

        .ARADDR  (duvif.ARADDR),
        .ARPROT  (duvif.ARPROT),
        .ARVALID (duvif.ARVALID),
        .ARREADY (duvif.ARREADY),

        .RDATA   (duvif.RDATA),
        .RRESP   (duvif.RRESP),
        .RVALID  (duvif.RVALID),
        .RREADY  (duvif.RREADY)
    );


initial begin
uvm_config_db#(virtual axi_interface)::set(null,"*","axi_if",duvif);

$dumpfile("axi_waves.vcd");
$dumpvars;
run_test();
end

initial begin
  clk = 1'b0;
  rst = 0;
  #20;
  rst = 1;
end
initial begin
  forever #5 clk = ~clk;
end

endmodule
