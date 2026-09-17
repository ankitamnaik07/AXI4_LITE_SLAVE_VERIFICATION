class axi_output_agent extends uvm_agent;
`uvm_component_utils(axi_output_agent)
axi_output_monitor outmon;
axi_config a_cfg;

function new(string name = "axi_output_agent", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!(uvm_config_db #(axi_config)::get(this,"","axi_cfg",a_cfg))) begin
    `uvm_fatal(get_type_name(),"OUTPUT AGENT not Configured")
   end
  outmon = axi_output_monitor::type_id::create("outmon", this);
  if(a_cfg.input_agent_is_active == UVM_PASSIVE) begin
    outmon = axi_output_monitor::type_id::create("output_monitor", this);
  end
endfunction


endclass
