// Copyright (C) 2021 The SymbiFlow Authors.
//
// Use of this source code is governed by a ISC-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/ISC
//
// SPDX-License-Identifier: ISC


// Description: 
// 
// Here we are testing the block by applying some 
// user defined inputs to it 
// But the inputs should be in the range provided by 
// the register width.
// 

// This is a testbench to test the working of the BCD adder module


module adder_tb();
reg [16:0] a;
//reg [47:0] c;
wire [8:0] p;
reg clk;
initial clk = 0;
always #10 clk = ~clk;
adder add1(.sw(a),.clk(clk),.led(p));
initial begin
    a = 18'd1025;
    
    #100 a = 18'd0751;
        
    #100 a = 18'd1124;
               
end

endmodule
