// Copyright (C) 2024, Andes Technology Corp. Confidential Proprietary

`timescale 1ns/1ns

module platform_dump;
supply0 dummy_wire;
`ifdef DUMP
always @(system.ae350_chip.X_gpio[15:0]) begin
    $display("[%0t] www_debug:X_gpio changed => hex=%h, bin=%b",
             $time,
             system.ae350_chip.X_gpio[15:0],
             system.ae350_chip.X_gpio[15:0]);
end
initial begin
	`ifdef TRN
		$recordfile("verilog.trn");
	`else
	`ifdef FSDB
		//$fsdbDumpfile("verilog.fsdb");
		$fsdbAutoSwitchDumpfile(100, "verilog.fsdb", 10);
	`else
	`ifdef VPD
		$vcdplusfile("verilog.vpd");
		$vcdplusautoflushon;
	`else
		$dumpfile("verilog.vcd");
	`endif
	`endif
	`endif

#0;

	`ifdef TRN
		$recordvars;
	`else
	`ifdef FSDB		
		//`ifdef DUMP_SPI_ONLY			
		//	$fsdbDumpvars(0,system.ae350_chip.ae350_apb_subsystem.u_spi1);
		//	$fsdbDumpvars(0,system.ae350_chip.ae350_apb_subsystem.u_spi2);
		`ifdef PRESIM
			`ifdef DUMP_SYS
			$fsdbDumpvars(1,system);	
			`endif
			`ifdef DUMP_CHP
			$fsdbDumpvars(1,system.ae350_chip);	
			`endif			
		`else
			$dumpoff;
			$display("[%0t] www:dump by gpio( face to beef )", $time);
			//$fsdbDumpvars;
			wait (system.ae350_chip.X_gpio[15:0] === 16'hface);
			$display("[%0t] www:GPIO Asserted, Dump-Start !!!", $time);
			$fsdbAutoSwitchDumpfile(100, "verilog.fsdb", 10);
			$fsdbDumpvars;

			wait (system.ae350_chip.X_gpio[15:0] === 16'hbeef);
			$display("[%0t] www:GPIO Asserted, Dump-END !!!", $time);
			$dumpoff;
		`endif		
	`else
	`ifdef VPD
		$vcdpluson;
	`else
		$dumpvars;
	`endif
	`endif
	`endif
end
`endif
endmodule
