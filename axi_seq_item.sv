class axi_seq_item extends uvm_sequence_item;
rand bit [`ADDR_WIDTH-1:0]AWADDR;
rand bit AWVALID;
rand bit [2:0] AWPROT;
bit AWREADY;

rand bit [`DATA_WIDTH-1:0] WDATA;
rand bit [`STRB_WIDTH-1:0] WSTRB;
rand bit WVALID;
bit WREADY;

rand bit BREADY;
bit BVALID;
bit [1:0]BRESP;

rand bit [`ADDR_WIDTH-1:0] ARADDR;
rand bit [2:0] ARPROT;
rand bit ARVALID;
bit ARREADY;

rand bit RREADY;
bit [`DATA_WIDTH-1:0]RDATA;
bit [1:0]RRESP;
bit RVALID;

rand bit [1:0] wrsel;

/*rand int aw_delay;
rand int w_delay;
rand int b_delay;
rand int ar_delay;
rand int r_delay;*/

rand int wt_addr;
rand int wt_data;

`uvm_object_utils_begin(axi_seq_item)
`uvm_field_int(AWADDR, UVM_ALL_ON)
`uvm_field_int(AWVALID, UVM_ALL_ON)
`uvm_field_int(AWPROT, UVM_ALL_ON)
`uvm_field_int(AWREADY, UVM_ALL_ON)
`uvm_field_int(WDATA, UVM_ALL_ON)
`uvm_field_int(WSTRB, UVM_ALL_ON)
`uvm_field_int(WVALID, UVM_ALL_ON)
`uvm_field_int(WREADY, UVM_ALL_ON)
`uvm_field_int(BREADY, UVM_ALL_ON)
`uvm_field_int(BVALID, UVM_ALL_ON)
`uvm_field_int(BRESP, UVM_ALL_ON)
`uvm_field_int(ARADDR, UVM_ALL_ON)
`uvm_field_int(ARPROT, UVM_ALL_ON)
`uvm_field_int(ARVALID, UVM_ALL_ON)
`uvm_field_int(ARREADY, UVM_ALL_ON)
`uvm_field_int(RREADY, UVM_ALL_ON)
`uvm_field_int(RDATA, UVM_ALL_ON)
`uvm_field_int(RRESP, UVM_ALL_ON)
`uvm_field_int(RVALID, UVM_ALL_ON)
`uvm_object_utils_end

function new(string name = "axi_seq_item");
  super.new(name);
endfunction

/*constraint delays{ aw_delay inside{[1:20]};
	w_delay inside{[1:20]};
	b_delay inside{[1:20]};
	ar_delay inside{[1:20]};
	r_delay inside{[1:20]};
}*/

constraint c1{
	wt_addr == 0; wt_data == 1;
}
virtual function string convert2string();
    string s;
    
    // Concatenate all signals grouped by their AXI channels
    s = $sformatf("\n  [AW Channel] AWADDR: 'h%0h | AWPROT: 'h%0h | AWVALID: %0b | AWREADY: %0b", AWADDR, AWPROT, AWVALID, AWREADY);
    s = {s, $sformatf("\n  [ W Channel] WDATA: 'h%0h | WSTRB: %0b | WVALID: %0b | WREADY: %0b", WDATA, WSTRB, WVALID, WREADY)};
    s = {s, $sformatf("\n  [ B Channel] BRESP: 'b%0b | BVALID: %0b | BREADY: %0b", BRESP, BVALID, BREADY)};
    s = {s, $sformatf("\n  [AR Channel] ARADDR: 'h%0h | ARPROT: 'h%0h | ARVALID: %0b | ARREADY: %0b", ARADDR, ARPROT, ARVALID, ARREADY)};
    s = {s, $sformatf("\n  [ R Channel] RDATA: 'h%0h | RRESP: %0b | RVALID: %0b | RREADY: %0b", RDATA, RRESP, RVALID, RREADY)};
    //s = {s, $sformatf("\n  [   Delays ] aw:%0d w:%0d b:%0d ar:%0d r:%0d | wrsel: %0d", aw_delay, w_delay, b_delay, ar_delay, r_delay, wrsel)};
    
    return s;
  endfunction
endclass
