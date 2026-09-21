/*class axi_input_monitor extends uvm_monitor;
`uvm_component_utils(axi_input_monitor)
axi_config a_cfg;
virtual axi_interface.monin vif;
uvm_analysis_port #(axi_seq_item) inwr_port;
uvm_analysis_port #(axi_seq_item) inrd_port;
axi_seq_item wrtr;
axi_seq_item rdtr;
bit w_done,aw_done;

function new(string name = "axi_input_monitor", uvm_component parent);
  super.new(name, parent);
  inwr_port = new("inwr_port", this);
  inrd_port = new("inrd_port", this);  
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!(uvm_config_db#(axi_config)::get(this,"","axi_cfg",a_cfg)))
    `uvm_fatal("INPUT_MONITOR","INPUT MONITOR NOT CONFIGURED")
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif = a_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
repeat(3) @(vif.monin_cb);
wrtr = axi_seq_item::type_id::create("wrtr");
rdtr = axi_seq_item::type_id::create("rdtr");
forever begin
@(vif.monin_cb);
fork
  if(vif.monin_cb.AWVALID && vif.monin_cb.AWREADY) begin
    wrtr.AWPROT = vif.monin_cb.AWPROT;
    wrtr.AWADDR = vif.monin_cb.AWADDR;
    $display("GOT AWVALID and AWREADY");
    aw_done = 1;
  end
  if(vif.monin_cb.WVALID && vif.monin_cb.WREADY) begin  
    wrtr.WDATA = vif.monin_cb.WDATA; 
    wrtr.WSTRB = vif.monin_cb.WSTRB;
    $display("GOT WVALID and WREADY");
    w_done = 1;
  end
join

if(aw_done && w_done) begin
  inwr_port.write(wrtr);
  `uvm_info("INPUT_MONITOR",$sformatf("Input MONITOR[WRITE TRANSACTION]\n%s",wrtr.sprint()),UVM_NONE)
  wrtr = axi_seq_item::type_id::create("wrtr");
  aw_done = 0;
  w_done  = 0;
end
  
  if(vif.monin_cb.ARVALID && vif.monin_cb.ARREADY) begin
    rdtr.ARADDR = vif.monin_cb.ARADDR;
    inrd_port.write(rdtr);
  `uvm_info("INPUT_MONITOR",$sformatf("Input MONITOR[READ TRANSACTION]\n%s",wrtr.sprint()),UVM_NONE)
  end
end
endtask
endclass*/


class axi_input_monitor extends uvm_monitor;
  `uvm_component_utils(axi_input_monitor)
  
  axi_config a_cfg;
  virtual axi_interface.monin vif;
  
  uvm_analysis_port #(axi_seq_item) inwr_port;
  uvm_analysis_port #(axi_seq_item) inrd_port;
  
  axi_seq_item wrtr;
  axi_seq_item rdtr;
  bit w_done, aw_done;

  function new(string name = "axi_input_monitor", uvm_component parent);
    super.new(name, parent);
    inwr_port = new("inwr_port", this);
    inrd_port = new("inrd_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db#(axi_config)::get(this,"","axi_cfg",a_cfg)))
      `uvm_fatal("INPUT_MONITOR","INPUT MONITOR NOT CONFIGURED")
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = a_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    repeat(3) @(vif.monin_cb);
    wrtr = axi_seq_item::type_id::create("wrtr");
    rdtr = axi_seq_item::type_id::create("rdtr");
    
    forever begin
      @(vif.monin_cb);
      fork
        if(vif.monin_cb.AWVALID && vif.monin_cb.AWREADY) begin
          wrtr.AWVALID = vif.monin_cb.AWVALID;
          wrtr.AWREADY = vif.monin_cb.AWREADY;
          wrtr.AWPROT  = vif.monin_cb.AWPROT;
          wrtr.AWADDR  = vif.monin_cb.AWADDR;
          $display("GOT AWVALID and AWREADY");
          aw_done = 1;
        end
        
        if(vif.monin_cb.WVALID && vif.monin_cb.WREADY) begin
          wrtr.WVALID = vif.monin_cb.WVALID;
          wrtr.WREADY = vif.monin_cb.WREADY;
          wrtr.WDATA  = vif.monin_cb.WDATA;
          wrtr.WSTRB  = vif.monin_cb.WSTRB;
          $display("GOT WVALID and WREADY");
          w_done = 1;
        end
      join

      if(aw_done && w_done) begin
        inwr_port.write(wrtr);
	      for(int i=1;i<=`num_of_transaction;i=i+1)
		      $display("TRANSACTION:%d", i);
	      $display("=============================INPUT MONITOR=============================================");
	`uvm_info("INPUT_MONITOR", {"Input MONITOR[WRITE TRANSACTION]", wrtr.convert2string()}, UVM_NONE)
        wrtr = axi_seq_item::type_id::create("wrtr");
        aw_done = 0;
        w_done  = 0;
      end

      if(vif.monin_cb.ARVALID && vif.monin_cb.ARREADY) begin
        rdtr = axi_seq_item::type_id::create("rdtr"); // ensure fresh object for read
        rdtr.ARVALID = vif.monin_cb.ARVALID;
        rdtr.ARREADY = vif.monin_cb.ARREADY;
        rdtr.ARADDR  = vif.monin_cb.ARADDR;
        rdtr.ARPROT  = vif.monin_cb.ARPROT;
        inrd_port.write(rdtr);
        // Fixed: changed wrtr.sprint() to rdtr.convert2string()
        `uvm_info("INPUT_MONITOR", {"Input MONITOR[READ TRANSACTION]", rdtr.convert2string()}, UVM_NONE)
      end
    end
  endtask
endclass
