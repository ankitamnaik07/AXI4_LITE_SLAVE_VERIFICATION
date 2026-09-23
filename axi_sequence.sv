
class basic_seq extends uvm_sequence#(axi_seq_item);;
  `uvm_object_utils(basic_seq)

  function new(string name = "basic_seq");
    super.new(name);
  endfunction

  task body();
    repeat (`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        (AWVALID == 1 && WVALID == 1 && ARVALID == 0 &&
         BREADY == 1 && RREADY == 0) ||
        (AWVALID == 0 && WVALID == 0 && ARVALID == 1 &&
         BREADY == 0 && RREADY == 1);
      });

      finish_item(req);
    end
  endtask
endclass


class write_seq extends basic_seq;
  `uvm_object_utils(write_seq)

  function new(string name = "write_seq");
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


class read_seq extends basic_seq;
  `uvm_object_utils(read_seq)

  function new(string name = "read_seq");
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


class write_range_seq extends basic_seq;
  `uvm_object_utils(write_range_seq)

  function new(string name = "write_range_seq");
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


class read_range_seq extends basic_seq;
  `uvm_object_utils(read_range_seq)

  function new(string name = "read_range_seq");
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


class read_addr_seq extends basic_seq;
  `uvm_object_utils(read_addr_seq)

  function new(string name = "read_addr_seq");
    super.new(name);
  endfunction

  bit [31:0] arr[] =
    '{0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 60};

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


class write_addr_seq extends basic_seq;
  `uvm_object_utils(write_addr_seq)

  function new(string name = "write_addr_seq");
    super.new(name);
  endfunction

  bit [31:0] arr[] =
    '{0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 60};

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


class ro_write_seq extends basic_seq;
  `uvm_object_utils(ro_write_seq)

  function new(string name = "ro_write_seq");
    super.new(name);
  endfunction

  task body();
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


class wo_read_seq extends basic_seq;
  `uvm_object_utils(wo_read_seq)

  function new(string name = "wo_read_seq");
    super.new(name);
  endfunction

  task body();
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


class unaligned_wr_seq extends basic_seq;
  `uvm_object_utils(unaligned_wr_seq)

  function new(string name = "unaligned_wr_seq");
    super.new(name);
  endfunction

  task body();
    bit [31:0] unalign_addrs[] =
      '{32'h01, 32'h02, 32'h03, 32'h05, 32'h06, 32'h07};

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


class unaligned_rd_seq extends basic_seq;
  `uvm_object_utils(unaligned_rd_seq)

  function new(string name = "unaligned_rd_seq");
    super.new(name);
  endfunction

  task body();
    bit [31:0] unalign_addrs[] =
      '{32'h01, 32'h02, 32'h03, 32'h05, 32'h06, 32'h07};

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


class decerr_wr_seq extends basic_seq;
  `uvm_object_utils(decerr_wr_seq)

  function new(string name = "decerr_wr_seq");
    super.new(name);
  endfunction

  task body();
    bit [31:0] out_addrs[] =
      '{32'h0000_0040, 32'h0000_0044,
        32'h0000_0080, 32'h0000_0100};

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


class decerr_rd_seq extends basic_seq;
  `uvm_object_utils(decerr_rd_seq)

  function new(string name = "decerr_rd_seq");
    super.new(name);
  endfunction

  task body();
    bit [31:0] out_addrs[] =
      '{32'h0000_0040, 32'h0000_0044,
        32'h0000_0080, 32'h0000_0100};

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


class wstrb_sweep_seq extends basic_seq;
  `uvm_object_utils(wstrb_sweep_seq)

  function new(string name = "wstrb_sweep_seq");
    super.new(name);
  endfunction

  task body();
    for (int strb = 0; strb < 16; strb++) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR inside {32'h04, 32'h08, 32'h0C, 32'h10};
        AWPROT == strb % 8;
        WVALID == 1;
        WDATA == (strb == 0) ? 32'h0000_0000 :
                 ((strb == 15) ? 32'hFFFF_FFFF :
                                  32'h1234_5678);
        WSTRB == strb[3:0];
        BREADY == 1;
        ARVALID == 0;
        RREADY == 0;
      });

      finish_item(req);
    end
  endtask
endclass


class wstrb_pattern_seq extends basic_seq;
  `uvm_object_utils(wstrb_pattern_seq)

  function new(string name = "wstrb_pattern_seq");
    super.new(name);
  endfunction

  bit [3:0] strobes[] =
    '{4'b1111, 4'b0000, 4'b0001, 4'b0010,
      4'b0100, 4'b1000, 4'b0011, 4'b1100};

  task body();
    foreach (strobes[i]) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR inside {32'h04, 32'h08, 32'h0C, 32'h10};
        AWPROT == i % 8;
        WVALID == 1;
        WSTRB == strobes[i];
        WDATA == (i % 2 == 0) ?
                 32'h0000_0000 : 32'hFFFF_FFFF;
        BREADY == 1;
        ARVALID == 0;
        RREADY == 0;
      });

      finish_item(req);
    end
  endtask
