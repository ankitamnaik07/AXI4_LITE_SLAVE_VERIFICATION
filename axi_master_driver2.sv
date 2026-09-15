class axi_master_driver extends uvm_driver#(axi_seq_item);
  `uvm_component_utils(axi_master_driver)
  axi_seq_item trr,trw;
  axi_config a_cfg;
  virtual axi_interface.drv vif;
  uvm_seq_item_pull_port #(axi_seq_item) rep;

  function new(string name = "axi_driver", uvm_component parent);
    super.new(name, parent);
    rep = new("rep",this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db#(axi_config)::get(this,"","axi_cfg",a_cfg)))
      `uvm_fatal(get_full_name(),"DRIVER CONFIG NOT CONNECTED")
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = a_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    repeat(3)@(vif.drv_cb);
    fork
      write_op();
      read_op();
    join
  endtask

  task write_op();
    forever begin
      seq_item_port.get_next_item(trw);
      wr_addr(trw);
      wr_data(trw);
      wr_response(trw);
      seq_item_port.item_done();
    end
  endtask

  task read_op();
    forever begin
      rep.get_next_item(trr);
      rd_addr(trr);
      rd_data(trr);
      rep.item_done();
    end
  endtask

  task wr_addr(axi_seq_item wrar);
    vif.drv_cb.AWADDR  <= wrar.AWADDR;
    vif.drv_cb.AWPROT  <= wrar.AWPROT;
    vif.drv_cb.AWVALID <= 1'b1;
    do begin
      @(vif.drv_cb); 
    end while(!vif.drv_cb.AWREADY);
    vif.drv_cb.AWVALID <= 1'b0;
  endtask

  task wr_data(axi_seq_item wrdt);
    vif.drv_cb.WDATA  <= wrdt.WDATA;
    vif.drv_cb.WSTRB  <= wrdt.WSTRB;
    vif.drv_cb.WVALID <= 1'b1;
    do begin
      @(vif.drv_cb);
    end while(!vif.drv_cb.WREADY);
    vif.drv_cb.WVALID <= 1'b0;
  endtask

  task wr_response(axi_seq_item wrsp);
    vif.drv_cb.BREADY <= 1'b1;
    do begin
      @(vif.drv_cb);
    end while(!vif.drv_cb.BVALID);
    vif.drv_cb.BREADY <= 1'b0;
  endtask

  task rd_addr(axi_seq_item rdar);
    vif.drv_cb.ARADDR  <= rdar.ARADDR;
    vif.drv_cb.ARPROT  <= rdar.ARPROT;
    vif.drv_cb.ARVALID <= 1'b1;
    do begin
      @(vif.drv_cb);
    end while(!vif.drv_cb.ARREADY);
    vif.drv_cb.ARVALID <= 1'b0;
  endtask

  task rd_data(axi_seq_item rddt);
    vif.drv_cb.RREADY <= 1'b1;
    do begin
      @(vif.drv_cb);
    end while(!vif.drv_cb.RVALID);
    vif.drv_cb.RREADY <= 1'b0;
  endtask
endclass
