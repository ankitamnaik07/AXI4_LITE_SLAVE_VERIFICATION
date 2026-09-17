// =============================================================================
// Base / Raw Sequence
// =============================================================================
class axi_sequence extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(axi_sequence)

  function new(string name = "axi_sequence");
    super.new(name);
  endfunction

  task body();
    repeat(`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { BREADY == 1; RREADY == 1; });
      finish_item(req);
    end
  endtask
endclass


// =============================================================================
// Basic Sequences
// =============================================================================
class base_write extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(base_write)

  function new(string name = "base_write");
    super.new(name);
  endfunction

  task body();
    repeat(`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWADDR  == 16;
        AWVALID == 1;
        WDATA   == 100;
        WSTRB   == 4'b1111;
        WVALID  == 1;
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);
    end
  endtask
endclass

class base_read extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(base_read)

  function new(string name = "base_read");
    super.new(name);
  endfunction

  task body();
    repeat(`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 0;
        WVALID  == 0;
        ARVALID == 1;
        ARADDR  == 16;
        RREADY  == 1;
      });
      finish_item(req);
    end
  endtask
endclass

class write_test extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(write_test)

  function new(string name = "write_test");
    super.new(name);
  endfunction

task body();
    repeat(`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWADDR % 4 == 0;
        AWADDR inside {[0:36]};
        AWVALID == 1;
        WSTRB   == 4'b1111;
        WVALID  == 1;
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);
    end
  endtask
endclass

