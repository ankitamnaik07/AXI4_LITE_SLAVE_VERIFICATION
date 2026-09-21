/*

class axi_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(axi_scoreboard)

  uvm_tlm_analysis_fifo #(axi_seq_item) moninwr_fifo;
  uvm_tlm_analysis_fifo #(axi_seq_item) moninrd_fifo;
  uvm_tlm_analysis_fifo #(axi_seq_item) monoutwr_fifo;
  uvm_tlm_analysis_fifo #(axi_seq_item) monoutrd_fifo;

  axi_seq_item monwrtr;
  axi_seq_item monrdtr;

  bit [31:0] mem [int];

  function new(string name = "axi_scoreboard", uvm_component parent);
    super.new(name, parent);
    moninwr_fifo = new("moninwr_fifo", this);
    moninrd_fifo = new("moninrd_fifo", this);
    monoutwr_fifo = new("monoutwr_fifo", this);
    monoutrd_fifo = new("monoutrd_fifo", this);
  endfunction

  task run_phase(uvm_phase phase);
    fork
      write_check();
      read_check();
    join
  endtask

  task write_check();
    axi_seq_item exp_tr;
    axi_seq_item act_tr;
    forever begin
      moninwr_fifo.get(exp_tr);
      // Replaced sprint() with convert2string()

      	    `uvm_info("SCOREBOARD", {"INPUT MONITOR ", exp_tr.convert2string()}, UVM_HIGH)
      
      ref_model_wr(exp_tr);

      monoutwr_fifo.get(act_tr);
      // Replaced sprint() with convert2string()
      `uvm_info("SCOREBOARD", {"OUTPUT MONITOR ", act_tr.convert2string()}, UVM_HIGH)

      if(act_tr.BRESP != exp_tr.BRESP) begin
        `uvm_error(get_type_name(),$sformatf("WR BRESP mismatch: AWADDR=0x%0h exp=%0b act=%0b",exp_tr.AWADDR, exp_tr.BRESP, act_tr.BRESP))
      end else begin
        `uvm_info(get_type_name(),
          $sformatf("WR match: AWADDR=0x%0h BRESP=%0b", exp_tr.AWADDR, exp_tr.BRESP),UVM_HIGH)
      end
    end
  endtask

  task read_check();
    axi_seq_item exp_tr;
    axi_seq_item act_tr;
    forever begin
      moninrd_fifo.get(exp_tr);
      ref_model_rd(exp_tr);
      monoutrd_fifo.get(act_tr);

      if (act_tr.RRESP !== exp_tr.RRESP) begin
        `uvm_error(get_type_name(),$sformatf("RD RRESP mismatch: ARADDR=0x%0h exp=%0b act=%0b",exp_tr.ARADDR, exp_tr.RRESP, act_tr.RRESP))
      end
      else if (exp_tr.RRESP == 2'b00 && act_tr.RDATA !== exp_tr.RDATA) begin
        `uvm_error(get_type_name(),
          $sformatf("RD DATA mismatch: ARADDR=0x%0h exp=0x%0h act=0x%0h",
                     exp_tr.ARADDR, exp_tr.RDATA, act_tr.RDATA))
      end
      else if (exp_tr.RRESP != 2'b00 && act_tr.RDATA !== 32'h0) begin
        `uvm_error(get_type_name(),
          $sformatf("RD ERROR LEAK: RDATA must be 0 on error. ARADDR=0x%0h RRESP=%0b act_data=0x%0h",
                     exp_tr.ARADDR, act_tr.RRESP, act_tr.RDATA))
      end
      else begin
        `uvm_info(get_type_name(),
          $sformatf("RD match: ARADDR=0x%0h RDATA=0x%0h", exp_tr.ARADDR, exp_tr.RDATA),
          UVM_HIGH)
      end
    end
  endtask

  task ref_model_wr(axi_seq_item tr);
    if(tr.AWADDR[1:0] != 2'b00)
      tr.BRESP = 2'b10;
    else if(tr.AWADDR > 32'h3C)
      tr.BRESP = 2'b11;
    else if(tr.AWADDR >= 32'h28 && tr.AWADDR <= 32'h30)
      tr.BRESP = 2'b10;
    else begin
      for(int i = 0; i < 4; i++) begin
        if(tr.WSTRB[i])
          mem[tr.AWADDR][i*8 +:8] = tr.WDATA[i*8 +:8];
      end
    end
  endtask

  task ref_model_rd(axi_seq_item tr);
    if(tr.ARADDR[1:0] != 2'b00)
      tr.RRESP = 2'b10;
    else if(tr.ARADDR > 32'h3C)
      tr.RRESP = 2'b11;
    else if(tr.ARADDR >= 32'h34 && tr.ARADDR <= 32'h38)
      tr.RRESP = 2'b10;
    else
      tr.RDATA = mem[tr.ARADDR];
  endtask
endclass*/



