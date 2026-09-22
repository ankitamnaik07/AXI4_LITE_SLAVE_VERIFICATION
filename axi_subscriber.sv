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


  axi_seq_item rdintr;
  axi_seq_item wrintr;
  axi_seq_item rdouttr;
  axi_seq_item wrouttr;

  covergroup cg_write;
    option.per_instance = 1;

    awaddr_cp: coverpoint wrintr.AWADDR {
      bins read_write = {[32'h00 : 32'h24]};
      bins read_only = {[32'h28 : 32'h30]};
      bins write_only = {[32'h34 : 32'h38]};
      bins boundry_rw = {32'h3C};
      bins others = default;
    }

    wdata_cp: coverpoint wrintr.WDATA {
      bins low  = {[32'h0000_0000 : 32'h5555_5555]};
      bins mid  = {[32'h5555_5556 : 32'hAAAA_AAAA]};
      bins high = {[32'hAAAA_AAAB : 32'hFFFF_FFFF]};
    }

    wstrb_cp: coverpoint wrintr.WSTRB {
      bins all_bytes   = {4'b1111};
      bins no_bytes    = {4'b0000};
      bins single_byte = {4'b0001, 4'b0010, 4'b0100, 4'b1000};
      bins partial     = default;
    }
    cp_bresp : coverpoint wrintr.BRESP {
      bins OKAY   = {2'b00};
      bins SLVERR = {2'b10};
      bins DECERR = {2'b11};
      illegal_bins EXOKAY = {2'b01};
    }
  endgroup

  covergroup cg_read;
    option.per_instance = 1;

    araddr_cp: coverpoint rdintr.ARADDR {
      bins low    = {[32'h0 : 32'h0C]};
      bins mid    = {[32'h10 : 32'h38]};
      bins last   = {32'h3C};
      bins out   = {[32'h40 : $]};
      bins unaligned= {[32'h0 : 32'h3B]} with (item % 4 != 0);
    }
    cp_arprot : coverpoint rdintr.ARPROT {
      bins all_prots[] = {[0:7]};
    }
  endgroup

  function new(string name = "axi_subscriber", uvm_component parent);
    super.new(name, parent);
    ap_inwr  = new("ap_inwr",  this);
    ap_inrd  = new("ap_inrd",  this);
    ap_outwr = new("ap_outwr", this);
    ap_outrd = new("ap_outrd", this);
    cg_write = new();
    cg_read  = new();
  endfunction

  function void write_inwr(axi_seq_item t);
    wrintr = t;
    cg_write.sample();
  endfunction

  function void write_inrd(axi_seq_item t);
    rdintr = t;
    cg_read.sample();
  endfunction

  function void write_outwr(axi_seq_item t);
    wrouttr = t;
    cg_write.sample();
  endfunction

  function void write_outrd(axi_seq_item t);
    rdouttr = t;
    cg_read.sample();
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("COVERAGE", $sformatf("Write Coverage = %0.2f%% | Read Coverage = %0.2f%%",
                cg_write.get_coverage(), cg_read.get_coverage()), UVM_NONE)
  endfunction

endclass
