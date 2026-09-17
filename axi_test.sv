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

class base_test extends test;
  `uvm_component_utils(base_test)
  base_read br;
  base_write bw;

  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bw = base_write::type_id::create("s");
    bw.start(env.inp_agnt.wrsqr);
    br = base_read::type_id::create("r");
    br.start(env.inp_agnt.rdsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class only_base_write_test extends test;
  `uvm_component_utils(only_base_write_test)
  base_write bw;

  function new(string name = "only_base_write_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bw = base_write::type_id::create("bw");
    bw.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class only_base_read_test extends test;
  `uvm_component_utils(only_base_read_test)
  base_read br;

  function new(string name = "only_base_read_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    br = base_read::type_id::create("br");
    br.start(env.inp_agnt.rdsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class rewr_test extends test;
  `uvm_component_utils(rewr_test)
  read_test br;
  write_test bw;

  function new(string name = "rewr_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    fork
      begin
        bw = write_test::type_id::create("s");
        bw.start(env.inp_agnt.wrsqr);
      end
      begin
        br = read_test::type_id::create("r");
        br.start(env.inp_agnt.rdsqr);
      end
    join
    #40;
    phase.drop_objection(this);
  endtask
endclass

class rewr_valid_test extends test;
  `uvm_component_utils(rewr_valid_test)
  read_valid_test br;
  write_valid_test bw;

  function new(string name = "rewr_valid_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    fork
      begin
        bw = write_valid_test::type_id::create("s");
        bw.start(env.inp_agnt.wrsqr);
      end
      begin
        br = read_valid_test::type_id::create("r");
        br.start(env.inp_agnt.rdsqr);
      end
    join
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_write_valid_test extends test;
  `uvm_component_utils(test_write_valid_test)
  write_valid_test bw;

  function new(string name = "test_write_valid_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bw = write_valid_test::type_id::create("bw");
    bw.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_read_valid_test extends test;
  `uvm_component_utils(test_read_valid_test)
  read_valid_test br;

  function new(string name = "test_read_valid_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    br = read_valid_test::type_id::create("br");
    br.start(env.inp_agnt.rdsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass


// ==========================================
// 2. Permission Error Tests (SLVERR)
// ==========================================
class test_axi_write_ro extends test;
  `uvm_component_utils(test_axi_write_ro)
  axi_write_ro_sequence bw;

  function new(string name = "test_axi_write_ro", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bw = axi_write_ro_sequence::type_id::create("bw");
    bw.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_read_wo extends test;
  `uvm_component_utils(test_axi_read_wo)
  axi_read_wo_sequence br;

  function new(string name = "test_axi_read_wo", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    br = axi_read_wo_sequence::type_id::create("br");
    br.start(env.inp_agnt.rdsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass


// ==========================================
// 3. Unaligned Access Tests (SLVERR)
// ==========================================
class test_axi_unaligned_write extends test;
  `uvm_component_utils(test_axi_unaligned_write)
  unaligned_write_seq bw;

  function new(string name = "test_axi_unaligned_write", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bw = unaligned_write_seq::type_id::create("bw");
    bw.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_unaligned_read extends test;
  `uvm_component_utils(test_axi_unaligned_read)
  axi_unaligned_read_seq br;

  function new(string name = "test_axi_unaligned_read", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    br = axi_unaligned_read_seq::type_id::create("br");
    br.start(env.inp_agnt.rdsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass


// ==========================================
// 4. Decode Error Tests (DECERR)
// ==========================================
class test_axi_decerr_write extends test;
  `uvm_component_utils(test_axi_decerr_write)
  axi_decerr_write_seq bw;

  function new(string name = "test_axi_decerr_write", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bw = axi_decerr_write_seq::type_id::create("bw");
    bw.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_decerr_read extends test;
  `uvm_component_utils(test_axi_decerr_read)
  axi_decerr_read_seq br;

  function new(string name = "test_axi_decerr_read", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    br = axi_decerr_read_seq::type_id::create("br");
    br.start(env.inp_agnt.rdsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass


// ==========================================
// 5. Strobe & Concurrency Tests
// ==========================================
class test_axi_wstrb extends test;
  `uvm_component_utils(test_axi_wstrb)
  axi_wstrb_test_seq bw;

  function new(string name = "test_axi_wstrb", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bw = axi_wstrb_test_seq::type_id::create("bw");
    bw.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_all_wstrb extends test;
  `uvm_component_utils(test_axi_all_wstrb)
  axi_all_wstrb_seq bw;

  function new(string name = "test_axi_all_wstrb", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bw = axi_all_wstrb_seq::type_id::create("bw");
    bw.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_concurrent_rw extends test;
  `uvm_component_utils(test_axi_concurrent_rw)
  axi_concurrent_rw_seq seq;

  function new(string name = "test_axi_concurrent_rw", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_concurrent_rw_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass


// ==========================================
// 6. Decoupled FSM Handshake & Sweep Tests
// ==========================================
class test_axi_addr_before_data extends test;
  `uvm_component_utils(test_axi_addr_before_data)
  axi_addr_before_data_seq bw;

  function new(string name = "test_axi_addr_before_data", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bw = axi_addr_before_data_seq::type_id::create("bw");
    bw.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_data_before_addr extends test;
  `uvm_component_utils(test_axi_data_before_addr)
  axi_data_before_addr_seq bw;

  function new(string name = "test_axi_data_before_addr", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bw = axi_data_before_addr_seq::type_id::create("bw");
    bw.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass

class test_axi_full_memory_sweep extends test;
  `uvm_component_utils(test_axi_full_memory_sweep)
  axi_full_memory_sweep_seq seq;

  function new(string name = "test_axi_full_memory_sweep", uvm_component parent);
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

class test_axi_ready_delay extends test;
  `uvm_component_utils(test_axi_ready_delay)
  axi_ready_delay_seq seq;

  function new(string name = "test_axi_ready_delay", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = axi_ready_delay_seq::type_id::create("seq");
    seq.start(env.inp_agnt.wrsqr);
    #40;
    phase.drop_objection(this);
  endtask
endclass


// ==========================================
// 7. Master Virtual Regression Test (Hits 100% Cumulative Coverage)
// ==========================================
class test_axi_master_100pct_coverage extends test;
  `uvm_component_utils(test_axi_master_100pct_coverage)

  write_valid_test         seq_w_valid;
  read_valid_test          seq_r_valid;
  axi_write_ro_sequence    seq_w_ro;
  axi_read_wo_sequence     seq_r_wo;
  unaligned_write_seq      seq_unalign_w;
  axi_unaligned_read_seq   seq_unalign_r;
  axi_decerr_write_seq     seq_decerr_w;
  axi_decerr_read_seq      seq_decerr_r;
  axi_all_wstrb_seq        seq_all_wstrb;
  axi_addr_before_data_seq seq_addr_first;
  axi_data_before_addr_seq seq_data_first;
  axi_full_memory_sweep_seq seq_mem_sweep;

  function new(string name = "test_axi_master_100pct_coverage", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    // 1. Parallel Sweep of valid regions
    seq_w_valid = write_valid_test::type_id::create("seq_w_valid");
    seq_r_valid = read_valid_test::type_id::create("seq_r_valid");
    fork
      seq_w_valid.start(env.inp_agnt.wrsqr);
      seq_r_valid.start(env.inp_agnt.rdsqr);
    join

    // 2. Full memory sweep covering boundary addresses and reserved locations
    seq_mem_sweep = axi_full_memory_sweep_seq::type_id::create("seq_mem_sweep");
    seq_mem_sweep.start(env.inp_agnt.wrsqr);

    // 3. Permission errors (SLVERR)
    seq_w_ro = axi_write_ro_sequence::type_id::create("seq_w_ro");
    seq_r_wo = axi_read_wo_sequence::type_id::create("seq_r_wo");
    fork
      seq_w_ro.start(env.inp_agnt.wrsqr);
      seq_r_wo.start(env.inp_agnt.rdsqr);
    join

    // 4. Unaligned error accesses (SLVERR)
    seq_unalign_w = unaligned_write_seq::type_id::create("seq_unalign_w");
    seq_unalign_r = axi_unaligned_read_seq::type_id::create("seq_unalign_r");
    fork
      seq_unalign_w.start(env.inp_agnt.wrsqr);
      seq_unalign_r.start(env.inp_agnt.rdsqr);
    join

    // 5. Out-of-range address accesses (DECERR)
    seq_decerr_w = axi_decerr_write_seq::type_id::create("seq_decerr_w");
    seq_decerr_r = axi_decerr_read_seq::type_id::create("seq_decerr_r");
    fork
      seq_decerr_w.start(env.inp_agnt.wrsqr);
      seq_decerr_r.start(env.inp_agnt.rdsqr);
    join

    // 6. Strobes & Decoupled Handshakes
    seq_all_wstrb   = axi_all_wstrb_seq::type_id::create("seq_all_wstrb");
    seq_addr_first  = axi_addr_before_data_seq::type_id::create("seq_addr_first");
    seq_data_first  = axi_data_before_addr_seq::type_id::create("seq_data_first");

    seq_all_wstrb.start(env.inp_agnt.wrsqr);
    seq_addr_first.start(env.inp_agnt.wrsqr);
    seq_data_first.start(env.inp_agnt.wrsqr);

    #100;
    phase.drop_objection(this);
  endtask
endclass
