class axi_environment extends uvm_env;
`uvm_component_utils(axi_environment)

axi_input_agent inp_agnt;
axi_output_agent out_agnt;
axi_scoreboard scb;
axi_subscriber subr;
function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  inp_agnt = axi_input_agent::type_id::create("inp_agnt", this);
  out_agnt = axi_output_agent::type_id::create("out_agnt", this);
  scb = axi_scoreboard::type_id::create("scb", this);
  subr = axi_subscriber::type_id::create("subr", this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  inp_agnt.inmon.inwr_port.connect(scb.moninwr_fifo.analysis_export);
  inp_agnt.inmon.inrd_port.connect(scb.moninrd_fifo.analysis_export);
  out_agnt.outmon.outwr_port.connect(scb.monoutwr_fifo.analysis_export);
  out_agnt.outmon.outrd_port.connect(scb.monoutrd_fifo.analysis_export);
  
  inp_agnt.inmon.inwr_port.connect(subr.ap_inwr);
  inp_agnt.inmon.inrd_port.connect(subr.ap_inrd);
  out_agnt.outmon.outwr_port.connect(subr.ap_outwr);
  out_agnt.outmon.outrd_port.connect(subr.ap_outrd);
endfunction

endclass
