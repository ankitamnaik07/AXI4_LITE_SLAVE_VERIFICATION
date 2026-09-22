class axi_input_monitor extends uvm_monitor;
  `uvm_component_utils(axi_input_monitor)

  axi_config a_cfg;
  virtual axi_interface.monin vif;

  uvm_analysis_port #(axi_seq_item) inwr_port;
  uvm_analysis_port #(axi_seq_item) inrd_port;

  axi_seq_item wrtr;
  axi_seq_item rdtr;
  bit w_done, aw_done;

  protected axi_seq_item aw_q[$];
  protected axi_seq_item w_q[$];

  function new(string name = "axi_input_monitor", uvm_component parent);
    super.new(name, parent);
    inwr_port = new("inwr_port", this);
    inrd_port = new("inrd_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(axi_config)::get(this, "", "axi_cfg", a_cfg))
      `uvm_fatal("INPUT_MONITOR", "INPUT MONITOR NOT CONFIGURED")
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = a_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    repeat(3) @(vif.monin_cb);

    forever begin
      @(vif.monin_cb);

      if (vif.monin_cb.AWVALID && vif.monin_cb.AWREADY) begin
        axi_seq_item aw_temp;
        aw_temp = axi_seq_item::type_id::create("aw_temp");
        aw_temp.AWVALID = vif.monin_cb.AWVALID;
        aw_temp.AWREADY = vif.monin_cb.AWREADY;
        aw_temp.AWPROT  = vif.monin_cb.AWPROT;
        aw_temp.AWADDR  = vif.monin_cb.AWADDR;
        aw_q.push_back(aw_temp);
      end

      if (vif.monin_cb.WVALID && vif.monin_cb.WREADY) begin
        axi_seq_item w_temp;
        w_temp = axi_seq_item::type_id::create("w_temp");
        w_temp.WVALID = vif.monin_cb.WVALID;
        w_temp.WREADY = vif.monin_cb.WREADY;
        w_temp.WDATA  = vif.monin_cb.WDATA;
        w_temp.WSTRB  = vif.monin_cb.WSTRB;
        w_q.push_back(w_temp);
      end

      while (aw_q.size() > 0 && w_q.size() > 0) begin
        axi_seq_item aw_item;
        axi_seq_item w_item;

        aw_item = aw_q.pop_front();
        w_item  = w_q.pop_front();

        wrtr = axi_seq_item::type_id::create("wrtr");
        wrtr.AWVALID = aw_item.AWVALID;
        wrtr.AWREADY = aw_item.AWREADY;
        wrtr.AWADDR  = aw_item.AWADDR;
        wrtr.AWPROT  = aw_item.AWPROT;

        wrtr.WVALID  = w_item.WVALID;
        wrtr.WREADY  = w_item.WREADY;
        wrtr.WDATA   = w_item.WDATA;
        wrtr.WSTRB   = w_item.WSTRB;

        inwr_port.write(wrtr);
        `uvm_info("INPUT_MONITOR", {"Input MONITOR[WRITE TRANSACTION]\n", wrtr.convert2string()}, UVM_NONE)
      end

      if (vif.monin_cb.ARVALID && vif.monin_cb.ARREADY) begin
        rdtr = axi_seq_item::type_id::create("rdtr");
        rdtr.ARVALID = vif.monin_cb.ARVALID;
        rdtr.ARREADY = vif.monin_cb.ARREADY;
        rdtr.ARADDR  = vif.monin_cb.ARADDR;
        rdtr.ARPROT  = vif.monin_cb.ARPROT;

        inrd_port.write(rdtr);
        `uvm_info("INPUT_MONITOR", {"Input MONITOR[READ TRANSACTION]\n", rdtr.convert2string()}, UVM_NONE)
      end
    end
  endtask
endclass