class axi_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(axi_scoreboard)

  uvm_tlm_analysis_fifo #(axi_seq_item) moninwr_fifo;
  uvm_tlm_analysis_fifo #(axi_seq_item) moninrd_fifo;
  uvm_tlm_analysis_fifo #(axi_seq_item) monoutwr_fifo;
  uvm_tlm_analysis_fifo #(axi_seq_item) monoutrd_fifo;

  bit [31:0] mem [int];

  function new(string name = "axi_scoreboard", uvm_component parent);
    super.new(name, parent);
    moninwr_fifo  = new("moninwr_fifo", this);
    moninrd_fifo  = new("moninrd_fifo", this);
    monoutwr_fifo = new("monoutwr_fifo", this);
    monoutrd_fifo = new("monoutrd_fifo", this);
  endfunction

  task run_phase(uvm_phase phase);
    fork
      write_check();
      read_check();
    join
  endtask

  task write_check();
    axi_seq_item exp_tr;
    axi_seq_item act_tr;
    forever begin
      moninwr_fifo.get(exp_tr);
      `uvm_info("SCOREBOARD", $sformatf("INPUT MONITOR [WRITE]: %s", exp_tr.convert2string()), UVM_HIGH)

      ref_model_wr(exp_tr);

      monoutwr_fifo.get(act_tr);
      `uvm_info("SCOREBOARD", $sformatf("OUTPUT MONITOR [WRITE]: %s", act_tr.convert2string()), UVM_HIGH)

      if (act_tr.BRESP !== exp_tr.BRESP) begin
        `uvm_error(get_type_name(),
          $sformatf("WR BRESP mismatch: AWADDR=0x%0h exp=0b%02b act=0b%02b",
                    exp_tr.AWADDR, exp_tr.BRESP, act_tr.BRESP))
      end else begin
        `uvm_info(get_type_name(),
          $sformatf("WR match: AWADDR=0x%0h BRESP=%0b", exp_tr.AWADDR, exp_tr.BRESP), UVM_HIGH)
      end
    end
  endtask

  task read_check();
    axi_seq_item exp_tr;
    axi_seq_item act_tr;
    forever begin
      moninrd_fifo.get(exp_tr);
      ref_model_rd(exp_tr);
      monoutrd_fifo.get(act_tr);

      if (act_tr.RRESP !== exp_tr.RRESP) begin
        `uvm_error(get_type_name(),
          $sformatf("RD RRESP mismatch: ARADDR=0x%0h exp=0b%02b act=0b%02b",
                    exp_tr.ARADDR, exp_tr.RRESP, act_tr.RRESP))
      end
      else if (exp_tr.RRESP == 2'b00 && act_tr.RDATA !== exp_tr.RDATA) begin
        `uvm_error(get_type_name(),
          $sformatf("RD DATA mismatch: ARADDR=0x%0h exp=0x%08h act=0x%08h",
                    exp_tr.ARADDR, exp_tr.RDATA, act_tr.RDATA))
      end
      else if (exp_tr.RRESP != 2'b00 && act_tr.RDATA !== 32'h0) begin
        `uvm_error(get_type_name(),
          $sformatf("RD ERROR LEAK: RDATA must be 0 on error. ARADDR=0x%0h RRESP=0b%02b act_data=0x%08h",
                    exp_tr.ARADDR, act_tr.RRESP, act_tr.RDATA))
      end
      else begin
        `uvm_info(get_type_name(),
          $sformatf("RD match: ARADDR=0x%0h RDATA=0x%08h", exp_tr.ARADDR, exp_tr.RDATA), UVM_HIGH)
      end
    end
  endtask

  task ref_model_wr(axi_seq_item tr);
    if (tr.AWADDR[1:0] != 2'b00)
      tr.BRESP = 2'b10; // SLVERR for unaligned access
    else if (tr.AWADDR > 32'h3C)
      tr.BRESP = 2'b11; // DECERR for out of bounds
    else if (tr.AWADDR >= 32'h28 && tr.AWADDR <= 32'h30)
      tr.BRESP = 2'b10; // SLVERR for read-only addresses
    else begin
      tr.BRESP = 2'b00; // OKAY
      for (int i = 0; i < 4; i++) begin
        if (tr.WSTRB[i])
          mem[tr.AWADDR][i*8 +: 8] = tr.WDATA[i*8 +: 8];
      end
    end
  endtask

  task ref_model_rd(axi_seq_item tr);
    if (tr.ARADDR[1:0] != 2'b00) begin
      tr.RRESP = 2'b10; // SLVERR
      tr.RDATA = 32'h0;
    end else if (tr.ARADDR > 32'h3C) begin
      tr.RRESP = 2'b11; // DECERR
      tr.RDATA = 32'h0;
    end else if (tr.ARADDR >= 32'h34 && tr.ARADDR <= 32'h38) begin
      tr.RRESP = 2'b10; // SLVERR for write-only addresses
      tr.RDATA = 32'h0;
    end else begin
      tr.RRESP = 2'b00; // OKAY
      if (mem.exists(tr.ARADDR))
        tr.RDATA = mem[tr.ARADDR];
      else
        tr.RDATA = 32'h0;
    end
  endtask
endclass