endclass


class aw_first_seq extends basic_seq;
  `uvm_object_utils(aw_first_seq)

  function new(string name = "aw_first_seq");
    super.new(name);
  endfunction

  task body();
    repeat (`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR inside {32'h04, 32'h08, 32'h0C, 32'h10};
        AWPROT inside {[0:7]};
        WVALID == 0;
        BREADY == 0;
        ARVALID == 0;
        RREADY == 0;
      });

      finish_item(req);

      req = axi_seq_item::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        AWVALID == 0;
        WVALID == 1;
        WDATA == 32'hCAFE_BABE;
        WSTRB == 4'b1111;
        BREADY == 1;
        ARVALID == 0;
        RREADY == 0;
      });

      finish_item(req);
    end
  endtask
endclass

class w_first_seq extends basic_seq;
  `uvm_object_utils(w_first_seq)

  function new(string name = "w_first_seq");
    super.new(name);
  endfunction

  task body();
    repeat (`num_of_transaction) begin
      // Step 1: Send Data only (AWVALID = 0, WVALID = 1) -> Triggers W_BOTH -> W_DATA
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

      // Step 2: Send Address only (AWVALID = 1, WVALID = 0) -> Triggers W_DATA -> W_RESP
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

class memory_sweep_seq extends basic_seq;
  `uvm_object_utils(memory_sweep_seq)

  function new(string name = "memory_sweep_seq");
    super.new(name);
  endfunction

  task body();
    bit [31:0] rw_addrs[] = '{
      32'h00, 32'h04, 32'h08, 32'h0C,
      32'h10, 32'h14, 32'h18, 32'h1C,
      32'h20, 32'h24, 32'h3C
    };

    bit [31:0] wo_addrs[] = '{32'h34, 32'h38};
    bit [31:0] ro_addrs[] = '{32'h28, 32'h2C, 32'h30};

    foreach (rw_addrs[i]) begin
      `uvm_do_with(req, {
        AWVALID == 1;
        AWADDR == rw_addrs[i];
        AWPROT == i % 8;
        WVALID == 1;
        WDATA == ((i % 2 == 0) ?
                  32'h0000_0000 : 32'hFFFF_FFFF);
        WSTRB == 4'b1111;
        BREADY == 1;
        ARVALID == 0;
        RREADY == 0;
      })

      `uvm_do_with(req, {
        AWVALID == 0;
        WVALID == 0;
        BREADY == 0;
        ARVALID == 1;
        ARADDR == rw_addrs[i];
        ARPROT == i % 8;
        RREADY == 1;
      })
    end

    foreach (wo_addrs[i]) begin
      `uvm_do_with(req, {
        AWVALID == 1;
        AWADDR == wo_addrs[i];
        AWPROT == i % 8;
        WVALID == 1;
        WDATA == 32'h5555_AAAA;
        WSTRB == 4'b1111;
        BREADY == 1;
        ARVALID == 0;
        RREADY == 0;
      })
    end

    foreach (ro_addrs[i]) begin
      `uvm_do_with(req, {
        AWVALID == 0;
        WVALID == 0;
        BREADY == 0;
        ARVALID == 1;
        ARADDR == ro_addrs[i];
        ARPROT == i % 8;
        RREADY == 1;
      })
    end
  endtask
endclass


class fixed_write_seq extends basic_seq;
  `uvm_object_utils(fixed_write_seq)

  function new(string name = "fixed_write_seq");
    super.new(name);
  endfunction

  task body();
    repeat (`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR == 32'h08;
        WVALID == 1;
        WDATA == 32'h1122_3344;
        WSTRB == 4'b1111;
        BREADY == 1;
        ARVALID == 0;
        RREADY == 0;
      });

      finish_item(req);
    end
  endtask
endclass


class addr_sweep_seq extends basic_seq;
  `uvm_object_utils(addr_sweep_seq)

  function new(string name = "addr_sweep_seq");
    super.new(name);
  endfunction

  task body();
    repeat (`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR inside {[0:9]} * 4;
        AWPROT inside {[0:7]};
        WVALID == 1;
        WSTRB == 4'b1111;
        BREADY == 1;
        ARVALID == 0;
        RREADY == 0;
      });

      finish_item(req);
    end
  endtask
endclass


class minmax_addr_write extends basic_seq;
`uvm_object_utils(minmax_addr_write)

function new(string name = "minmax_addr_write");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWADDR inside {32'h0,32'hFFFF_FFFF}; AWVALID == 1; WDATA == 100; WSTRB == 4'b1111; WVALID == 1; BREADY == 1; ARVALID == 0; RREADY == 0; }  );
    finish_item(req);
  end
endtask
endclass


class minmax_addr_read extends basic_seq;
`uvm_object_utils(minmax_addr_read)

function new(string name = "minmax_addr_read");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWVALID == 0; WVALID == 0; ARVALID == 1; ARADDR inside{32'h0,32'hFFFF_FFFF}; RREADY == 1; }  );
    finish_item(req);
  end
endtask
endclass


class ro_readback_seq extends basic_seq;
  `uvm_object_utils(ro_readback_seq)

  function new(string name = "ro_readback_seq");
    super.new(name);
  endfunction

  bit [31:0] ro_addrs[] = '{32'h28, 32'h2C, 32'h30};

  task body();
    foreach (ro_addrs[i]) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 0;
        WVALID  == 0;
        BREADY  == 0;
        ARVALID == 1;
        ARADDR  == ro_addrs[i];
        ARPROT  == i % 8;
        RREADY  == 1;
      });
      finish_item(req);

      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR  == ro_addrs[i];
        AWPROT  == i % 8;
        WVALID  == 1;
        WDATA   == 32'hA5A5_5A5A;
        WSTRB   == 4'b1111;
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);

      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 0;
        WVALID  == 0;
        BREADY  == 0;
        ARVALID == 1;
        ARADDR  == ro_addrs[i];
        ARPROT  == i % 8;
        RREADY  == 1;
      });
      finish_item(req);
    end
  endtask
