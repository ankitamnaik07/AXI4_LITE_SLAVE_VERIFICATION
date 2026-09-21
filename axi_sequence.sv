class axi_sequence extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(axi_sequence)

  function new(string name = "axi_sequence");
    super.new(name);
  endfunction

  task body();
    repeat (`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { BREADY == 1; RREADY == 1; });
      finish_item(req);
    end
  endtask
endclass


class axi_base_write_seq extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(axi_base_write_seq)

  function new(string name = "axi_base_write_seq");
    super.new(name);
  endfunction

  task body();
    repeat (`num_of_transaction) begin
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


class axi_base_read_seq extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(axi_base_read_seq)

  function new(string name = "axi_base_read_seq");
    super.new(name);
  endfunction

  task body();
    repeat (`num_of_transaction) begin
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


class axi_write_addr_range_seq extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(axi_write_addr_range_seq)

  function new(string name = "axi_write_addr_range_seq");
    super.new(name);
  endfunction

  task body();
    repeat (`num_of_transaction) begin
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


class axi_read_addr_range_seq extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(axi_read_addr_range_seq)

  function new(string name = "axi_read_addr_range_seq");
    super.new(name);
  endfunction

  task body();
    repeat (`num_of_transaction) begin
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


class axi_read_valid_addr_seq extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(axi_read_valid_addr_seq)

  function new(string name = "axi_read_valid_addr_seq");
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


class axi_write_valid_addr_seq extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(axi_write_valid_addr_seq)

  function new(string name = "axi_write_valid_addr_seq");
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


class axi_ro_write_reject_seq extends axi_sequence;
  `uvm_object_utils(axi_ro_write_reject_seq)

  function new(string name = "axi_ro_write_reject_seq");
    super.new(name);
  endfunction

  task body();
    write_ro_seq_new();
  endtask

  task write_ro_seq_new();
    repeat (`num_of_transaction) begin
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


class axi_wo_read_reject_seq extends axi_sequence;
  `uvm_object_utils(axi_wo_read_reject_seq)

  function new(string name = "axi_wo_read_reject_seq");
    super.new(name);
  endfunction

  task body();
    read_wo_seq_new();
  endtask

  task read_wo_seq_new();
    repeat (`num_of_transaction) begin
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


class axi_unaligned_write_seq extends axi_sequence;
  `uvm_object_utils(axi_unaligned_write_seq)

  function new(string name = "axi_unaligned_write_seq");
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


class axi_wstrb_sweep_seq extends axi_sequence;
  `uvm_object_utils(axi_wstrb_sweep_seq)

  function new(string name = "axi_wstrb_sweep_seq");
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


class axi_wstrb_pattern_seq extends axi_sequence;
  `uvm_object_utils(axi_wstrb_pattern_seq)

  function new(string name = "axi_wstrb_pattern_seq");
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


class axi_addr_before_data_seq extends axi_sequence;
  `uvm_object_utils(axi_addr_before_data_seq)

  function new(string name = "axi_addr_before_data_seq");
    super.new(name);
  endfunction

  task body();
    repeat (`num_of_transaction) begin
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
    repeat (`num_of_transaction) begin
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


class axi_full_memory_sweep_seq extends axi_sequence;
  `uvm_object_utils(axi_full_memory_sweep_seq)

  function new(string name = "axi_full_memory_sweep_seq");
    super.new(name);
  endfunction

  task body();
    bit [31:0] rw_addrs[] = '{32'h00, 32'h04, 32'h08, 32'h0C,
                              32'h10, 32'h14, 32'h18, 32'h1C,
                              32'h20, 32'h24, 32'h3C};
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


class axi_fixed_addr_write_seq extends axi_sequence;
  `uvm_object_utils(axi_fixed_addr_write_seq)

  function new(string name = "axi_fixed_addr_write_seq");
    super.new(name);
  endfunction

  task body();
    repeat (`num_of_transaction) begin
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


class axi_write_addr_sweep_seq extends axi_sequence;
  `uvm_object_utils(axi_write_addr_sweep_seq)

  function new(string name = "axi_write_addr_sweep_seq");
    super.new(name);
  endfunction

  task body();
    repeat (`num_of_transaction) begin
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


class axi_toggle_coverage_seq extends axi_sequence;
  `uvm_object_utils(axi_toggle_coverage_seq)

  function new(string name = "axi_toggle_coverage_seq");
    super.new(name);
  endfunction

  bit [31:0] wide_addrs[] = '{32'hFFFF_FF40, 32'hAAAA_AA40, 32'h5555_5540, 32'h0000_0004};
  bit [31:0] toggle_data[] = '{32'hFFFF_FFFF, 32'h0000_0000, 32'hAAAA_AAAA, 32'h5555_5555};

  task body();
    foreach (wide_addrs[i]) begin
      `uvm_do_with(req, {
        AWVALID == 1; AWADDR == wide_addrs[i]; AWPROT == 3'b111;
        WVALID  == 1; WDATA  == toggle_data[i]; WSTRB == 4'b1111;
        BREADY  == 1; ARVALID == 0; RREADY == 0;
      })
    end

    foreach (toggle_data[i]) begin
      `uvm_do_with(req, {
        AWVALID == 1; AWADDR == 32'h04; WVALID == 1;
        WDATA   == toggle_data[i]; WSTRB == 4'b1111; BREADY == 1;
        ARVALID == 0; RREADY == 0;
      })
      `uvm_do_with(req, {
        AWVALID == 0; WVALID == 0; BREADY == 0;
        ARVALID == 1; ARADDR == 32'h04; RREADY == 1;
      })
    end

    foreach (wide_addrs[i]) begin
      `uvm_do_with(req, {
        AWVALID == 0; WVALID == 0; BREADY == 0;
        ARVALID == 1; ARADDR == wide_addrs[i]; ARPROT == 3'b111; RREADY == 1;
      })
    end
    `uvm_do_with(req, {
      AWVALID == 0; WVALID == 0; BREADY == 0;
      ARVALID == 1; ARADDR == 32'h04; ARPROT == 3'b000; RREADY == 1;
    })
  endtask
endclass


class axi_master_100pct_coverage_seq extends axi_sequence;
  `uvm_object_utils(axi_master_100pct_coverage_seq)

  function new(string name = "axi_master_100pct_coverage_seq");
    super.new(name);
  endfunction

  localparam bit [31:0] LAST_VALID  = (`MEM_DEPTH * 4) - 4;
  localparam bit [31:0] FIRST_INVAL = (`MEM_DEPTH * 4);

  bit [31:0] all_addrs[] = '{
    32'h00, 32'h04, 32'h08, 32'h0C,
    32'h10, 32'h14, 32'h20, 32'h24,
    32'h28, 32'h2C, 32'h30,
    32'h34, 32'h38,
    LAST_VALID,
    FIRST_INVAL,
    32'h0000_0044, 32'h0000_0080, 32'h0000_0100,
    32'h01, 32'h02, 32'h03, 32'h05, 32'h06, 32'h07
  };

  bit [3:0] all_strobes[] = '{
    4'b1111,
    4'b0000,
    4'b0001, 4'b0010, 4'b0100, 4'b1000,
    4'b0011, 4'b1100, 4'b0110
  };

  bit [31:0] all_data[] = '{
    32'h0000_0000,
    32'hFFFF_FFFF,
    32'hCAFE_BABE
  };

  task body();
    foreach (all_addrs[a]) begin
      foreach (all_strobes[s]) begin
        req = axi_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {
          AWVALID == 1;
          AWADDR  == all_addrs[a];
          AWPROT  == (a + s) % 8;
          WVALID  == 1;
          WSTRB   == all_strobes[s];
          WDATA   == all_data[(a + s) % 3];
          BREADY  == 1;
          ARVALID == 0;
          RREADY  == 0;
        });
        finish_item(req);
      end
    end

    foreach (all_addrs[a]) begin
      for (int p = 0; p < 8; p++) begin
        req = axi_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {
          AWVALID == 0;
          WVALID  == 0;
          BREADY  == 0;
          ARVALID == 1;
          ARADDR  == all_addrs[a];
          ARPROT  == p;
          RREADY  == 1;
        });
        finish_item(req);
      end
    end
  endtask
endclass