class read_test extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(read_test)

  function new(string name = "read_test");
    super.new(name);
  endfunction

  task body();
    repeat(`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 0;
        WVALID  == 0;
        ARVALID == 1;
        ARADDR[1:0] == 2'b00;
        ARADDR inside {[0:36]};
        RREADY  == 1;
      });
      finish_item(req);
    end
  endtask
endclass

class read_valid_test extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(read_valid_test)

  function new(string name = "read_valid_test");
    super.new(name);
  endfunction

  bit [31:0] arr[] = '{0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 60};

  task body();
    foreach (arr[i]) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 0;
        WVALID  == 0;
        ARVALID == 1;
        ARADDR  == arr[i];
        ARPROT  == i % 8;
        RREADY  == 1;
      });
      finish_item(req);
    end
  endtask
endclass

class write_valid_test extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(write_valid_test)

  function new(string name = "write_valid_test");
    super.new(name);
  endfunction

  bit [31:0] arr[] = '{0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 60};

  task body();
    foreach (arr[i]) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWADDR  == arr[i];
        AWPROT  == i % 8;
        AWVALID == 1;
        WSTRB   == 4'b1111;
        WVALID  == 1;
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);
    end
  endtask
endclass


// =============================================================================
// Status RO & Command WO Sequences
// =============================================================================
class axi_write_ro_sequence extends axi_sequence;
  `uvm_object_utils(axi_write_ro_sequence)

  function new(string name = "axi_write_ro_sequence");
    super.new(name);
  endfunction

  task body();
    write_ro_seq_new();
  endtask

  task write_ro_seq_new();
    repeat(`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR  inside {32'h28, 32'h2C, 32'h30};
        AWPROT  inside {[0:7]};
        WVALID  == 1;
        WSTRB   == 4'b1111;
        WDATA   inside {[100:200]};
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);
    end
  endtask
endclass

class axi_read_wo_sequence extends axi_sequence;
  `uvm_object_utils(axi_read_wo_sequence)

  function new(string name = "axi_read_wo_sequence");
    super.new(name);
  endfunction

  task body();
    read_wo_seq_new();
  endtask

  task read_wo_seq_new();
    repeat(`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 0;
        WVALID  == 0;
        BREADY  == 0;
        ARVALID == 1;
        ARADDR  inside {32'h34, 32'h38};
        ARPROT  inside {[0:7]};
        RREADY  == 1;
      });
      finish_item(req);
    end
  endtask
endclass


// =============================================================================
// Unaligned Access Sequences (Hits unaligned bins -> SLVERR)
// =============================================================================
class unaligned_write_seq extends axi_sequence;
  `uvm_object_utils(unaligned_write_seq)

  function new(string name = "unaligned_write_seq");
    super.new(name);
  endfunction

  task body();
    bit [31:0] unalign_addrs[] = '{32'h01, 32'h02, 32'h03, 32'h05, 32'h06, 32'h07};
    foreach (unalign_addrs[i]) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR  == unalign_addrs[i];
        AWPROT  == i % 8;
        WVALID  == 1;
        WSTRB   == 4'b1111;
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);
    end
  endtask
endclass

class axi_unaligned_read_seq extends axi_sequence;
  `uvm_object_utils(axi_unaligned_read_seq)

  function new(string name = "axi_unaligned_read_seq");
    super.new(name);
  endfunction

  task body();
    bit [31:0] unalign_addrs[] = '{32'h01, 32'h02, 32'h03, 32'h05, 32'h06, 32'h07};
    foreach (unalign_addrs[i]) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        ARVALID == 1;
        ARADDR  == unalign_addrs[i];
        ARPROT  == i % 8;
        RREADY  == 1;
        AWVALID == 0;
        WVALID  == 0;
        BREADY  == 0;
      });
      finish_item(req);
    end
  endtask
endclass


// =============================================================================
// Out-of-Range Sequences (Hits first_outrange & far_outrange -> DECERR)
// =============================================================================
class axi_decerr_write_seq extends axi_sequence;
  `uvm_object_utils(axi_decerr_write_seq)

  function new(string name = "axi_decerr_write_seq");
    super.new(name);
  endfunction

  task body();
    bit [31:0] out_addrs[] = '{32'h0000_0040, 32'h0000_0044, 32'h0000_0080, 32'h0000_0100};
    foreach (out_addrs[i]) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR  == out_addrs[i];
        AWPROT  == i % 8;
        WVALID  == 1;
        WSTRB   == 4'b1111;
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);
    end
  endtask
endclass

class axi_decerr_read_seq extends axi_sequence;
  `uvm_object_utils(axi_decerr_read_seq)

  function new(string name = "axi_decerr_read_seq");
    super.new(name);
  endfunction

  task body();
    bit [31:0] out_addrs[] = '{32'h0000_0040, 32'h0000_0044, 32'h0000_0080, 32'h0000_0100};
    foreach (out_addrs[i]) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        ARVALID == 1;
        ARADDR  == out_addrs[i];
        ARPROT  == i % 8;
        RREADY  == 1;
        AWVALID == 0;
        WVALID  == 0;
        BREADY  == 0;
      });
      finish_item(req);
    end
  endtask
endclass


// =============================================================================
// Byte Enable Patterns (Hits all_bytes, no_bytes, single_byte, partial)
// =============================================================================
class axi_all_wstrb_seq extends axi_sequence;
  `uvm_object_utils(axi_all_wstrb_seq)

  function new(string name = "axi_all_wstrb_seq");
    super.new(name);
  endfunction

  task body();
    for (int strb = 0; strb < 16; strb++) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR  inside {32'h04, 32'h08, 32'h0C, 32'h10};
        AWPROT  == strb % 8;
        WVALID  == 1;
        WDATA   == (strb == 0) ? 32'h0000_0000 : ((strb == 15) ? 32'hFFFF_FFFF : 32'h1234_5678);
        WSTRB   == strb[3:0];
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);
    end
  endtask
endclass