endclass


class wstrb_wr_single_seq extends basic_seq;
  `uvm_object_utils(wstrb_wr_single_seq)
	int i;
  
	bit [3:0]strb = '{4'b0010, 4'b1110, 4'b1010, 4'b1100};
  function new(string name = "wstrb_wr_single_seq");
    super.new(name);
  endfunction

  task body();
    // 1. Initialize to 0
    req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      AWVALID == 1;
      AWADDR  == 32'h10;
      AWPROT  == 0;
      WVALID  == 1;
      WDATA   == 32'h0000_0000;
      WSTRB   == 4'b1111;
      BREADY  == 1;
      ARVALID == 0;
      RREADY  == 0;
    });
    finish_item(req);

    // 2. Partial write
	  foreach (strb[i])
    req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      AWVALID == 1;
      AWADDR  == 32'h10;
      AWPROT  == 0;
      WVALID  == 1;
      WDATA   == 32'hAABB_CCDD;
      WSTRB   == strb[i];
      BREADY  == 1;
      ARVALID == 0;
      RREADY  == 0;
    });
    finish_item(req);
	  
  endtask
endclass


class wstrb_rd_single_seq extends basic_seq;
  `uvm_object_utils(wstrb_rd_single_seq)

  function new(string name = "wstrb_rd_single_seq");
    super.new(name);
  endfunction

  task body();
    // 3. Read back register 0x10
    req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      AWVALID == 0;
      WVALID  == 0;
      BREADY  == 0;
      ARVALID == 1;
      ARADDR  == 32'h10;
      ARPROT  == 0;
      RREADY  == 1;
    });
    finish_item(req);
  endtask
endclass

