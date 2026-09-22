
class test extends uvm_test;
  `uvm_component_utils(test)

  axi_environment env;
  axi_config      a_cfg;

  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    a_cfg = axi_config::type_id::create("a_cfg");

    if (!(uvm_config_db#(virtual axi_interface)::get(this, "", "axi_if", a_cfg.vif))) begin
      `uvm_fatal("TEST", "TEST is not configured")
    end

    a_cfg.input_agent_is_active  = UVM_ACTIVE;
    a_cfg.output_agent_is_active = UVM_PASSIVE;

    uvm_config_db#(axi_config)::set(this, "*", "axi_cfg", a_cfg);
    env = axi_environment::type_id::create("env", this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
endclass


class basic_test extends test;
  `uvm_component_utils(basic_test)

  basic_seq seq;

  function new(string name = "basic_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = basic_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class write_test extends test;
  `uvm_component_utils(write_test)

  write_seq seq;

  function new(string name = "write_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = write_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class read_test extends test;
  `uvm_component_utils(read_test)

  read_seq seq;

  function new(string name = "read_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = read_seq::type_id::create("seq");
    seq.start(env.inp_agnt.rdsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class read_write_test extends test;
  `uvm_component_utils(read_write_test)

  write_seq wr_seq;
  read_seq  rd_seq;

  function new(string name = "read_write_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    wr_seq = write_seq::type_id::create("wr_seq");
    wr_seq.start(env.inp_agnt.wrsqr);

    rd_seq = read_seq::type_id::create("rd_seq");
    rd_seq.start(env.inp_agnt.rdsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class write_range_test extends test;
  `uvm_component_utils(write_range_test)

  write_range_seq seq;

  function new(string name = "write_range_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = write_range_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class read_range_test extends test;
  `uvm_component_utils(read_range_test)

  read_range_seq seq;

  function new(string name = "read_range_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = read_range_seq::type_id::create("seq");
    seq.start(env.inp_agnt.rdsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class range_test extends test;
  `uvm_component_utils(range_test)

  write_range_seq wr_seq;
  read_range_seq  rd_seq;

  function new(string name = "range_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

        wr_seq = write_range_seq::type_id::create("wr_seq");
   	rd_seq = read_range_seq::type_id::create("rd_seq"); 
    fork
      begin
        wr_seq.start(env.inp_agnt.wrsqr);
      end

      begin
        rd_seq.start(env.inp_agnt.rdsqr);
      end
    join

    #40;
    phase.drop_objection(this);
  endtask
endclass


class write_addr_test extends test;
  `uvm_component_utils(write_addr_test)

  write_addr_seq seq;

  function new(string name = "write_addr_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = write_addr_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class read_addr_test extends test;
  `uvm_component_utils(read_addr_test)

  read_addr_seq seq;

  function new(string name = "read_addr_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = read_addr_seq::type_id::create("seq");
    seq.start(env.inp_agnt.rdsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class addr_test extends test;
  `uvm_component_utils(addr_test)

  write_addr_seq wr_seq;
  read_addr_seq  rd_seq;

  function new(string name = "addr_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    fork
      begin
        wr_seq = write_addr_seq::type_id::create("wr_seq");
        wr_seq.start(env.inp_agnt.wrsqr);
      end

      begin
        rd_seq = read_addr_seq::type_id::create("rd_seq");
        rd_seq.start(env.inp_agnt.rdsqr);
      end
    join

    #40;
    phase.drop_objection(this);
  endtask
endclass


class ro_write_test extends test;
  `uvm_component_utils(ro_write_test)

  ro_write_seq seq;

  function new(string name = "ro_write_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = ro_write_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class wo_read_test extends test;
  `uvm_component_utils(wo_read_test)

  wo_read_seq seq;

  function new(string name = "wo_read_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = wo_read_seq::type_id::create("seq");
    seq.start(env.inp_agnt.rdsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class unaligned_wr_test extends test;
  `uvm_component_utils(unaligned_wr_test)

  unaligned_wr_seq seq;

  function new(string name = "unaligned_wr_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = unaligned_wr_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class unaligned_rd_test extends test;
  `uvm_component_utils(unaligned_rd_test)

  unaligned_rd_seq seq;

  function new(string name = "unaligned_rd_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = unaligned_rd_seq::type_id::create("seq");
    seq.start(env.inp_agnt.rdsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class decerr_wr_test extends test;
  `uvm_component_utils(decerr_wr_test)

  decerr_wr_seq seq;

  function new(string name = "decerr_wr_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = decerr_wr_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class decerr_rd_test extends test;
  `uvm_component_utils(decerr_rd_test)

  decerr_rd_seq seq;

  function new(string name = "decerr_rd_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = decerr_rd_seq::type_id::create("seq");
    seq.start(env.inp_agnt.rdsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class wstrb_sweep_test extends test;
  `uvm_component_utils(wstrb_sweep_test)

  wstrb_sweep_seq seq;

  function new(string name = "wstrb_sweep_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = wstrb_sweep_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class wstrb_pattern_test extends test;
  `uvm_component_utils(wstrb_pattern_test)

  wstrb_pattern_seq seq;

  function new(string name = "wstrb_pattern_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = wstrb_pattern_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class aw_first_test extends test;
  `uvm_component_utils(aw_first_test)

  aw_first_seq seq;

  function new(string name = "aw_first_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = aw_first_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class w_first_test extends test;
  `uvm_component_utils(w_first_test)

  w_first_seq seq;

  function new(string name = "w_first_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = w_first_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection( this );
  endtask
endclass


class memory_sweep_test extends test;
  `uvm_component_utils(memory_sweep_test)

  memory_sweep_seq seq;

  function new(string name = "memory_sweep_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = memory_sweep_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class fixed_write_test extends test;
  `uvm_component_utils(fixed_write_test)

  fixed_write_seq seq;

  function new(string name = "fixed_write_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = fixed_write_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class addr_sweep_test extends test;
  `uvm_component_utils(addr_sweep_test)

  addr_sweep_seq seq;

  function new(string name = "addr_sweep_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = addr_sweep_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass




class minmax_addr_write_test extends test;
  `uvm_component_utils(minmax_addr_write_test)

  minmax_addr_write seq;

  function new(string name = "minmax_addr_write_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = minmax_addr_write::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass

class minmax_addr_read_test extends test;
  `uvm_component_utils(minmax_addr_read_test)

  minmax_addr_read seq;

  function new(string name = "minmax_addr_read_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = minmax_addr_read::type_id::create("seq");
    seq.start(env.inp_agnt.rdsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass



class reset_value_test extends test;
  `uvm_component_utils(reset_value_test)

  read_addr_seq seq;

  function new(string name = "reset_value_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = read_addr_seq::type_id::create("seq");
    seq.start(env.inp_agnt.rdsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass

class reset_mid_txn_test extends test;
  `uvm_component_utils(reset_mid_txn_test)

  write_seq wr_seq;
  read_seq  rd_seq;

  function new(string name = "reset_mid_txn_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    fork : traffic_and_reset
      begin
        wr_seq = write_seq::type_id::create("wr_seq");
        wr_seq.start(env.inp_agnt.wrsqr);
      end

      begin
        rd_seq = read_seq::type_id::create("rd_seq");
        rd_seq.start(env.inp_agnt.rdsqr);
      end

      begin
        #20;
        a_cfg.vif.ARESETn <= 1'b0;
        #30;
        a_cfg.vif.ARESETn <= 1'b1;
        #20;
      end
    join_any
    disable traffic_and_reset;

    env.inp_agnt.wrsqr.stop_sequences();
    env.inp_agnt.rdsqr.stop_sequences();

    #50;

    fork
      begin
        wr_seq = write_seq::type_id::create("wr_seq");
        wr_seq.start(env.inp_agnt.wrsqr);
      end

      begin
        rd_seq = read_seq::type_id::create("rd_seq");
        rd_seq.start(env.inp_agnt.rdsqr);
      end
    join

    #40;
    phase.drop_objection(this);
  endtask
endclass

class ro_readback_test extends test;
  `uvm_component_utils(ro_readback_test)

  ro_readback_seq seq;

  function new(string name = "ro_readback_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = ro_readback_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class wstrb_readback_test extends test;
  `uvm_component_utils(wstrb_readback_test)

  wstrb_readback_seq seq;

  function new(string name = "wstrb_readback_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = wstrb_readback_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class unaligned_nocorrupt_test extends test;
  `uvm_component_utils(unaligned_nocorrupt_test)

  unaligned_nocorrupt_seq seq;

  function new(string name = "unaligned_nocorrupt_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = unaligned_nocorrupt_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class addr_boundary_test extends test;
  `uvm_component_utils(addr_boundary_test)

  addr_boundary_seq seq;

  function new(string name = "addr_boundary_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = addr_boundary_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass


class ready_delay_test extends test;
  `uvm_component_utils(ready_delay_test)

  wr_ready_delay_seq wr_seq;
  rd_ready_delay_seq rd_seq;

  function new(string name = "ready_delay_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    wr_seq = wr_ready_delay_seq::type_id::create("wr_seq");
    wr_seq.start(env.inp_agnt.wrsqr);

    rd_seq = rd_ready_delay_seq::type_id::create("rd_seq");
    rd_seq.start(env.inp_agnt.rdsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass

class b2b_traffic_test extends test;
  `uvm_component_utils(b2b_traffic_test)

  b2b_traffic_seq seq;

  function new(string name = "b2b_traffic_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = b2b_traffic_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);

    #40;
    phase.drop_objection(this);
  endtask
endclass