class axi_wstrb_test_seq extends axi_sequence;
  `uvm_object_utils(axi_wstrb_test_seq)

  function new(string name = "axi_wstrb_test_seq");
    super.new(name);
  endfunction

  bit [3:0] strobes[] = '{4'b1111, 4'b0000, 4'b0001, 4'b0010, 4'b0100, 4'b1000, 4'b0011, 4'b1100};

  task body();
    foreach (strobes[i]) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR  inside {32'h04, 32'h08, 32'h0C, 32'h10};
        AWPROT  == i % 8;
        WVALID  == 1;
        WSTRB   == strobes[i];
        WDATA   == (i % 2 == 0) ? 32'h0000_0000 : 32'hFFFF_FFFF;
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);
    end
  endtask
endclass


// =============================================================================
// Decoupled FSM Handshake Sequences
// =============================================================================
class axi_addr_before_data_seq extends axi_sequence;
  `uvm_object_utils(axi_addr_before_data_seq)

  function new(string name = "axi_addr_before_data_seq");
    super.new(name);
  endfunction

  task body();
    repeat(`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR  inside {32'h04, 32'h08, 32'h0C, 32'h10};
        AWPROT  inside {[0:7]};
        WVALID  == 0;
        BREADY  == 0;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);

      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 0;
        WVALID  == 1;
        WDATA   == 32'hCAFE_BABE;
        WSTRB   == 4'b1111;
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);
    end
  endtask
endclass

class axi_data_before_addr_seq extends axi_sequence;
  `uvm_object_utils(axi_data_before_addr_seq)

  function new(string name = "axi_data_before_addr_seq");
    super.new(name);
  endfunction

  task body();
    repeat(`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 0;
        WVALID  == 1;
        WDATA   == 32'hDEAD_BEEF;
        WSTRB   == 4'b1111;
        BREADY  == 0;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);

      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR  inside {32'h04, 32'h08, 32'h0C, 32'h10};
        AWPROT  inside {[0:7]};
        WVALID  == 0;
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);
    end
  endtask
endclass


// =============================================================================
// Full Sweep & Delays
// =============================================================================
class axi_full_memory_sweep_seq extends axi_sequence;
  `uvm_object_utils(axi_full_memory_sweep_seq)

  function new(string name = "axi_full_memory_sweep_seq");
    super.new(name);
  endfunction

  task body();
    bit [31:0] rw_addrs[] = '{32'h00, 32'h04, 32'h08, 32'h0C,
                              32'h10, 32'h14, 32'h18, 32'h1C,
                              32'h20, 32'h24, 32'h3C}; // Hits last_inrange (32'h3C)
    bit [31:0] wo_addrs[] = '{32'h34, 32'h38};
    bit [31:0] ro_addrs[] = '{32'h28, 32'h2C, 32'h30};

    foreach (rw_addrs[i]) begin
      `uvm_do_with(req, {
        AWVALID == 1; AWADDR == rw_addrs[i]; AWPROT == i % 8;
        WVALID  == 1; WDATA  == ((i % 2 == 0) ? 32'h0000_0000 : 32'hFFFF_FFFF);
        WSTRB   == 4'b1111; BREADY  == 1; ARVALID == 0; RREADY == 0;
      })
      `uvm_do_with(req, {
        AWVALID == 0; WVALID == 0; BREADY == 0;
        ARVALID == 1; ARADDR == rw_addrs[i]; ARPROT == i % 8; RREADY == 1;
      })
    end

    foreach (wo_addrs[i]) begin
      `uvm_do_with(req, {
        AWVALID == 1; AWADDR == wo_addrs[i]; AWPROT == i % 8;
        WVALID  == 1; WDATA  == 32'h5555_AAAA; WSTRB == 4'b1111;
        BREADY  == 1; ARVALID == 0; RREADY == 0;
      })
    end

    foreach (ro_addrs[i]) begin
      `uvm_do_with(req, {
        AWVALID == 0; WVALID == 0; BREADY == 0;
        ARVALID == 1; ARADDR == ro_addrs[i]; ARPROT == i % 8; RREADY == 1;
      })
    end
  endtask
endclass

class axi_ready_delay_seq extends axi_sequence;
  `uvm_object_utils(axi_ready_delay_seq)

  function new(string name = "axi_ready_delay_seq");
    super.new(name);
  endfunction

  task body();
    repeat(`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR  == 32'h08;
        WVALID  == 1;
        WDATA   == 32'h1122_3344;
        WSTRB   == 4'b1111;
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);
    end
  endtask
endclass

class axi_concurrent_rw_seq extends axi_sequence;
  `uvm_object_utils(axi_concurrent_rw_seq)

  function new(string name = "axi_concurrent_rw_seq");
    super.new(name);
  endfunction

  task body();
    repeat(`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR  inside {[0:9]} * 4;
        AWPROT  inside {[0:7]};
        WVALID  == 1;
        WSTRB   == 4'b1111;
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);
    end
  endtask
endclass
