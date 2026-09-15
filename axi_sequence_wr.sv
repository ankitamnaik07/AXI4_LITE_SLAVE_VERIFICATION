class seq_single_wr extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(seq_single_wr)
  function new(string name = "seq_single_wr"); 
    super.new(name); 
  endfunction
  
  task body();
    req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with { AWVALID == 1; WVALID == 1; ARVALID == 0; WSTRB == 4'b1111; AWADDR == 'h0; });
    finish_item(req);
  endtask
endclass
