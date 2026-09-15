class axi_input_agent extends uvm_agent;
`uvm_component_utils(axi_input_agent)
axi_sequencer rdsqr;
axi_sequencer wrsqr;
axi_master_driver drv;
axi_input_monitor inmon;
axi_config a_cfg;
function new(string name = "axi_input_agent", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!(uvm_config_db #(axi_config)::get(this,"","axi_cfg",a_cfg))) begin
    `uvm_fatal(get_type_name(),"INPUT AGENT not Configured")
   end
  inmon = axi_input_monitor::type_id::create("inmon", this);
  if(a_cfg.input_agent_is_active == UVM_ACTIVE) begin
    rdsqr = axi_sequencer::type_id::create("rdsqr",this);
    wrsqr = axi_sequencer::type_id::create("wrsqr",this);
    drv = axi_master_driver::type_id::create("drv", this);
  end
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(a_cfg.input_agent_is_active == UVM_ACTIVE) begin
   this.drv.seq_item_port.connect(this.wrsqr.seq_item_export); 
   this.drv.rep.connect(this.rdsqr.seq_item_export);          
  end
endfunction

endclass
