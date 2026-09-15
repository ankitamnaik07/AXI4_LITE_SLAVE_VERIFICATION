class axi_sequence extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(axi_sequence)

function new(string name = "axi_sequence");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize());
    finish_item(req); 
  end
endtask

endclass

class base_write extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(base_write)

function new(string name = "base_write");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWADDR == 16; AWVALID == 1; WDATA == 100; WSTRB == 4'b1111; WVALID == 1; BREADY == 1; ARVALID == 0; RREADY == 0; }  );
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
    assert(req.randomize() with {AWVALID == 0; WVALID == 0; ARVALID == 1; ARADDR == 16; RREADY == 1; }  );
    finish_item(req);
  end
endtask

endclass


class write_test extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(write_test)

function new(string name = "base_write");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWADDR % 4 == 0; AWADDR inside{[1:33]}; AWVALID == 1; WSTRB == 4'b1111; WVALID == 1; BREADY == 1; ARVALID == 0; RREADY == 0; }  );
    finish_item(req);
  end
endtask

endclass

class read_test extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(read_test)
function new(string name = "base_read");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWVALID == 0; WVALID == 0; ARVALID == 1; ARADDR[1:0] == 2'b00; ARADDR inside {[1:32]}; RREADY == 1; }  );
    finish_item(req);
  end
endtask

endclass


class read_valid_test extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(read_valid_test)
function new(string name = "base_read");
  super.new(name);
endfunction
bit [31:0] arr [] = {0,4,8,12,16,20,24,28,32,36,40}; 
task body();
  foreach(arr[i]) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWVALID == 0; WVALID == 0; ARVALID == 1; ARADDR == arr[i]; RREADY == 1; }  );
    finish_item(req);
  end
endtask

endclass

class write_valid_test extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(write_valid_test)

function new(string name = "base_write");
  super.new(name);
endfunction
bit [31:0] arr [] = {0,4,8,12,16,20,24,28,32,36,40}; 
task body();
  foreach(arr[i]) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWADDR == arr[i]; AWVALID == 1; WSTRB == 4'b1111; WVALID == 1; BREADY == 1; ARVALID == 0; RREADY == 0; }  );
    finish_item(req);
  end
endtask

endclass
