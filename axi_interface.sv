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

property p1;
  @(posedge ACLK) disable iff (!ARESETn)
    (AWVALID && !AWREADY) |=> AWREADY;
endproperty

assert property(p1)
  else $error("Write address handshake not happening");

property p2;
  @(posedge ACLK) disable iff (!ARESETn)
    (WVALID && !WREADY) |=> WREADY;
endproperty

assert property(p2)
  else $error("Write Data handshake not happening");

property p3;
  @(posedge ACLK) disable iff (!ARESETn)
    (ARVALID && !ARREADY) |=> ARREADY;
endproperty

assert property(p3)
  else $error("Read Address handshake not happening");

property p4;
  @(posedge ACLK) disable iff (!ARESETn)
    (!BVALID && BREADY) |=> BVALID;
endproperty

assert property(p4)
  else $error("Write Response handshake not happening");

property p5;
  @(posedge ACLK) disable iff (!ARESETn)
    (!RVALID && RREADY) |=> RVALID;
endproperty

assert property(p5)
  else $error("Read Data handshake not happening");

property p_aw_payload_stable;
  @(posedge ACLK) disable iff (!ARESETn)
    (AWVALID && !AWREADY) |=> $stable(AWADDR) && $stable(AWPROT);
endproperty
assert property(p_aw_payload_stable) 
  else $error("AWADDR or AWPROT changed while waiting for AWREADY");

property p_w_payload_stable;
  @(posedge ACLK) disable iff (!ARESETn)
    (WVALID && !WREADY) |=> $stable(WDATA) && $stable(WSTRB);
endproperty
assert property(p_w_payload_stable) 
  else $error("WDATA or WSTRB changed while waiting for WREADY");

property p_ar_payload_stable;
  @(posedge ACLK) disable iff (!ARESETn)
    (ARVALID && !ARREADY) |=> $stable(ARADDR) && $stable(ARPROT);
endproperty
assert property(p_ar_payload_stable) 
  else $error("ARADDR or ARPROT changed while waiting for ARREADY");

property p_b_payload_stable;
  @(posedge ACLK) disable iff (!ARESETn)
    $rose(BVALID) |=> $stable(BRESP);
endproperty
assert property(p_b_payload_stable) 
  else $error("BRESP changed while waiting for BREADY");

property p_r_payload_stable;
  @(posedge ACLK) disable iff (!ARESETn)
    $rose(RVALID) |=> $stable(RDATA) && $stable(RRESP);
endproperty
assert property(p_r_payload_stable) 
  else $error("RDATA or RRESP changed while waiting for RREADY");

endinterface

