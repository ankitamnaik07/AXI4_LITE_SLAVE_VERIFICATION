`include "defines.svh"
interface axi_interface(input ACLK, ARESETn);
logic [`ADDR_WIDTH-1:0]AWADDR;
logic AWVALID;
logic [2:0] AWPROT;
logic AWREADY;

logic [`DATA_WIDTH-1:0] WDATA;
logic [`STRB_WIDTH-1:0] WSTRB;
logic WVALID;
logic WREADY;

logic BREADY;
logic BVALID;
logic [1:0]BRESP;

logic [`ADDR_WIDTH-1:0] ARADDR;
logic [2:0] ARPROT;
logic ARVALID;
logic ARREADY;

logic RREADY;
logic [`DATA_WIDTH-1:0]RDATA;
logic [1:0]RRESP;
logic RVALID;

clocking drv_cb@(posedge ACLK);
default input #1 output #0;
output AWVALID, AWADDR, AWPROT,WVALID, WDATA, WSTRB, ARVALID, ARADDR, ARPROT, BREADY, RREADY;

  input AWREADY, WREADY, ARREADY, BVALID, BRESP,RVALID, RDATA, RRESP;
endclocking

clocking monin_cb@(posedge ACLK);
default input #1 output #0;
input AWADDR, AWVALID, AWREADY, AWPROT, WDATA, WSTRB, WVALID, WREADY, BREADY, ARADDR, ARVALID,ARPROT, ARREADY, RREADY; 
endclocking

clocking monout_cb@(posedge ACLK);
default input #1 output #0;
input AWREADY, WREADY, BRESP, BVALID, BREADY, ARREADY, RDATA, RRESP, RVALID, RREADY;
endclocking

modport drv(clocking drv_cb);
modport monin(clocking monin_cb);
modport monout(clocking monout_cb);

endinterface
