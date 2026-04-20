`ifdef NDS_GLOBAL_INC
`else
`define NDS_GLOBAL_INC
`endif // NDS_GLOBAL_INC

//`define AE350_CLK_RATIO_4_2_1
//[ 3:0] core/aclk:hclk:pclk -> 1/2/4
`define X2P_PCLK_FREQ 4'h2
//[ 7:4] highspeed_pclk
`define DDR_CLKR_DEFAULT 12'h300
//pll1/(2^N)
`define SW_RST_DEFAULT 12'hf87
`define IP_CLKR_DEFAULT 32'h01070101
//pll2_div8/(N+1)
`define SRAM_1MB

//#CYC[
`define SMU_ADDR_WIDTH 16	//APBIF TO BE DECODED ADDRESS-WIDTH
//IPs
//`define HBW_MST
`define HBW_SLV
`define HBW_BUS_MID_WIDTH 13
`define HBW_BUS_SID_WIDTH 14
`define MST_BUS_MID_WIDTH 6
`define MST_BUS_SID_WIDTH 6
`define X2P_SLV
//`define SPLL
`ifdef SPLL
	//`define DWC_PLL_PG_PINS
	//`define DWC_PLL_PG_PINS_SIM	
`endif	
//`define SDDR
`ifdef SDDR	
	`define DWC_DDRPHY_PG_PINS
	`define DWC_DDRPHY_TOP_PG_PINS
	`define DDR0
	//`define DDR1
`endif
//`define XDDR
`ifdef XDDR	
	`define DDR0
	//`define DDR1
`endif
//`define MSHC
//`define MSHC_H2H
`define SSIC
//`define PCIE
`define CUBE
`define CUBE_ONLY
//#CYC]


//***SIM ONLY***//
//`define DUMP_SPI_ONLY
//`define TEST_INT
`define BYPASS_FLASH
//`define EMU_PLL
