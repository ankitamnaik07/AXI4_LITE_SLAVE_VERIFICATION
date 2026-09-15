`uvm_analysis_imp_decl(_inwr)
`uvm_analysis_imp_decl(_inrd)
`uvm_analysis_imp_decl(_outwr)
`uvm_analysis_imp_decl(_outrd)

class axi_subscriber extends uvm_component;
`uvm_component_utils(axi_subscriber)

uvm_analysis_imp_inwr  #(axi_seq_item, axi_subscriber) ap_inwr;
uvm_analysis_imp_inrd  #(axi_seq_item, axi_subscriber) ap_inrd;
uvm_analysis_imp_outwr #(axi_seq_item, axi_subscriber) ap_outwr;
uvm_analysis_imp_outrd #(axi_seq_item, axi_subscriber) ap_outrd;

localparam bit [31:0] LAST_VALID  = (`MEM_DEPTH * 4) - 4;
localparam bit [31:0] FIRST_INVAL = (`MEM_DEPTH * 4);

axi_seq_item wr_q [$];
axi_seq_item rd_q [$];

covergroup cg_write with function sample(bit [31:0] addr, bit [2:0] prot, bit [31:0] data, bit [3:0] strb, bit [1:0] resp);
  option.per_instance = 1;

  cp_awaddr : coverpoint addr {
    bins low_inrange    = {[32'h0 : 32'h0C]};
    bins mid_inrange    = {[32'h10 : LAST_VALID-4]};
    bins last_inrange   = {LAST_VALID};
    bins first_outrange = {FIRST_INVAL};
    bins far_outrange   = {[FIRST_INVAL+4 : $]};
    bins unaligned      = {[32'h1:32'h3], [32'h5:32'h7]};
  }

  cp_awprot : coverpoint prot {
    bins prot[] = {[0:7]};
  }

  cp_wstrb : coverpoint strb {
    bins all_bytes   = {4'b1111};
    bins no_bytes    = {4'b0000};
    bins single_byte = {4'b0001, 4'b0010, 4'b0100, 4'b1000};
    bins partial     = default;
  }

  cp_wdata : coverpoint data {
    bins all_zeros = {32'h0000_0000};
    bins all_ones  = {32'hFFFF_FFFF};
    bins random    = default;
  }

  cp_bresp : coverpoint resp {
    bins OKAY   = {2'b00};
    bins SLVERR = {2'b10};
    bins DECERR = {2'b11};
    illegal_bins EXOKAY = {2'b01};
  }

  cross_addr_x_bresp : cross cp_awaddr, cp_bresp;
  cross_strb_x_addr  : cross cp_wstrb,  cp_awaddr;
endgroup

covergroup cg_read with function sample(bit [31:0] addr, bit [2:0] prot, bit [1:0] resp);
  option.per_instance = 1;

  cp_araddr : coverpoint addr {
    bins low_inrange    = {[32'h0 : 32'h0C]};
    bins mid_inrange    = {[32'h10 : LAST_VALID-4]};
    bins last_inrange   = {LAST_VALID};
    bins first_outrange = {FIRST_INVAL};
    bins far_outrange   = {[FIRST_INVAL+4 : $]};
    bins unaligned      = {[32'h1:32'h3], [32'h5:32'h7]};
  }

  cp_arprot : coverpoint prot {
    bins prot[] = {[0:7]};
  }

  cp_rresp : coverpoint resp {
    bins OKAY   = {2'b00};
    bins SLVERR = {2'b10};
    bins DECERR = {2'b11};
    illegal_bins EXOKAY = {2'b01};
  }

  cross_addr_x_rresp : cross cp_araddr, cp_rresp;
endgroup

function new(string name = "axi_coverage", uvm_component parent);
  super.new(name, parent);
  ap_inwr  = new("ap_inwr",  this);
  ap_inrd  = new("ap_inrd",  this);
  ap_outwr = new("ap_outwr", this);
  ap_outrd = new("ap_outrd", this);
  cg_write = new();
  cg_read  = new();
endfunction

function void write_inwr(axi_seq_item t);
  wr_q.push_back(t);
endfunction

function void write_inrd(axi_seq_item t);
  rd_q.push_back(t);
endfunction

function void write_outwr(axi_seq_item t);
  axi_seq_item req;
  if(wr_q.size() == 0) begin
    `uvm_warning("COVERAGE","B response with no pending write request")
    return;
  end
  req = wr_q.pop_front();
  cg_write.sample(req.AWADDR, req.AWPROT, req.WDATA, req.WSTRB, t.BRESP);
endfunction

function void write_outrd(axi_seq_item t);
  axi_seq_item req;
  if(rd_q.size() == 0) begin
    `uvm_warning("COVERAGE","R response with no pending read request")
    return;
  end
  req = rd_q.pop_front();
  cg_read.sample(req.ARADDR, req.ARPROT, t.RRESP);
endfunction

function void report_phase(uvm_phase phase);
  `uvm_info("COVERAGE",$sformatf("cg_write = %0.2f%%  cg_read = %0.2f%%", cg_write.get_coverage(), cg_read.get_coverage()),UVM_NONE)
  if(wr_q.size() != 0)
    `uvm_warning("COVERAGE",$sformatf("%0d writes never got a B response", wr_q.size()))
  if(rd_q.size() != 0)
    `uvm_warning("COVERAGE",$sformatf("%0d reads never got an R response", rd_q.size()))
endfunction

endclass
