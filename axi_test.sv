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


// ==========================================
// 1. Basic & Valid Access Tests
// ==========================================
class test_axi_sequence extends test;
  `uvm_component_utils(test_axi_sequence)
  axi_sequence seq;

  function new(string name = "test_axi_sequence", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_sequence::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_base_write_seq extends test;
  `uvm_component_utils(test_axi_base_write_seq)
  axi_base_write_seq seq;

  function new(string name = "test_axi_base_write_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_base_write_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_base_read_seq extends test;
  `uvm_component_utils(test_axi_base_read_seq)
  axi_base_read_seq seq;

  function new(string name = "test_axi_base_read_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_base_read_seq::type_id::create("seq");
    seq.start(env.inp_agnt.rdsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_base_rw_seq extends test;
  `uvm_component_utils(test_axi_base_rw_seq)
  axi_base_write_seq wr_seq;
  axi_base_read_seq  rd_seq;

  function new(string name = "test_axi_base_rw_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    wr_seq = axi_base_write_seq::type_id::create("wr_seq");
    wr_seq.start(env.inp_agnt.wrsqr);
    rd_seq = axi_base_read_seq::type_id::create("rd_seq");
    rd_seq.start(env.inp_agnt.rdsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_write_addr_range_seq extends test;
  `uvm_component_utils(test_axi_write_addr_range_seq)
  axi_write_addr_range_seq seq;

  function new(string name = "test_axi_write_addr_range_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_write_addr_range_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_read_addr_range_seq extends test;
  `uvm_component_utils(test_axi_read_addr_range_seq)
  axi_read_addr_range_seq seq;

  function new(string name = "test_axi_read_addr_range_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_read_addr_range_seq::type_id::create("seq");
    seq.start(env.inp_agnt.rdsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_addr_range_rw_seq extends test;
  `uvm_component_utils(test_axi_addr_range_rw_seq)
  axi_write_addr_range_seq wr_seq;
  axi_read_addr_range_seq  rd_seq;

  function new(string name = "test_axi_addr_range_rw_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    fork
      begin
        wr_seq = axi_write_addr_range_seq::type_id::create("wr_seq");
        wr_seq.start(env.inp_agnt.wrsqr);
      end
      begin
        rd_seq = axi_read_addr_range_seq::type_id::create("rd_seq");
        rd_seq.start(env.inp_agnt.rdsqr);
      end
    join
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_write_valid_addr_seq extends test;
  `uvm_component_utils(test_axi_write_valid_addr_seq)
  axi_write_valid_addr_seq seq;

  function new(string name = "test_axi_write_valid_addr_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_write_valid_addr_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_read_valid_addr_seq extends test;
  `uvm_component_utils(test_axi_read_valid_addr_seq)
  axi_read_valid_addr_seq seq;

  function new(string name = "test_axi_read_valid_addr_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_read_valid_addr_seq::type_id::create("seq");
    seq.start(env.inp_agnt.rdsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_valid_addr_rw_seq extends test;
  `uvm_component_utils(test_axi_valid_addr_rw_seq)
  axi_write_valid_addr_seq wr_seq;
  axi_read_valid_addr_seq  rd_seq;

  function new(string name = "test_axi_valid_addr_rw_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    fork
      begin
        wr_seq = axi_write_valid_addr_seq::type_id::create("wr_seq");
        wr_seq.start(env.inp_agnt.wrsqr);
      end
      begin
        rd_seq = axi_read_valid_addr_seq::type_id::create("rd_seq");
        rd_seq.start(env.inp_agnt.rdsqr);
      end
    join
    #40;
    phase.drop_objection(this);
  endtask
endclass


// ==========================================
// 2. Permission Error Tests (SLVERR)
// ==========================================
class test_axi_ro_write_reject_seq extends test;
  `uvm_component_utils(test_axi_ro_write_reject_seq)
  axi_ro_write_reject_seq seq;

  function new(string name = "test_axi_ro_write_reject_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_ro_write_reject_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_wo_read_reject_seq extends test;
  `uvm_component_utils(test_axi_wo_read_reject_seq)
  axi_wo_read_reject_seq seq;

  function new(string name = "test_axi_wo_read_reject_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_wo_read_reject_seq::type_id::create("seq");
    seq.start(env.inp_agnt.rdsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass


// ==========================================
// 3. Unaligned Access Tests (SLVERR)
// ==========================================
class test_axi_unaligned_write_seq extends test;
  `uvm_component_utils(test_axi_unaligned_write_seq)
  axi_unaligned_write_seq seq;

  function new(string name = "test_axi_unaligned_write_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_unaligned_write_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_unaligned_read_seq extends test;
  `uvm_component_utils(test_axi_unaligned_read_seq)
  axi_unaligned_read_seq seq;

  function new(string name = "test_axi_unaligned_read_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_unaligned_read_seq::type_id::create("seq");
    seq.start(env.inp_agnt.rdsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass


// ==========================================
// 4. Decode Error Tests (DECERR)
// ==========================================
class test_axi_decerr_write_seq extends test;
  `uvm_component_utils(test_axi_decerr_write_seq)
  axi_decerr_write_seq seq;

  function new(string name = "test_axi_decerr_write_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_decerr_write_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_decerr_read_seq extends test;
  `uvm_component_utils(test_axi_decerr_read_seq)
  axi_decerr_read_seq seq;

  function new(string name = "test_axi_decerr_read_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_decerr_read_seq::type_id::create("seq");
    seq.start(env.inp_agnt.rdsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass


// ==========================================
// 5. Strobe Sweep & Pattern Tests
// ==========================================
class test_axi_wstrb_sweep_seq extends test;
  `uvm_component_utils(test_axi_wstrb_sweep_seq)
  axi_wstrb_sweep_seq seq;

  function new(string name = "test_axi_wstrb_sweep_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_wstrb_sweep_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_wstrb_pattern_seq extends test;
  `uvm_component_utils(test_axi_wstrb_pattern_seq)
  axi_wstrb_pattern_seq seq;

  function new(string name = "test_axi_wstrb_pattern_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_wstrb_pattern_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass


// ==========================================
// 6. Decoupled FSM Handshake & Sweep Tests
// ==========================================
class test_axi_addr_before_data_seq extends test;
  `uvm_component_utils(test_axi_addr_before_data_seq)
  axi_addr_before_data_seq seq;

  function new(string name = "test_axi_addr_before_data_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_addr_before_data_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_data_before_addr_seq extends test;
  `uvm_component_utils(test_axi_data_before_addr_seq)
  axi_data_before_addr_seq seq;

  function new(string name = "test_axi_data_before_addr_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_data_before_addr_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_full_memory_sweep_seq extends test;
  `uvm_component_utils(test_axi_full_memory_sweep_seq)
  axi_full_memory_sweep_seq seq;

  function new(string name = "test_axi_full_memory_sweep_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_full_memory_sweep_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_fixed_addr_write_seq extends test;
  `uvm_component_utils(test_axi_fixed_addr_write_seq)
  axi_fixed_addr_write_seq seq;

  function new(string name = "test_axi_fixed_addr_write_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_fixed_addr_write_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_write_addr_sweep_seq extends test;
  `uvm_component_utils(test_axi_write_addr_sweep_seq)
  axi_write_addr_sweep_seq seq;

  function new(string name = "test_axi_write_addr_sweep_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_write_addr_sweep_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass


// ==========================================
// 7. Toggle & Master 100% Coverage Tests
// ==========================================
class test_axi_toggle_coverage_seq extends test;
  `uvm_component_utils(test_axi_toggle_coverage_seq)
  axi_toggle_coverage_seq seq;

  function new(string name = "test_axi_toggle_coverage_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_toggle_coverage_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #100;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_master_100pct_coverage_seq extends test;
  `uvm_component_utils(test_axi_master_100pct_coverage_seq)
  axi_master_100pct_coverage_seq seq;

  function new(string name = "test_axi_master_100pct_coverage_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_master_100pct_coverage_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #100;
    phase.drop_objection(this);
  endtask
endclass
