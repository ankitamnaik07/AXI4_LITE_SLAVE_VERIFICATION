/*class axi_output_monitor extends uvm_monitor;
  `uvm_component_utils(axi_output_monitor)

  axi_config a_cfg;
  virtual axi_interface.monout vif;

  uvm_analysis_port #(axi_seq_item) outrd_port;
  uvm_analysis_port #(axi_seq_item) outwr_port;

  function new(string name = "axi_output_monitor", uvm_component parent);
    super.new(name, parent);
    outrd_port = new("outrd_port", this);
    outwr_port = new("outwr_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(axi_config)::get(this, "", "axi_cfg", a_cfg))
      `uvm_fatal("OUTPUT_MONITOR", "OUTPUT MONITOR CONFIG NOT FOUND")
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = a_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    repeat(3) @(vif.monout_cb);
    forever begin
      @(vif.monout_cb);

      // --- Write Response Phase (B Channel) ---
      if (vif.monout_cb.BVALID && vif.monout_cb.BREADY) begin
        axi_seq_item wrtr;
        wrtr = axi_seq_item::type_id::create("wrtr");

        wrtr.BVALID = vif.monout_cb.BVALID;
        wrtr.BREADY = vif.monout_cb.BREADY;
        wrtr.BRESP  = vif.monout_cb.BRESP;

        outwr_port.write(wrtr);
        // Changed to convert2string()
        `uvm_info("OUTPUT_MONITOR", {"Captured Write Response", wrtr.convert2string()}, UVM_HIGH)
      end

      // --- Read Data Phase (R Channel) ---
      if (vif.monout_cb.RVALID && vif.monout_cb.RREADY) begin
        axi_seq_item rdtr;
        rdtr = axi_seq_item::type_id::create("rdtr");

        rdtr.RVALID = vif.monout_cb.RVALID;
        rdtr.RREADY = vif.monout_cb.RREADY;
        rdtr.RDATA  = vif.monout_cb.RDATA;
        rdtr.RRESP  = vif.monout_cb.RRESP;

        outrd_port.write(rdtr);
        // Changed to convert2string()
        `uvm_info("OUTPUT_MONITOR", {"Captured Read Data", rdtr.convert2string()}, UVM_HIGH)
      end
    end
  endtask
endclass*/



class axi_output_monitor extends uvm_monitor;
  `uvm_component_utils(axi_output_monitor)

  axi_config a_cfg;
  virtual axi_interface.monout vif;

  uvm_analysis_port #(axi_seq_item) outrd_port;
  uvm_analysis_port #(axi_seq_item) outwr_port;

  function new(string name = "axi_output_monitor", uvm_component parent);
    super.new(name, parent);
    outrd_port = new("outrd_port", this);
    outwr_port = new("outwr_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(axi_config)::get(this, "", "axi_cfg", a_cfg))
      `uvm_fatal("OUTPUT_MONITOR", "OUTPUT MONITOR CONFIG NOT FOUND")
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = a_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    repeat(3) @(vif.monout_cb);
    fork
      monitor_b_channel();
      monitor_r_channel();
    join
  endtask

  // Write Response Phase (B Channel)
  task monitor_b_channel();
    axi_seq_item wrtr;
    forever begin
      @(vif.monout_cb);
      if (vif.monout_cb.BVALID && vif.monout_cb.BREADY) begin
        wrtr = axi_seq_item::type_id::create("wrtr");
        wrtr.BVALID = vif.monout_cb.BVALID;
        wrtr.BREADY = vif.monout_cb.BREADY;
        wrtr.BRESP  = vif.monout_cb.BRESP;

        outwr_port.write(wrtr);
        `uvm_info("OUTPUT_MONITOR", $sformatf("Captured Write Response %s", wrtr.convert2string()), UVM_HIGH)
      end
    end
  endtask

  // Read Data Phase (R Channel)
  task monitor_r_channel();
    axi_seq_item rdtr;
    forever begin
      @(vif.monout_cb);
      if (vif.monout_cb.RVALID && vif.monout_cb.RREADY) begin
        rdtr = axi_seq_item::type_id::create("rdtr");
        rdtr.RVALID = vif.monout_cb.RVALID;
        rdtr.RREADY = vif.monout_cb.RREADY;
        rdtr.RDATA  = vif.monout_cb.RDATA;
        rdtr.RRESP  = vif.monout_cb.RRESP;

        outrd_port.write(rdtr);
        `uvm_info("OUTPUT_MONITOR", $sformatf("Captured Read Data %s", rdtr.convert2string()), UVM_HIGH)
      end
    end
  endtask
endclass
