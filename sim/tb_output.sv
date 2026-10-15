// RAINCloud Digital | RAINCloud_SAP
// Original SAP design and codebase: J. Campbell.
//
`timescale 1ns/1ps
module tb_output;
  reg clk=0,reset=0,enable=1,signed_mode=0,hex_mode=0;
  reg [7:0] bus=0;
  wire [16:0] display;
  integer x,s,h,magnitude,expected_digits;
  reg negative;
  Output_Register dut(.CLK(clk),.CLR(reset),.OUTPUT_READ_EN(enable),
    .TWOS_COMPLIMENT_FLAG(signed_mode),.HEXADECIMAL_FLAG(hex_mode),
    .OUtPUT_DB_IN(bus),.OUTPUT_DISP(display));
  initial begin
    #1; reset=1; #1; reset=0;
    for(x=0;x<256;x=x+1) begin
      bus=x; #1; clk=1; #1; clk=0;
      for(s=0;s<2;s=s+1) for(h=0;h<2;h=h+1) begin
        signed_mode=s; hex_mode=h; #1;
        negative=s && (x>=128); magnitude=negative ? 256-x : x;
        expected_digits=h ? magnitude : ((magnitude/100)*256+((magnitude/10)%10)*16+magnitude%10);
        if(display[16:12] !== (negative ? 5'h16 : 5'h15) || display[11:0]!==expected_digits[11:0])
          $fatal(1,"Output formatting x=%d signed=%d hex=%d display=%h",x,s,h,display);
      end
    end
    reset=1; #1;
    if(display[11:0]!==0) $fatal(1,"Output reset failed without clock");
    $display("PASS tb_output: 1024 formats, mode changes without CPU clocks, reset");
    $finish;
  end
endmodule