class unaligned_nocorrupt_seq extends basic_seq;
  `uvm_object_utils(unaligned_nocorrupt_seq)

  function new(string name = "unaligned_nocorrupt_seq");
    super.new(name);
  endfunction

  bit [31:0] unalign_addrs[] = '{32'h01, 32'h02, 32'h03, 32'h05, 32'h06, 32'h07};

  task body();
    req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      AWVALID == 1;
      AWADDR  == 32'h00;
      AWPROT  == 0;
      WVALID  == 1;
      WDATA   == 32'h1111_1111;
      WSTRB   == 4'b1111;
      BREADY  == 1;
      ARVALID == 0;
      RREADY  == 0;
    });
    finish_item(req);

    req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      AWVALID == 1;
      AWADDR  == 32'h04;
      AWPROT  == 0;
      WVALID  == 1;
      WDATA   == 32'h2222_2222;
      WSTRB   == 4'b1111;
      BREADY  == 1;
      ARVALID == 0;
      RREADY  == 0;
    });
    finish_item(req);

    foreach (unalign_addrs[i]) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR  == unalign_addrs[i];
        AWPROT  == i % 8;
        WVALID  == 1;
        WDATA   == 32'hFFFF_FFFF;
        WSTRB   == 4'b1111;
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);
    end

    req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      AWVALID == 0;
      WVALID  == 0;
      BREADY  == 0;
      ARVALID == 1;
      ARADDR  == 32'h00;
      ARPROT  == 0;
      RREADY  == 1;
    });
    finish_item(req);

    req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      AWVALID == 0;
      WVALID  == 0;
      BREADY  == 0;
      ARVALID == 1;
      ARADDR  == 32'h04;
      ARPROT  == 0;
      RREADY  == 1;
    });
    finish_item(req);
  endtask
endclass


class addr_boundary_seq extends basic_seq;
  `uvm_object_utils(addr_boundary_seq)

  function new(string name = "addr_boundary_seq");
    super.new(name);
  endfunction

  task body();
    req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      AWVALID == 1;
      AWADDR  == 32'h00;
      AWPROT  == 0;
      WVALID  == 1;
      WDATA   == 32'hCAFE_0001;
      WSTRB   == 4'b1111;
      BREADY  == 1;
      ARVALID == 0;
      RREADY  == 0;
    });
    finish_item(req);

    req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      AWVALID == 1;
      AWADDR  == 32'h3C;
      AWPROT  == 0;
      WVALID  == 1;
      WDATA   == 32'h5555_AAAA;
      WSTRB   == 4'b1111;
      BREADY  == 1;
      ARVALID == 0;
      RREADY  == 0;
    });
    finish_item(req);

    req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      AWVALID == 1;
      AWADDR  == 32'h40;
      AWPROT  == 0;
      WVALID  == 1;
      WDATA   == 32'hDEAD_0040;
      WSTRB   == 4'b1111;
      BREADY  == 1;
      ARVALID == 0;
      RREADY  == 0;
    });
    finish_item(req);

    req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      AWVALID == 0;
      WVALID  == 0;
      BREADY  == 0;
      ARVALID == 1;
      ARADDR  == 32'h00;
      ARPROT  == 0;
      RREADY  == 1;
    });
    finish_item(req);
  endtask
endclass

class wr_ready_delay_seq extends basic_seq;
  `uvm_object_utils(wr_ready_delay_seq)

  function new(string name = "wr_ready_delay_seq");
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
        WVALID  == 1;
        WDATA   == 32'hA5A5_5A5A;
        WSTRB   == 4'b1111;
        BREADY  == 0;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);

      #40;

      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 0;
        WVALID  == 0;
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);
    end
  endtask
endclass


class rd_ready_delay_seq extends basic_seq;
  `uvm_object_utils(rd_ready_delay_seq)

  function new(string name = "rd_ready_delay_seq");
    super.new(name);
  endfunction

  task body();
    repeat (`num_of_transaction) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 0;
        WVALID  == 0;
        BREADY  == 0;
        ARVALID == 1;
        ARADDR  inside {32'h04, 32'h08, 32'h0C, 32'h10};
        ARPROT  inside {[0:7]};
        RREADY  == 0;
      });
      finish_item(req);

      #40;

      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 0;
        WVALID  == 0;
        BREADY  == 0;
        ARVALID == 0;
        RREADY  == 1;
      });
      finish_item(req);
    end
  endtask
endclass
class b2b_traffic_seq extends basic_seq;
  `uvm_object_utils(b2b_traffic_seq)

  function new(string name = "b2b_traffic_seq");
    super.new(name);
  endfunction

  bit [31:0] rw_addrs[] = '{
    32'h00, 32'h04, 32'h08, 32'h0C,
    32'h10, 32'h14, 32'h18, 32'h1C,
    32'h20, 32'h24, 32'h3C
  };

  task body();
    repeat (50) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 1;
        AWADDR  inside {rw_addrs};
        AWPROT  inside {[0:7]};
        WVALID  == 1;
        WSTRB   == 4'b1111;
        BREADY  == 1;
        ARVALID == 0;
        RREADY  == 0;
      });
      finish_item(req);

      req = axi_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {
        AWVALID == 0;
        WVALID  == 0;
        BREADY  == 0;
        ARVALID == 1;
        ARADDR  inside {rw_addrs};
        ARPROT  inside {[0:7]};
        RREADY  == 1;
      });
      finish_item(req);
    end
  endtask
endclass
