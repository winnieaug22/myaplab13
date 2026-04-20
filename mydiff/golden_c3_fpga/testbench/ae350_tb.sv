
`timescale 1ns/1ps

`include "ae350_config.vh"
`include "ae350_const.vh"
`include "sample_ae350_smu_config.vh"
`include "sample_ae350_smu_const.vh"
`include "config.inc"
`include "global.inc"
`include "xmr.vh"
`include "ae350_xmr.vh"


`include "atcbmc300_config.vh"
`include "atcbmc300_const.vh"


`ifdef AE350_OSCH_PERIOD
`else
	`ifdef NDS_FPGA
		`define AE350_OSCH_PERIOD 50
	`else
		//`define AE350_OSCH_PERIOD 25
		`define AE350_OSCH_PERIOD 50
		//`define AE350_OSCH_PERIOD 200
	`endif
`endif

`ifdef AE350_OSCL_PERIOD
`else
        `define AE350_OSCL_PERIOD 30517.58
`endif

`ifdef AE350_POR_PERIOD
`else
	`define	AE350_POR_PERIOD	(10.0 * `AE350_OSCH_PERIOD)
`endif

`ifdef NDS_PLATFORM_TEST_DEEPSLEEP
	`define IMAGE_SIZE_POT		21
`else
	`define IMAGE_SIZE_POT		24
`endif

module ae350_tb (

		  X_cpu_araddr,
		  X_cpu_arburst,
		  X_cpu_arcache,
		  X_cpu_arid,
		  X_cpu_arlen,
		  X_cpu_arlock,
		  X_cpu_arprot,
		  X_cpu_arready,
		  X_cpu_arsize,
		  X_cpu_arvalid,
		  X_cpu_awaddr,
		  X_cpu_awburst,
		  X_cpu_awcache,
		  X_cpu_awid,
		  X_cpu_awlen,
		  X_cpu_awlock,
		  X_cpu_awprot,
		  X_cpu_awready,
		  X_cpu_awsize,
		  X_cpu_awvalid,
		  X_cpu_bid,
		  X_cpu_bready,
		  X_cpu_bresp,
		  X_cpu_bvalid,
		  X_cpu_rdata,
		  X_cpu_rid,
		  X_cpu_rlast,
		  X_cpu_rready,
		  X_cpu_rresp,
		  X_cpu_rvalid,
		  X_cpu_wdata,
		  X_cpu_wlast,
		  X_cpu_wready,
		  X_cpu_wstrb,
		  X_cpu_wvalid,
		  X_aclk,
		  X_aresetn,

		  H_hclk,
		  H_hresetn,
		  H_hm0_haddr,
		  H_hm0_htrans,
		  H_hm0_hwrite,
		  H_hm0_hsize,
		  H_hm0_hburst,
		  H_hm0_hprot,
		  H_hm0_hwdata,
		  H_hm0_hreadyi,
		  H_hm0_hmaster,
		  H_hm0_hmastlock,
		  H_hm0_hrdata,
		  H_hm0_hresp,
		  H_hm0_hselx,
		  H_hs0_haddr,
		  H_hs0_htrans,
		  H_hs0_hwrite,
		  H_hs0_hsize,
		  H_hs0_hburst,
		  H_hs0_hprot,
		  H_hs0_hwdata,
		  H_hs0_hreadyi,
		  H_hs0_hmaster,
		  H_hs0_hmastlock,
		  H_hs0_hrdata,
		  H_hs0_hresp,
		  H_hs0_hsel,
		  H_hs0_hselx,
	`ifdef AE350_UART1_SUPPORT
		  X_uart1_rxd,
		  X_uart1_txd,
		  X_uart1_dcdn,
		  X_uart1_dsrn,
		  X_uart1_rin,
		  X_uart1_dtrn,
		  X_uart1_out1n,
		  X_uart1_out2n,
	   `ifdef AE350_UART2_SUPPORT
	      `ifdef NDS_FPGA
	      `else
		  X_uart1_ctsn,
		  X_uart1_rtsn,
	      `endif
	   `else
		  X_uart1_ctsn,
		  X_uart1_rtsn,
	   `endif
	`endif
	`ifdef AE350_UART2_SUPPORT
		  X_uart2_rxd,
		  X_uart2_txd,
	   `ifdef NDS_FPGA
	   `else
		  X_uart2_ctsn,
		  X_uart2_rtsn,
		  X_uart2_dcdn,
		  X_uart2_dsrn,
		  X_uart2_rin,
		  X_uart2_dtrn,
		  X_uart2_out1n,
		  X_uart2_out2n,
	   `endif
	`endif
	`ifdef NDS_FPGA
	`else
		  X_mpd_pwr_off,
	`endif
		  X_om,
		  X_hw_rstn,
		  X_aopd_por_b,
		  X_por_b,
		  X_oschin,
		  X_osclin,
		  X_wakeup_in
);
parameter DDR3_CLK_PERIOD = 5;
parameter DDR4_CLK_PERIOD = 4;
parameter IMAGE_SIZE = 1 << `IMAGE_SIZE_POT;
parameter ILM_BASE = `NDS_ILM_BASE >> 2;
parameter DLM_BASE = `NDS_DLM_BASE >> 2;

`ifdef PLATFORM_RESET_VECTOR
parameter PLATFORM_RESET_VECTOR = `PLATFORM_RESET_VECTOR;
`else
parameter PLATFORM_RESET_VECTOR = 64'h80000000;
`endif

`ifdef PLATFORM_SPI_MEM_BASE
parameter PLATFORM_SPI_MEM_BASE = `PLATFORM_SPI_MEM_BASE;
`else
parameter PLATFORM_SPI_MEM_BASE = 64'h80000000;
`endif

`ifdef PLATFORM_DEBUG_VECTOR
parameter PLATFORM_DEBUG_VECTOR = `PLATFORM_DEBUG_VECTOR;
`else
parameter PLATFORM_DEBUG_VECTOR = 64'he6800000;
`endif

`ifdef PLATFORM_PLIC_REGS_BASE
parameter PLATFORM_PLIC_REGS_BASE = `PLATFORM_PLIC_REGS_BASE;
`else
parameter PLATFORM_PLIC_REGS_BASE = 64'he4000000;
`endif

`ifdef PLATFORM_PLMT_REGS_BASE
parameter PLATFORM_PLMT_REGS_BASE = `PLATFORM_PLMT_REGS_BASE;
`else
parameter PLATFORM_PLMT_REGS_BASE = 64'he6000000;
`endif

`ifdef PLATFORM_NO_PLIC_SW
parameter PLATFORM_NO_PLIC_SW = "yes";
`else
parameter PLATFORM_NO_PLIC_SW = "no";
`endif

`ifdef PLATFORM_PLIC_SW_REGS_BASE
parameter PLATFORM_PLIC_SW_REGS_BASE = `PLATFORM_PLIC_SW_REGS_BASE;
`else
parameter PLATFORM_PLIC_SW_REGS_BASE = 64'he6400000;
`endif


`ifdef PLATFORM_PLDM_REGS_BASE
parameter PLATFORM_PLDM_REGS_BASE = `PLATFORM_PLDM_REGS_BASE;
`else
parameter PLATFORM_PLDM_REGS_BASE = 64'he6800000;
`endif

`ifndef DISABLE_BOOT_DCLS_SPLIT_MODE
    `ifdef BOOT_DCLS_SPLIT_MODE
    localparam DCLS_SPLIT_MODE = 1;
    `else
    localparam DCLS_SPLIT_MODE = 0;
    `endif
`else
    localparam DCLS_SPLIT_MODE = 0;
`endif

localparam	XLEN  = `NDS_ISA_BASE == "rv64i" ? 64 : 32;
localparam	PALEN = `NDS_BIU_ADDR_WIDTH;
localparam	MMU_SCHEME = `NDS_MMU_SCHEME;
localparam	VALEN = (MMU_SCHEME == "sv32") ? 32 : (MMU_SCHEME == "sv39") ? 39 : (MMU_SCHEME == "sv48") ? 48 : PALEN;

localparam	ICACHE_WAY		= `NDS_ICACHE_WAY;
localparam	ICACHE_SIZE_KB		= `NDS_ICACHE_SIZE_KB;
localparam	ICACHE_LRU		= `NDS_ICACHE_LRU;
localparam	ICACHE_TAG_RAM_AW	= `NDS_ICACHE_TAG_RAM_AW;
localparam	ICACHE_TAG_RAM_DW	= `NDS_ICACHE_TAG_RAM_DW;

localparam	BIU_ID_WIDTH	= `NDS_BIU_ID_WIDTH;

localparam	SLAVE_PORT_SUPPORT = `NDS_SLAVE_PORT_SUPPORT;
localparam	SLAVE_PORT_ID_WIDTH = `NDS_SLAVE_PORT_ID_WIDTH;
localparam	DEBUG_SUPPORT      = `NDS_DEBUG_SUPPORT;
localparam	NDS_DEVICE_REGION0_BASE = `NDS_DEVICE_REGION0_BASE;
localparam	NDS_DEVICE_REGION0_MASK = `NDS_DEVICE_REGION0_MASK;
localparam	NDS_DEVICE_REGION1_BASE = `NDS_DEVICE_REGION1_BASE;
localparam	NDS_DEVICE_REGION1_MASK = `NDS_DEVICE_REGION1_MASK;
localparam	NDS_DEVICE_REGION2_BASE = `NDS_DEVICE_REGION2_BASE;
localparam	NDS_DEVICE_REGION2_MASK = `NDS_DEVICE_REGION2_MASK;
localparam	NDS_DEVICE_REGION3_BASE = `NDS_DEVICE_REGION3_BASE;
localparam	NDS_DEVICE_REGION3_MASK = `NDS_DEVICE_REGION3_MASK;
localparam	NDS_DEVICE_REGION4_BASE = `NDS_DEVICE_REGION4_BASE;
localparam	NDS_DEVICE_REGION4_MASK = `NDS_DEVICE_REGION4_MASK;
localparam	NDS_DEVICE_REGION5_BASE = `NDS_DEVICE_REGION5_BASE;
localparam	NDS_DEVICE_REGION5_MASK = `NDS_DEVICE_REGION5_MASK;
localparam	NDS_DEVICE_REGION6_BASE = `NDS_DEVICE_REGION6_BASE;
localparam	NDS_DEVICE_REGION6_MASK = `NDS_DEVICE_REGION6_MASK;
localparam	NDS_DEVICE_REGION7_BASE = `NDS_DEVICE_REGION7_BASE;
localparam	NDS_DEVICE_REGION7_MASK = `NDS_DEVICE_REGION7_MASK;


localparam      VLEN = `NDS_VLEN;
localparam      DLEN = `NDS_DLEN;
localparam      ELEN = `NDS_ELEN;
localparam      FELEN = `NDS_FELEN;

localparam      FPU_TYPE = `NDS_FPU_TYPE;

`ifdef NDS_IOCP_NUM
localparam	IOCP_NUM = `NDS_IOCP_NUM;
localparam	IOCP_ID_WIDTH = `NDS_IOCP_ID_WIDTH;
`else
localparam	IOCP_NUM = 0;
localparam	IOCP_ID_WIDTH = BIU_ID_WIDTH + 4;
`endif

localparam      ILM_DW = `NDS_ILM_DATA_WIDTH;
localparam      DLM_DW = `NDS_DLM_DATA_WIDTH;
localparam	DLM_SIZE_KB   = `NDS_DLM_SIZE_KB;
localparam	ILM_SIZE_KB   = `NDS_ILM_SIZE_KB;
localparam	DLM_ECC_TYPE  = `NDS_DLM_ECC_TYPE;
localparam	ILM_ECC_TYPE  = `NDS_ILM_ECC_TYPE;
localparam	DLM_WORD_SIZE = DLM_SIZE_KB*1024/4;
localparam	ILM_WORD_SIZE = (ILM_SIZE_KB == 0) ? 64*1024/4 : ILM_SIZE_KB*1024/4;
localparam	DLM_ECCW      = (DLM_DW == 64) ? 8 : (DLM_ECC_TYPE == "ecc" ? 7 : 4);
localparam	ILM_ECCW      = (ILM_DW == 64) ? 8 : (ILM_ECC_TYPE == "ecc" ? 7 : 4);
localparam	DLM_RAM_DW    = (DLM_ECC_TYPE != "none") ? (DLM_DW+DLM_ECCW) : DLM_DW;
localparam	ILM_RAM_DW    = (ILM_ECC_TYPE != "none") ? (ILM_DW+ILM_ECCW) : ILM_DW;
localparam	DLM_BANKS     = `NDS_NUM_DLM_BANKS;
localparam      DLM_AMSB      = (DLM_DW == 64) ?
			(DLM_BANKS == 1) ? `NDS_DLM_RAM_AW+2 : (DLM_BANKS == 2) ? `NDS_DLM_RAM_AW+2 +1 : `NDS_DLM_RAM_AW+2+2 :
                        (DLM_BANKS == 1) ? `NDS_DLM_RAM_AW+1 : (DLM_BANKS == 2) ? `NDS_DLM_RAM_AW+1 +1 : `NDS_DLM_RAM_AW+1+2;

localparam FUSA_SUPPORT         = 0;


localparam FLASHIF0_SIZE_KB     = `NDS_FLASHIF0_SIZE_KB;
localparam FLASHIF0_REGION_BASE = `NDS_FLASHIF0_REGION_BASE;
localparam PPI_SIZE_KB          = `NDS_PPI_SIZE_KB;
localparam PPI_BASE             = `NDS_PPI_REGION_BASE;
localparam PPI_INTERFACE        = `NDS_PPI_INTERFACE;
localparam SPP_SIZE_KB          = `NDS_SPP_SIZE_KB;
localparam SPP_BASE             = `NDS_SPP_REGION_BASE;
`ifdef NDS_HVM_SIZE_KB
localparam HVM_SIZE_KB		= `NDS_HVM_SIZE_KB;
localparam HVM_BASE		= `NDS_HVM_BASE;
`else
localparam HVM_SIZE_KB		= 0;
localparam HVM_BASE		= 64'h90000000;
`endif

`ifdef L2C_REG_SIZE_KB
localparam L2C_REG_SIZE_KB	= `NDS_L2C_REG_SIZE;
localparam L2C_BASE		= `NDS_L2C_REG_BASE;
`else
localparam L2C_REG_SIZE_KB	= 0;
localparam L2C_BASE		= 64'h00000000E0500000;
`endif


localparam NHART = `NDS_NHART;

`ifdef NDS_IO_L2C
localparam	L2C_SUPPORT    = 1;
`else
localparam	L2C_SUPPORT    = 0;
`endif

`ifndef NDS_SKIP_MISALIGNED_DEVICE_SLAVE_PORT_CHECK
localparam	SLVP_BASE = `ATCBMC300_SLV3_BASE_ADDR;
localparam	SLVP_DEVICE = ((SLVP_BASE & NDS_DEVICE_REGION0_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION0_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
			    | ((SLVP_BASE & NDS_DEVICE_REGION1_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION1_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
			    | ((SLVP_BASE & NDS_DEVICE_REGION2_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION2_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
			    | ((SLVP_BASE & NDS_DEVICE_REGION3_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION3_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
			    | ((SLVP_BASE & NDS_DEVICE_REGION4_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION4_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
			    | ((SLVP_BASE & NDS_DEVICE_REGION5_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION5_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
			    | ((SLVP_BASE & NDS_DEVICE_REGION6_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION6_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
			    | ((SLVP_BASE & NDS_DEVICE_REGION7_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION7_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
			    ;
`endif

`ifdef NDS_ATCSPI200_TEST
localparam	SPI1_MEM_BASE = `ATCBMC300_SLV4_BASE_ADDR;
localparam	SPI1_MEM_DEVICE = ((SPI1_MEM_BASE & NDS_DEVICE_REGION0_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION0_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
				| ((SPI1_MEM_BASE & NDS_DEVICE_REGION1_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION1_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
				| ((SPI1_MEM_BASE & NDS_DEVICE_REGION2_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION2_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
				| ((SPI1_MEM_BASE & NDS_DEVICE_REGION3_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION3_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
				| ((SPI1_MEM_BASE & NDS_DEVICE_REGION4_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION4_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
				| ((SPI1_MEM_BASE & NDS_DEVICE_REGION5_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION5_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
				| ((SPI1_MEM_BASE & NDS_DEVICE_REGION6_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION6_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
				| ((SPI1_MEM_BASE & NDS_DEVICE_REGION7_MASK[`ATCBMC300_ADDR_WIDTH-1:0]) == NDS_DEVICE_REGION7_BASE[`ATCBMC300_ADDR_WIDTH-1:0])
				;
`endif
`ifdef PLATFORM_JTAG_TAP_NUM
localparam      JTAG_TAP_NUM   = `PLATFORM_JTAG_TAP_NUM;
`else
localparam      JTAG_TAP_NUM   = 1;
`endif
`ifdef PLATFORM_DM_TAP_ID
localparam      DM_TAP_ID     = `PLATFORM_DM_TAP_ID;
`else
localparam      DM_TAP_ID     = 0;
`endif

`ifdef AE350_DDR3_RW_TEST
localparam AE350_DDR3_MEM_TEST_REDUCED_RANGE = 10;
localparam AE350_DDR3_MEM_BASE = 'h00000000;
localparam AE350_DDR3_MEM_SIZE = ('h80000000 >> AE350_DDR3_MEM_TEST_REDUCED_RANGE);
`endif


output        [`NDS_BIU_ADDR_WIDTH-1:0] X_cpu_araddr;
output                            [1:0] X_cpu_arburst;
output                            [3:0] X_cpu_arcache;
output      [(`ATCBMC300_ID_WIDTH-1):0] X_cpu_arid;
output                            [7:0] X_cpu_arlen;
output                                  X_cpu_arlock;
output                            [2:0] X_cpu_arprot;
output                                  X_cpu_arready;
output                            [2:0] X_cpu_arsize;
output                                  X_cpu_arvalid;
output        [`NDS_BIU_ADDR_WIDTH-1:0] X_cpu_awaddr;
output                            [1:0] X_cpu_awburst;
output                            [3:0] X_cpu_awcache;
output      [(`ATCBMC300_ID_WIDTH-1):0] X_cpu_awid;
output                            [7:0] X_cpu_awlen;
output                                  X_cpu_awlock;
output                            [2:0] X_cpu_awprot;
output                                  X_cpu_awready;
output                            [2:0] X_cpu_awsize;
output                                  X_cpu_awvalid;
output      [(`ATCBMC300_ID_WIDTH-1):0] X_cpu_bid;
output                                  X_cpu_bready;
output                            [1:0] X_cpu_bresp;
output                                  X_cpu_bvalid;
output        [`NDS_BIU_DATA_WIDTH-1:0] X_cpu_rdata;
output      [(`ATCBMC300_ID_WIDTH-1):0] X_cpu_rid;
output                                  X_cpu_rlast;
output                                  X_cpu_rready;
output                            [1:0] X_cpu_rresp;
output                                  X_cpu_rvalid;
output        [`NDS_BIU_DATA_WIDTH-1:0] X_cpu_wdata;
output                                  X_cpu_wlast;
output                                  X_cpu_wready;
output    [(`NDS_BIU_DATA_WIDTH/8)-1:0] X_cpu_wstrb;
output                                  X_cpu_wvalid;
output                                  X_aclk;
output                                  X_aresetn;

output		H_hclk;
output		H_hresetn;
output	[`AE350_HADDR_MSB:0]	H_hm0_haddr;
output	[1:0]	H_hm0_htrans;
output		H_hm0_hwrite;
output	[2:0]	H_hm0_hsize;
output	[2:0]	H_hm0_hburst;
output	[3:0]	H_hm0_hprot;
output	[31:0]	H_hm0_hwdata;
output		H_hm0_hreadyi;
output	[3:0]	H_hm0_hmaster;
output		H_hm0_hmastlock;
output	[31:0]	H_hm0_hrdata;
output	[1:0]	H_hm0_hresp;
output	[31:0]	H_hm0_hselx;
output	[`AE350_HADDR_MSB:0]	H_hs0_haddr;
output	[1:0]	H_hs0_htrans;
output		H_hs0_hwrite;
output	[2:0]	H_hs0_hsize;
output	[2:0]	H_hs0_hburst;
output	[3:0]	H_hs0_hprot;
output	[31:0]	H_hs0_hwdata;
output		H_hs0_hreadyi;
output	[3:0]	H_hs0_hmaster;
output		H_hs0_hmastlock;
output	[31:0]	H_hs0_hrdata;
output	[1:0]	H_hs0_hresp;
output		H_hs0_hsel;
output	[31:0]	H_hs0_hselx;



`ifdef AE350_UART1_SUPPORT
output		X_uart1_rxd;
input		X_uart1_txd;
output		X_uart1_dcdn;
output		X_uart1_dsrn;
output		X_uart1_rin;
input		X_uart1_dtrn;
input		X_uart1_out1n;
input		X_uart1_out2n;
`ifdef AE350_UART2_SUPPORT
	`ifndef NDS_FPGA
	output		X_uart1_ctsn;
	input		X_uart1_rtsn;
	`endif
`else
output		X_uart1_ctsn;
input		X_uart1_rtsn;
`endif
`endif

`ifdef AE350_UART2_SUPPORT
output		X_uart2_rxd;
input		X_uart2_txd;
`ifdef NDS_FPGA
`else
output		X_uart2_ctsn;
input		X_uart2_rtsn;
output		X_uart2_dcdn;
output		X_uart2_dsrn;
output		X_uart2_rin;
input		X_uart2_dtrn;
input		X_uart2_out1n;
input		X_uart2_out2n;
`endif
`endif
`ifdef NDS_FPGA
`else
input		X_mpd_pwr_off;
`endif
inout		X_om;
output		X_hw_rstn;
output		X_aopd_por_b;
output		X_por_b;
output		X_oschin;
output		X_osclin;
output		X_wakeup_in;

integer 	seed;
reg	[31:0]	osch_phase;
reg	[31:0]	oscl_phase;
reg		tb_debug_mon;
reg		X_oschin;
reg		X_osclin;
reg		X_hw_rstn;
reg		X_aopd_por_b;
reg		X_por_b;
reg		X_wakeup_in;
wire [(NHART-1):0] core_resetn;
wire [(NHART-1):0] core_resetn_d1;
`ifdef AE350_UART1_SUPPORT
reg		X_uart1_rxd;
reg		X_uart1_ctsn;
reg		X_uart1_dcdn;
reg		X_uart1_dsrn;
reg		X_uart1_rin;
`endif
`ifdef AE350_UART2_SUPPORT
reg		X_uart2_rxd;
reg		X_uart2_ctsn;
reg		X_uart2_dcdn;
reg		X_uart2_dsrn;
reg		X_uart2_rin;
`endif
`ifdef NDS_FPGA
`else
wire            X_pd_pwr_off;
wire            X_mpd_pwr_off_d1;
`endif
wire    [(NHART-1):0]		ilm_init_posedge_trigger;
// synthesis translate_off
reg	[31:0]	data /* sparse */ [0:IMAGE_SIZE-1];
reg	[31:0]	loader_data /* sparse */ [0:IMAGE_SIZE-1];
// synthesis translate_on

`ifndef NDS_NO_POWER_SCRIPT
`ifdef NDS_UPF_SIM
	`ifdef VCS
		import UPF::*;
		initial
		begin
			supply_on("VDD_0V81", 0.81);
			supply_on("VSS", 0.0);
		end
	`elsif XCELIUM
		initial
		begin
			void'($supply_on("VDD_0V81", 0.81));
			void'($supply_on("VSS", 0.0));
		end
	`elsif INCA
		initial
		begin
			void'($supply_on("VDD_0V81", 0.81));
			void'($supply_on("VSS", 0.0));
		end
	`endif
`endif
`endif

assign		X_om = 1'b0;
integer		default_seed = 32'h9bbd09e5;

initial begin
	if ($value$plusargs("seed=%d", seed))
		seed = seed ^ default_seed;
	else
		seed = default_seed;

	osch_phase = $urandom(seed) % $rtoi(`AE350_OSCH_PERIOD * 1000.0);
	oscl_phase = $urandom(seed) % $rtoi(`AE350_OSCL_PERIOD * 1000.0);

	// synthesis translate_off
       	$readmemh("NDSROM.dat", data);
       	$readmemh("loader.dat", loader_data);
	// synthesis translate_on

		tb_debug_mon = 1'b1;
end

initial begin
        X_oschin = 1'b0;
	#1;
	#(osch_phase / 1000.0);
        forever
                #(`AE350_OSCH_PERIOD/2.0) X_oschin = ~X_oschin;
end

initial begin
        X_osclin = 1'b0;
	#1;
	#(oscl_phase / 1000.0);
        forever
                #(`AE350_OSCL_PERIOD/2.0) X_osclin = ~X_osclin;
end

//#CYC[
`ifdef SPLL
/*
real avddhv;
real vdd;
real avdd;
real vss;
real avss;
   `ifdef DWC_PLL_PG_PINS_SIM
	assign   `NDS_CHIP_AOPD.u_smu_pllgen.u_smu_plltop.rl1_avdd    = avdd;
	assign   `NDS_CHIP_AOPD.u_smu_pllgen.u_smu_plltop.rl1_agnd    = vss;
	assign   `NDS_CHIP_AOPD.u_smu_pllgen.u_smu_plltop.rl1_avddhv  = avddhv;
	assign   `NDS_CHIP_AOPD.u_smu_pllgen.u_smu_plltop.rl1_dvdd    = vdd;
	assign   `NDS_CHIP_AOPD.u_smu_pllgen.u_smu_plltop.rl1_dgnd    = vss;
	assign   `NDS_CHIP_AOPD.u_smu_pllgen.u_smu_plltop.pll1_avdd   = avdd;	//for vp_vref
	assign   `NDS_CHIP_AOPD.u_smu_pllgen.u_smu_plltop.rl2_avdd    = avdd;
	assign   `NDS_CHIP_AOPD.u_smu_pllgen.u_smu_plltop.rl2_agnd    = vss;
	assign   `NDS_CHIP_AOPD.u_smu_pllgen.u_smu_plltop.rl2_avddhv  = avddhv;
	assign   `NDS_CHIP_AOPD.u_smu_pllgen.u_smu_plltop.rl2_dvdd    = vdd;
	assign   `NDS_CHIP_AOPD.u_smu_pllgen.u_smu_plltop.rl2_dgnd    = vss;
	assign   `NDS_CHIP_AOPD.u_smu_pllgen.u_smu_plltop.pll2_avdd   = avdd;	//for vp_vref
   `endif

initial begin
   vdd = 0;
   avdd = 0;
   avddhv = 0;
   avss = 0;
   vss = 0;
 #10
   vdd  = 0.8;
   avdd = 0.8;
   avddhv = 1.8;
end
*/
	//assign 	`NDS_CHIP_AOPD.u_smu_pllgen.u_smu_plltop.u_pll1.vp_vref = 1'b1;
	//assign 	`NDS_CHIP_AOPD.u_smu_pllgen.u_smu_plltop.u_pll2.vp_vref = 1'b1;
`endif

/*
`ifdef MSHC
	assign `NDS_CHIP_TOP.u_DWC_mshc_ss.VDDIO 	= 1'b1;
	assign `NDS_CHIP_TOP.u_DWC_mshc_ss.VDDIO33    	= 1'b1;
	assign `NDS_CHIP_TOP.u_DWC_mshc_ss.VDD_CORE   	= 1'b1;
	assign `NDS_CHIP_TOP.u_DWC_mshc_ss.VSS        	= 1'b0;
`endif
*/

//#CYC]

initial begin
	X_hw_rstn	= 1'b0;	//#CYC 0
	X_wakeup_in	= 1'b0;

	X_aopd_por_b	= 1'b0;
	X_por_b		= 1'b0;

	#(`AE350_POR_PERIOD) ;
	X_aopd_por_b	= 1'b1;

	#10;
	X_hw_rstn	= 1'b1;	//#CYC
	X_por_b		= 1'b1;

`ifdef AE350_UART1_SUPPORT
	X_uart1_dcdn	= 1'b1;
	X_uart1_dsrn 	= 1'b1;
	X_uart1_rin  	= 1'b1;
`endif

`ifdef AE350_UART2_SUPPORT
	X_uart2_dcdn 	= 1'b1;
	X_uart2_dsrn 	= 1'b1;
	X_uart2_rin  	= 1'b1;
`endif
end



`ifdef AE350_UART1_SUPPORT
`ifdef AE350_UART2_SUPPORT
always @* begin
	if ($test$plusargs("uart1_uart2"))
		X_uart1_rxd = X_uart2_txd;
	else
		X_uart1_rxd = 1'b1;
end

always @* begin
	if ($test$plusargs("uart1_uart2"))
		X_uart2_rxd = X_uart1_txd;
	else
		X_uart2_rxd = 1'b1;
end
`ifndef NDS_FPGA
always @* begin
	if ($test$plusargs("uart1_uart2"))
		X_uart1_ctsn = X_uart2_rtsn;
	else
		X_uart1_ctsn = 1'b1;
end

always @* begin
	if ($test$plusargs("uart1_uart2"))
		X_uart2_ctsn = X_uart1_rtsn;
	else
		X_uart2_ctsn = 1'b1;
end
`endif
`endif
`endif


`ifdef NDS_SPI4_TEST
	`define NDS_SPI 	`NDS_SPI4
	`define EPD		`NDS_BENCH_TOP.epd_model4
	`define EPD_DATA	`EPD.dtm
`elsif NDS_SPI3_TEST
	`define NDS_SPI 	`NDS_SPI3
	`define EPD		`NDS_BENCH_TOP.epd_model3
	`define EPD_DATA	`EPD.dtm
`elsif NDS_SPI2_TEST
	`define NDS_SPI 	`NDS_SPI2
	`define EPD		`NDS_BENCH_TOP.epd_model2
	`define EPD_DATA	`EPD.dtm
`else
	`define NDS_SPI 	`NDS_SPI1
	`define EPD		`NDS_BENCH_TOP.epd_model1
	`define EPD_DATA	`EPD.dtm
`endif

// synthesis translate_off

assign X_cpu_araddr  = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_araddr;
assign X_cpu_arburst = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_arburst;
assign X_cpu_arcache = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_arcache;
assign X_cpu_arid    = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_arid;
assign X_cpu_arlen   = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_arlen;
assign X_cpu_arlock  = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_arlock;
assign X_cpu_arprot  = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_arprot;
assign X_cpu_arready = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_arready;
assign X_cpu_arsize  = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_arsize;
assign X_cpu_arvalid = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_arvalid;
assign X_cpu_awaddr  = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_awaddr;
assign X_cpu_awburst = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_awburst;
assign X_cpu_awcache = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_awcache;
assign X_cpu_awid    = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_awid;
assign X_cpu_awlen   = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_awlen;
assign X_cpu_awlock  = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_awlock;
assign X_cpu_awprot  = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_awprot;
assign X_cpu_awready = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_awready;
assign X_cpu_awsize  = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_awsize;
assign X_cpu_awvalid = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_awvalid;
assign X_cpu_bid     = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_bid;
assign X_cpu_bready  = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_bready;
assign X_cpu_bresp   = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_bresp;
assign X_cpu_bvalid  = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_bvalid;
assign X_cpu_rdata   = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_rdata;
assign X_cpu_rid     = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_rid;
assign X_cpu_rlast   = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_rlast;
assign X_cpu_rready  = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_rready;
assign X_cpu_rresp   = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_rresp;
assign X_cpu_rvalid  = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_rvalid;
assign X_cpu_wdata   = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_wdata;
assign X_cpu_wlast   = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_wlast;
assign X_cpu_wready  = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_wready;
assign X_cpu_wstrb   = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_wstrb;
assign X_cpu_wvalid  = `NDS_PLATFORM_CORE.ae350_bus_connector.us0_wvalid;
assign X_aclk        = `NDS_PLATFORM_CORE.ae350_bus_connector.aclk;
assign X_aresetn     = `NDS_PLATFORM_CORE.ae350_bus_connector.aresetn;
always @(`NDS_SIM_CONTROL.rd_en_d1, `NDS_SIM_CONTROL.rd_en3_d1) begin
	if (`NDS_SIM_CONTROL.rd_en_d1 || `NDS_SIM_CONTROL.rd_en3_d1) begin
		force   `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hrdata = `NDS_SIM_CONTROL.hrdata;
		$display("%0t:%m: force `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hrdata = `NDS_SIM_CONTROL.hrdata", $time);
	end
	else begin
		release `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hrdata;
	end
end

assign H_hclk		= `NDS_PLATFORM_CORE.hclk;
assign H_hresetn	= `NDS_PLATFORM_CORE.hresetn;
assign H_hm0_haddr	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_haddr;
assign H_hm0_htrans	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_htrans;
assign H_hm0_hwrite	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hwrite;
assign H_hm0_hsize	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hsize;
assign H_hm0_hburst	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hburst;
assign H_hm0_hprot	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hprot;
assign H_hm0_hwdata	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hwdata;
assign H_hm0_hreadyi	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hready;
assign H_hm0_hmaster	= 4'h0;
assign H_hm0_hmastlock	= 1'b0;
assign H_hm0_hrdata	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hrdata;
assign H_hm0_hresp	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hresp;
assign H_hm0_hselx	= 32'h1;
assign H_hs0_haddr	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_haddr;
assign H_hs0_htrans	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_htrans;
assign H_hs0_hwrite	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hwrite;
assign H_hs0_hsize	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hsize;
assign H_hs0_hburst	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hburst;
assign H_hs0_hprot	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hprot;
assign H_hs0_hwdata	= `NDS_PLATFORM_CORE.ae350_bus_connector.hbmc_hwdata;
assign H_hs0_hreadyi	= `NDS_AHBDEC.hready;
assign H_hs0_hmaster	= 4'b0;
assign H_hs0_hmastlock	= 1'b0;
assign H_hs0_hrdata	= `NDS_AHBDEC.ds0_hrdata;
assign H_hs0_hresp	= {1'b0,`NDS_AHBDEC.ds0_hresp};
assign H_hs0_hsel	= `NDS_AHBDEC.ds0_hsel;
assign H_hs0_hselx	= {31'h0, `NDS_AHBDEC.ds0_hsel};

`ifdef PLATFORM_DEBUG_SUBSYSTEM
	wire	[31:0] dmi_haddr_32bit = {23'd0, `NDS_CPU_SUBSYSTEM.`NDS_DEBUG_HADDR};
        defparam ahb_monitor_dmi.ADDR_WIDTH = 32;
        defparam ahb_monitor_dmi.ID = 3;
        defparam ahb_monitor_dmi.AHB_LITE = 1;
        defparam ahb_monitor_dmi.FORBID_UNKNOWN_READ_DATA = 1;
        ahb_monitor ahb_monitor_dmi (
                .hclk       (`NDS_CPU_SUBSYSTEM.`NDS_DEBUG_HCLK              ),
                .hresetn    (`NDS_CPU_SUBSYSTEM.`NDS_DEBUG_HRESETN           ),
                .hmaster    (4'd0                                              ),
                .hmastlock  (1'b0                                              ),
                .hselx      (32'h1                                             ),
                .haddr      (dmi_haddr_32bit			             ),
                .htrans     (`NDS_CPU_SUBSYSTEM.`NDS_DEBUG_HTRANS            ),
                .hwrite     (`NDS_CPU_SUBSYSTEM.`NDS_DEBUG_HWRITE            ),
                .hsize      (`NDS_CPU_SUBSYSTEM.`NDS_DEBUG_HSIZE             ),
                .hburst     (`NDS_CPU_SUBSYSTEM.`NDS_DEBUG_HBURST            ),
                .hprot      (`NDS_CPU_SUBSYSTEM.`NDS_DEBUG_HPROT             ),
                .hwdata     (`NDS_CPU_SUBSYSTEM.`NDS_DEBUG_HWDATA            ),
                .hrdata     (`NDS_CPU_SUBSYSTEM.`NDS_DEBUG_HRDATA            ),
                .hready     (`NDS_CPU_SUBSYSTEM.`NDS_DEBUG_HREADY            ),
                .hresp      (`NDS_CPU_SUBSYSTEM.`NDS_DEBUG_HRESP             ),
                .hllsc_req  (1'b0                                              ),
                .hllsc_error(1'b0                                              ),
                .hm0_hbusreq(1'b0                                              ),
                .hm0_hlock  (1'b0                                              ),
                .hm1_hbusreq(1'b0                                              ),
                .hm1_hlock  (1'b0                                              ),
                .hm2_hbusreq(1'b0                                              ),
                .hm2_hlock  (1'b0                                              ),
                .hm3_hbusreq(1'b0                                              ),
                .hm3_hlock  (1'b0                                              )
        );
`endif
// synthesis translate_on

always @(`NDS_SIM_CONTROL.event_finish) begin
	#5;
	$display("%0t:ipipe:sim_ctrl finish=%0d", $time, `NDS_SIM_CONTROL.finish_status);
	$finish;
end

`ifdef POWER_PATTERN_WFI
	initial begin
		#(`POWER_PATTERN_WFI);
		$display("%0t:ipipe: ---- SIMULATION FINISHED ----", $time);
		$finish;
	end
`endif

`ifdef TEST_MEM_INFO
	initial begin
		#20;
		$display("%0t:ipipe: ---- SIMULATION PASSED ----", $time);
		$finish;
	end
`endif

initial begin: error_termination
	reg [31:0]	error_status;

	fork: error_trap
`ifdef NDS_TB_PAT
		begin
			wait_model_error;
			get_program_status(error_status);
			disable error_trap;
		end
`endif
		begin
			`NDS_GPIO_MODEL.wait_model_error;
			`NDS_GPIO_MODEL.get_program_status(error_status);
			disable error_trap;
		end
`ifdef AE350_I2C_SUPPORT
		begin
			`NDS_I2C_MASTER.wait_model_error;
			`NDS_I2C_MASTER.get_program_status(error_status);
			disable error_trap;
		end
`endif
	join

	#10;
	$display("%0t:ERROR: ---- SIMULATION FAILED with status %0d ----", $time, error_status);
	$finish;
end

event skip_tb_unsupported;

`ifndef NDS_SKIP_TB_CHECK
initial begin: skip_termination
	wait(skip_tb_unsupported.triggered);
	$finish;
end
`endif

`ifndef AE350_SPI1_SUPPORT
	initial begin
		#5;
		$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('SPI1' should be configured to use the testbench.)", $time);
		->skip_tb_unsupported;
	end
`endif
generate
if (PLATFORM_RESET_VECTOR != PLATFORM_SPI_MEM_BASE) begin : gen_reset_vector_checker
	initial begin
		#5;
		$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Reset Vector Address' should be equal to 'SPI MEM Base Address' to use the testbench.)", $time);
		->skip_tb_unsupported;
	end
end
endgenerate

`ifndef NDS_SKIP_LM_SIZE_CHECK
generate
if (ILM_SIZE_KB > 2048) begin : gen_ilm_size_checker
	initial begin
		#5;
		$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('ILM Size' should be less than 2MiB to use the testbench.)", $time);
		->skip_tb_unsupported;
	end
end
if (ILM_SIZE_KB > 0 && ILM_BASE !='h0) begin : gen_ilm_base_checker
	initial begin
		#5;
		$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- (if 'ILM Size' is greater than 0 KiB, 'ILM Base' should be 0x0 to use the testbench.)", $time);
		->skip_tb_unsupported;
	end
end
endgenerate
generate
if (DLM_SIZE_KB > 2048) begin : gen_dlm_size_checker
	initial begin
		#5;
		$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('DLM Size' should be less than 2MiB to use the testbench.)", $time);
		->skip_tb_unsupported;
	end
end
endgenerate
`endif
`ifndef NDS_SKIP_MISALIGNED_DEVICE_SLAVE_PORT_CHECK
generate
if ((DLM_SIZE_KB >= 32) && (SLAVE_PORT_SUPPORT == "yes") && (SLVP_DEVICE == 1'b1)) begin : gen_misaligned_access_device_space
	initial begin
		#5;
		$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- (The testbench does not support misaligned access to device space through Slave Port)", $time);
		->skip_tb_unsupported;
	end
end
endgenerate
`endif

generate
if ((SLAVE_PORT_SUPPORT == "yes") && (SLAVE_PORT_ID_WIDTH < (BIU_ID_WIDTH + 4))) begin : gen_slave_port_id_width_checker
	initial begin
		#5;
		$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- (If 'Slave Port Support' is configured, 'Slave Port ID Width' should be greater than or equal to 'Bus ID Width + 4' to use the testbench.)", $time);
		->skip_tb_unsupported;
	end
end
endgenerate


`ifdef NDS_NCEPLDM200_TEST
generate
if (DEBUG_SUPPORT == "no") begin : gen_ncepldm200_test_checker
	initial begin
		#5;
		$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Debug Support' should be configured to run this test.)", $time);
		->skip_tb_unsupported;
	end
end
else if (PLATFORM_DEBUG_VECTOR != PLATFORM_PLDM_REGS_BASE) begin : gen_ncepldm200_debug_vector_checker
	initial begin
		#5;
		$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Debug Vector Address' should be equal to the base address of the Debug Module (PLDM) to use the testbench.)", $time);
		->skip_tb_unsupported;
	end
end
endgenerate

`endif

`ifdef NDS_ATCSPI200_TEST
generate
if ((L2C_SUPPORT == 1) && (SPI1_MEM_DEVICE == 0)) begin : gen_atcspi200_test_checker
	initial begin
		#5;
		$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('SPI MEM Base Address' should be assigned to the Device Region to run this test.)", $time);
		->skip_tb_unsupported;
	end
end
endgenerate
`endif

`ifdef NDS_ACE_ASP_SAMPLE
generate
if ((VLEN != 512) || (DLEN != 512) || (ELEN != 32) || (FELEN!=32) || (FPU_TYPE!="sp")) begin : gen_ace_asp_sample_checker
	initial begin
		#5;
		$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- (Test pattern only supports running on default config. currently.)", $time);
		->skip_tb_unsupported;
	end
end
endgenerate
`endif

generate
if ((IOCP_NUM >= 1) && (IOCP_ID_WIDTH < (BIU_ID_WIDTH + 4))) begin : gen_iocp_id_width_checker
	initial begin
		#5;
		$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- (If 'I/O Coherence Port (IOCP) Support' is configured, 'IOCP ID Width' should be greater than or equal to 'Bus ID Width + 4' to use the testbench.)", $time);
		->skip_tb_unsupported;
	end
end
endgenerate



generate
if (PPI_SIZE_KB > 0) begin: gen_ppi_checker
	if (PPI_SIZE_KB > 1024) begin: gen_ppi_size_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Size of Private Peripheral Region' should not greater than 1 MiB for using this testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if (PPI_BASE != 64'hc0300000) begin: gen_ppi_base_limitation_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Size of Private Peripheral Region' should be 0xc0300000 for using this testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
end
endgenerate

generate
if (SPP_SIZE_KB > 0) begin: gen_spp_checker
	if (SPP_SIZE_KB != 65536) begin: gen_spp_size_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Size of Shared Peripheral Region' should be 64 MiB to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if (((SPP_BASE >> 26) << 26) != ((PLATFORM_PLIC_REGS_BASE >> 26) << 26)) begin: gen_plic_spp_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Interrupt Controller (PLIC) Base Address' should be inside 'Base address of Shared Peripheral Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if (((SPP_BASE >> 26) << 26) != ((PLATFORM_PLMT_REGS_BASE >> 26) << 26)) begin: gen_plmt_spp_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Machine Timer (PLMT) Base Address' should be inside 'Base address of Shared Peripheral Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if ((PLATFORM_NO_PLIC_SW == "no") & (((SPP_BASE >> 26) << 26) != ((PLATFORM_PLIC_SW_REGS_BASE >> 26) << 26))) begin: gen_plic_sw_spp_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('PLIC_SWINT Base Address' should be inside 'Base address of Shared Peripheral Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if ((DEBUG_SUPPORT == "yes") & (((SPP_BASE >> 26) << 26) != ((PLATFORM_PLDM_REGS_BASE >> 26) << 26))) begin: gen_pldm_spp_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Debug Module (PLDM) Base Address' should be inside 'Base address of Shared Peripheral Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
end
endgenerate

generate
if (HVM_SIZE_KB > 0) begin: gen_hvm_checker
	if (HVM_SIZE_KB > 262144) begin: gen_hvm_size_limitation_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Size of HVM Region' should not be greater than 256 MiB to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if (HVM_BASE != 64'h90000000) begin: gen_hvm_base_limitation_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Base Address of HVM Region' should be 0x90000000 to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if (((HVM_BASE + HVM_SIZE_KB*1024) > PLATFORM_PLIC_REGS_BASE) && (PLATFORM_PLIC_REGS_BASE >= HVM_BASE)) begin: gen_plic_hvm_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Interrupt Controller (PLIC) Base Address' should not overlap with 'Base Address of HVM Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if (((HVM_BASE + HVM_SIZE_KB*1024) > PLATFORM_PLMT_REGS_BASE) && (PLATFORM_PLMT_REGS_BASE >= HVM_BASE)) begin: gen_plmt_hvm_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Machine Timer (PLMT) Base Address' should not overlap with 'Base Address of HVM Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if ((PLATFORM_NO_PLIC_SW == "no") && ((HVM_BASE + HVM_SIZE_KB*1024) > PLATFORM_PLIC_SW_REGS_BASE) && (PLATFORM_PLIC_SW_REGS_BASE >= HVM_BASE)) begin: gen_plic_sw_hvm_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('PLIC_SWINT Base Address' should not overlap with 'Base Address of HVM Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if ((DEBUG_SUPPORT == "yes") && ((HVM_BASE + HVM_SIZE_KB*1024) > PLATFORM_PLDM_REGS_BASE) && (PLATFORM_PLDM_REGS_BASE >= HVM_BASE)) begin: gen_pldm_hvm_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Debug Module (PLDM) Base Address' should not overlap with 'Base Address of HVM Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if ((ILM_SIZE_KB > 0) && (HVM_SIZE_KB > ILM_SIZE_KB) && ((HVM_BASE + HVM_SIZE_KB*1024) > ILM_BASE) && (ILM_BASE >= HVM_BASE)) begin: gen_hvm_gt_ilm_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('ILM Base' should not overlap with 'Base Address of HVM Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if ((ILM_SIZE_KB > 0) && (ILM_SIZE_KB > HVM_SIZE_KB) && ((ILM_BASE + ILM_SIZE_KB*1024) > HVM_BASE) && (HVM_BASE >= ILM_BASE)) begin: gen_ilm_gt_hvm_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('ILM Base' should not overlap with 'Base Address of HVM Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if ((DLM_SIZE_KB > 0) && (HVM_SIZE_KB > DLM_SIZE_KB) && ((HVM_BASE + HVM_SIZE_KB*1024) > DLM_BASE) && (DLM_BASE >= HVM_BASE)) begin: gen_hvm_gt_dlm_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('DLM Base' should not overlap with 'Base Address of HVM Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if ((DLM_SIZE_KB > 0) && (DLM_SIZE_KB > HVM_SIZE_KB) && ((DLM_BASE + DLM_SIZE_KB*1024) > HVM_BASE) && (HVM_BASE >= DLM_BASE)) begin: gen_dlm_gt_hvm_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('DLM Base' should not overlap with 'Base Address of HVM Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if ((SPP_SIZE_KB > 0) && (HVM_SIZE_KB > SPP_SIZE_KB) && ((HVM_BASE + HVM_SIZE_KB*1024) > SPP_BASE) && (DLM_BASE >= HVM_BASE)) begin: gen_hvm_gt_spp_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Base address of Shared Peripheral Region' should not overlap with 'Base Address of HVM Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if ((SPP_SIZE_KB > 0) && (SPP_SIZE_KB > HVM_SIZE_KB) && ((SPP_BASE + SPP_SIZE_KB*1024) > HVM_BASE) && (HVM_BASE >= SPP_BASE)) begin: gen_spp_gt_hvm_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Base address of Shared Peripheral Region' should not overlap with 'Base Address of HVM Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if ((L2C_SUPPORT > 0) && (HVM_SIZE_KB > L2C_REG_SIZE_KB) && ((HVM_BASE + HVM_SIZE_KB*1024) > L2C_BASE) && (DLM_BASE >= HVM_BASE)) begin: gen_hvm_gt_l2c_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('L2C Register Base' should not overlap with 'Base Address of HVM Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
	else if ((L2C_SUPPORT > 0) && (L2C_REG_SIZE_KB > HVM_SIZE_KB) && ((L2C_BASE + L2C_REG_SIZE_KB*1024) > HVM_BASE) && (HVM_BASE >= L2C_BASE)) begin: gen_l2c_gt_hvm_base_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('L2C Register Base' should not overlap with 'Base Address of HVM Region' to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
	end
end
`ifdef TEST_HVM
else begin: gen_no_hvm_checker
		initial begin
			#5;
			$display("%0t:ipipe: ---- SIMULATION SKIPPED ---- ('Size of HVM Region' should be greater than 0 KiB to use the testbench.)", $time);
			->skip_tb_unsupported;
		end
end
`endif
endgenerate



always @(`NDS_SIM_CONTROL.event_model_14) begin
	$display("%0t:power_analysis:tcf_dump_start", $time);
end

always @(`NDS_SIM_CONTROL.event_model_15) begin
	$display("%0t:power_analysis:tcf_dump_end", $time);
end
assign core_resetn = `NDS_CPU_SUBSYSTEM.core_resetn[(NHART-1):0];
assign #1 core_resetn_d1 = core_resetn;

`ifdef NDS_FPGA
	assign ilm_init_posedge_trigger = core_resetn_d1;
`else
assign X_pd_pwr_off = `NDS_PLATFORM_CORE.X_mpd_pwr_off;
assign #1 X_mpd_pwr_off_d1 = X_pd_pwr_off;
`ifdef NDS_PLATFORM_TEST_DEEPSLEEP
	assign ilm_init_posedge_trigger = core_resetn_d1;
`else
	assign ilm_init_posedge_trigger = {NHART{~X_mpd_pwr_off_d1}};
`endif
`endif

// synthesis translate_off


`ifndef NDS_SKIP_LM_SIZE_CHECK
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 64)) begin : gen_rv64_init_ilm0
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[0]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:0:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 2) begin
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:0:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			ilm_word = ((^data[ilm_idx+1]) === 1'bx) ? 32'd0 : data[ilm_idx+1];
			mem_data72[63:32] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:0:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[63:32]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
		                mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                        mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                end
                      `ifdef NDS_IO_ILM_RAM0
  	       		    `NDS_HART0_ILM0.u_ilm_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];

			    `endif
                      `ifdef NDS_IO_ILM_TL_UL

                          `NDS_CPU_SUBSYSTEM.gen_tl_ul_core0_ram0.u_ilm_tl_ul_core0_ram0.ram_inst.mem[ilm_idx[31:1]]  = mem_data72[ILM_RAM_DW-1:0];

                      `endif

		end
		$display("%0t:ipipe:0:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 32)) begin : gen_rv32_init_ilm0
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	integer	   ilm_idx_lsb;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[0]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:0:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 1) begin
			ilm_idx_lsb = (ilm_idx - ILM_WORD_SIZE/2);
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:0:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
	 	               mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                       mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                end
				`ifdef NDS_IO_ILM_TL_UL

                                      if (ilm_idx[0])
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core0_ram1.u_ilm_tl_ul_core0_ram1.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];
                                      else
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core0_ram0.u_ilm_tl_ul_core0_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];


				`endif

		end
		$display("%0t:ipipe:0:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`ifdef NDS_IO_HART1
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 64)) begin : gen_rv64_init_ilm1
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[1]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:1:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 2) begin
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:1:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			ilm_word = ((^data[ilm_idx+1]) === 1'bx) ? 32'd0 : data[ilm_idx+1];
			mem_data72[63:32] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:1:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[63:32]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
		                mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                        mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                end
                      `ifdef NDS_IO_ILM_RAM0
  	       		    `NDS_HART1_ILM0.u_ilm_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];

			    `endif
                      `ifdef NDS_IO_ILM_TL_UL

                          `NDS_CPU_SUBSYSTEM.gen_tl_ul_core1_ram0.u_ilm_tl_ul_core1_ram0.ram_inst.mem[ilm_idx[31:1]]  = mem_data72[ILM_RAM_DW-1:0];

                      `endif

		end
		$display("%0t:ipipe:1:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 32)) begin : gen_rv32_init_ilm1
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	integer	   ilm_idx_lsb;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[1]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:1:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 1) begin
			ilm_idx_lsb = (ilm_idx - ILM_WORD_SIZE/2);
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:1:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
	 	               mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                       mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                end
				`ifdef NDS_IO_ILM_TL_UL

                                      if (ilm_idx[0])
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core1_ram1.u_ilm_tl_ul_core1_ram1.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];
                                      else
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core1_ram0.u_ilm_tl_ul_core1_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];


				`endif

		end
		$display("%0t:ipipe:1:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`endif
`ifdef NDS_IO_HART2
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 64)) begin : gen_rv64_init_ilm2
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[2]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:2:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 2) begin
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:2:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			ilm_word = ((^data[ilm_idx+1]) === 1'bx) ? 32'd0 : data[ilm_idx+1];
			mem_data72[63:32] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:2:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[63:32]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
		                mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                        mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                end
                      `ifdef NDS_IO_ILM_RAM0
  	       		    `NDS_HART2_ILM0.u_ilm_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];

			    `endif
                      `ifdef NDS_IO_ILM_TL_UL

                          `NDS_CPU_SUBSYSTEM.gen_tl_ul_core2_ram0.u_ilm_tl_ul_core2_ram0.ram_inst.mem[ilm_idx[31:1]]  = mem_data72[ILM_RAM_DW-1:0];

                      `endif

		end
		$display("%0t:ipipe:2:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 32)) begin : gen_rv32_init_ilm2
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	integer	   ilm_idx_lsb;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[2]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:2:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 1) begin
			ilm_idx_lsb = (ilm_idx - ILM_WORD_SIZE/2);
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:2:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
	 	               mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                       mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                end
				`ifdef NDS_IO_ILM_TL_UL

                                      if (ilm_idx[0])
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core2_ram1.u_ilm_tl_ul_core2_ram1.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];
                                      else
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core2_ram0.u_ilm_tl_ul_core2_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];


				`endif

		end
		$display("%0t:ipipe:2:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`endif
`ifdef NDS_IO_HART3
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 64)) begin : gen_rv64_init_ilm3
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[3]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:3:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 2) begin
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:3:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			ilm_word = ((^data[ilm_idx+1]) === 1'bx) ? 32'd0 : data[ilm_idx+1];
			mem_data72[63:32] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:3:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[63:32]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
		                mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                        mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                end
                      `ifdef NDS_IO_ILM_RAM0
  	       		    `NDS_HART3_ILM0.u_ilm_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];

			    `endif
                      `ifdef NDS_IO_ILM_TL_UL

                          `NDS_CPU_SUBSYSTEM.gen_tl_ul_core3_ram0.u_ilm_tl_ul_core3_ram0.ram_inst.mem[ilm_idx[31:1]]  = mem_data72[ILM_RAM_DW-1:0];

                      `endif

		end
		$display("%0t:ipipe:3:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 32)) begin : gen_rv32_init_ilm3
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	integer	   ilm_idx_lsb;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[3]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:3:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 1) begin
			ilm_idx_lsb = (ilm_idx - ILM_WORD_SIZE/2);
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:3:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
	 	               mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                       mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                end
				`ifdef NDS_IO_ILM_TL_UL

                                      if (ilm_idx[0])
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core3_ram1.u_ilm_tl_ul_core3_ram1.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];
                                      else
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core3_ram0.u_ilm_tl_ul_core3_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];


				`endif

		end
		$display("%0t:ipipe:3:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`endif
`ifdef NDS_IO_HART4
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 64)) begin : gen_rv64_init_ilm4
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[4]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:4:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 2) begin
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:4:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			ilm_word = ((^data[ilm_idx+1]) === 1'bx) ? 32'd0 : data[ilm_idx+1];
			mem_data72[63:32] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:4:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[63:32]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
		                mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                        mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                end
                      `ifdef NDS_IO_ILM_RAM0
  	       		    `NDS_HART4_ILM0.u_ilm_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];

			    `endif
                      `ifdef NDS_IO_ILM_TL_UL

                          `NDS_CPU_SUBSYSTEM.gen_tl_ul_core4_ram0.u_ilm_tl_ul_core4_ram0.ram_inst.mem[ilm_idx[31:1]]  = mem_data72[ILM_RAM_DW-1:0];

                      `endif

		end
		$display("%0t:ipipe:4:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 32)) begin : gen_rv32_init_ilm4
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	integer	   ilm_idx_lsb;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[4]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:4:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 1) begin
			ilm_idx_lsb = (ilm_idx - ILM_WORD_SIZE/2);
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:4:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
	 	               mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                       mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                end
				`ifdef NDS_IO_ILM_TL_UL

                                      if (ilm_idx[0])
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core4_ram1.u_ilm_tl_ul_core4_ram1.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];
                                      else
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core4_ram0.u_ilm_tl_ul_core4_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];


				`endif

		end
		$display("%0t:ipipe:4:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`endif
`ifdef NDS_IO_HART5
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 64)) begin : gen_rv64_init_ilm5
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[5]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:5:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 2) begin
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:5:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			ilm_word = ((^data[ilm_idx+1]) === 1'bx) ? 32'd0 : data[ilm_idx+1];
			mem_data72[63:32] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:5:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[63:32]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
		                mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                        mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                end
                      `ifdef NDS_IO_ILM_RAM0
  	       		    `NDS_HART5_ILM0.u_ilm_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];

			    `endif
                      `ifdef NDS_IO_ILM_TL_UL

                          `NDS_CPU_SUBSYSTEM.gen_tl_ul_core5_ram0.u_ilm_tl_ul_core5_ram0.ram_inst.mem[ilm_idx[31:1]]  = mem_data72[ILM_RAM_DW-1:0];

                      `endif

		end
		$display("%0t:ipipe:5:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 32)) begin : gen_rv32_init_ilm5
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	integer	   ilm_idx_lsb;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[5]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:5:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 1) begin
			ilm_idx_lsb = (ilm_idx - ILM_WORD_SIZE/2);
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:5:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
	 	               mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                       mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                end
				`ifdef NDS_IO_ILM_TL_UL

                                      if (ilm_idx[0])
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core5_ram1.u_ilm_tl_ul_core5_ram1.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];
                                      else
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core5_ram0.u_ilm_tl_ul_core5_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];


				`endif

		end
		$display("%0t:ipipe:5:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`endif
`ifdef NDS_IO_HART6
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 64)) begin : gen_rv64_init_ilm6
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[6]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:6:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 2) begin
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:6:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			ilm_word = ((^data[ilm_idx+1]) === 1'bx) ? 32'd0 : data[ilm_idx+1];
			mem_data72[63:32] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:6:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[63:32]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
		                mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                        mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                end
                      `ifdef NDS_IO_ILM_RAM0
  	       		    `NDS_HART6_ILM0.u_ilm_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];

			    `endif
                      `ifdef NDS_IO_ILM_TL_UL

                          `NDS_CPU_SUBSYSTEM.gen_tl_ul_core6_ram0.u_ilm_tl_ul_core6_ram0.ram_inst.mem[ilm_idx[31:1]]  = mem_data72[ILM_RAM_DW-1:0];

                      `endif

		end
		$display("%0t:ipipe:6:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 32)) begin : gen_rv32_init_ilm6
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	integer	   ilm_idx_lsb;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[6]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:6:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 1) begin
			ilm_idx_lsb = (ilm_idx - ILM_WORD_SIZE/2);
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:6:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
	 	               mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                       mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                end
				`ifdef NDS_IO_ILM_TL_UL

                                      if (ilm_idx[0])
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core6_ram1.u_ilm_tl_ul_core6_ram1.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];
                                      else
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core6_ram0.u_ilm_tl_ul_core6_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];


				`endif

		end
		$display("%0t:ipipe:6:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`endif
`ifdef NDS_IO_HART7
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 64)) begin : gen_rv64_init_ilm7
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[7]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:7:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 2) begin
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:7:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			ilm_word = ((^data[ilm_idx+1]) === 1'bx) ? 32'd0 : data[ilm_idx+1];
			mem_data72[63:32] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:7:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[63:32]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
		                mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                        mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                end
                      `ifdef NDS_IO_ILM_RAM0
  	       		    `NDS_HART7_ILM0.u_ilm_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];

			    `endif
                      `ifdef NDS_IO_ILM_TL_UL

                          `NDS_CPU_SUBSYSTEM.gen_tl_ul_core7_ram0.u_ilm_tl_ul_core7_ram0.ram_inst.mem[ilm_idx[31:1]]  = mem_data72[ILM_RAM_DW-1:0];

                      `endif

		end
		$display("%0t:ipipe:7:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
generate
if ((ILM_SIZE_KB != 0) && (ILM_DW == 32)) begin : gen_rv32_init_ilm7
	reg [VALEN-1:0] vma_addr;
	reg [31:0] ilm_word;
	reg [71:0] mem_data72;
	integer	   ilm_idx;
	integer	   ilm_idx_lsb;
	always @(posedge X_por_b or posedge ilm_init_posedge_trigger[7]) begin
		$display("%0t:%m:INFO:Initialize ILM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:7:fast_reset milmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (ilm_idx = 0; ilm_idx < ILM_WORD_SIZE; ilm_idx = ilm_idx + 1) begin
			ilm_idx_lsb = (ilm_idx - ILM_WORD_SIZE/2);
			ilm_word = ((^data[ilm_idx]) === 1'bx) ? 32'h0 : data[ilm_idx];
			mem_data72[31:0] = {ilm_word[7:0], ilm_word[15:8], ilm_word[23:16], ilm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:7:ext update pa:%x mask:f data:%x", $time, vma_addr + (ILM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (ILM_ECC_TYPE == "ecc") begin
	 	               mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                end
	                else if (ILM_ECC_TYPE == "parity") begin
	                       mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                end
				`ifdef NDS_IO_ILM_TL_UL

                                      if (ilm_idx[0])
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core7_ram1.u_ilm_tl_ul_core7_ram1.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];
                                      else
                                        `NDS_CPU_SUBSYSTEM.gen_tl_ul_core7_ram0.u_ilm_tl_ul_core7_ram0.ram_inst.mem[ilm_idx[31:1]] = mem_data72[ILM_RAM_DW-1:0];


				`endif

		end
		$display("%0t:ipipe:7:fast_reset milmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`endif
`endif



`ifndef NDS_SKIP_LM_SIZE_CHECK
generate
if (DLM_SIZE_KB != 0) begin : gen_init_hart0_dlm
	reg [VALEN-1:0] vma_addr;
	reg [31:0] dlm_word;
	reg [71:0] mem_data72;
	integer	   dlm_idx;
	always @(posedge X_por_b) begin
		$display("%0t:%m:INFO:Initialize DLM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (dlm_idx = 0; dlm_idx < DLM_WORD_SIZE; dlm_idx = dlm_idx + 1) begin
			dlm_word = ((^data[dlm_idx]) === 1'bx) ? 32'h0 : data[dlm_idx];
			mem_data72[31:0] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:0:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (DLM_DW == 64) begin
				dlm_word = ((^data[dlm_idx+1]) === 1'bx) ? 32'd0 : data[dlm_idx+1];
				mem_data72[63:32] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
				if (DLM_ECC_TYPE == "ecc") begin
		                        mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                                mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				        `NDS_HART0_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[2:1] == 2'b00) begin
				        `NDS_HART0_DLM0[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b01) begin
				        `NDS_HART0_DLM1[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b10) begin
				        `NDS_HART0_DLM2[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b11) begin
				        `NDS_HART0_DLM3[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[1] == 0) begin
				        `NDS_HART0_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1] == 1) begin
				        `NDS_HART0_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif

				dlm_idx = dlm_idx+1;

				if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:0:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[63:32]);
				end
				vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			end
			else begin
				if (DLM_ECC_TYPE == "ecc") begin
	 	                       mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                               mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				      `NDS_HART0_DLM0[dlm_idx] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[1:0] == 2'b00) begin
				      `NDS_HART0_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b01) begin
				      `NDS_HART0_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b10) begin
				      `NDS_HART0_DLM2[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b11) begin
				      `NDS_HART0_DLM3[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[0] == 0) begin
				      `NDS_HART0_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[0] == 1) begin
				      `NDS_HART0_DLM1[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif
			end
		end
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`ifdef NDS_IO_HART1
generate
if (DLM_SIZE_KB != 0) begin : gen_init_hart1_dlm
	reg [VALEN-1:0] vma_addr;
	reg [31:0] dlm_word;
	reg [71:0] mem_data72;
	integer	   dlm_idx;
	always @(posedge X_por_b) begin
		$display("%0t:%m:INFO:Initialize DLM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (dlm_idx = 0; dlm_idx < DLM_WORD_SIZE; dlm_idx = dlm_idx + 1) begin
			dlm_word = ((^data[dlm_idx]) === 1'bx) ? 32'h0 : data[dlm_idx];
			mem_data72[31:0] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:1:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (DLM_DW == 64) begin
				dlm_word = ((^data[dlm_idx+1]) === 1'bx) ? 32'd0 : data[dlm_idx+1];
				mem_data72[63:32] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
				if (DLM_ECC_TYPE == "ecc") begin
		                        mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                                mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				        `NDS_HART1_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[2:1] == 2'b00) begin
				        `NDS_HART1_DLM0[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b01) begin
				        `NDS_HART1_DLM1[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b10) begin
				        `NDS_HART1_DLM2[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b11) begin
				        `NDS_HART1_DLM3[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[1] == 0) begin
				        `NDS_HART1_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1] == 1) begin
				        `NDS_HART1_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif

				dlm_idx = dlm_idx+1;

				if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:1:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[63:32]);
				end
				vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			end
			else begin
				if (DLM_ECC_TYPE == "ecc") begin
	 	                       mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                               mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				      `NDS_HART1_DLM0[dlm_idx] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[1:0] == 2'b00) begin
				      `NDS_HART1_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b01) begin
				      `NDS_HART1_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b10) begin
				      `NDS_HART1_DLM2[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b11) begin
				      `NDS_HART1_DLM3[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[0] == 0) begin
				      `NDS_HART1_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[0] == 1) begin
				      `NDS_HART1_DLM1[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif
			end
		end
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`endif
`ifdef NDS_IO_HART2
generate
if (DLM_SIZE_KB != 0) begin : gen_init_hart2_dlm
	reg [VALEN-1:0] vma_addr;
	reg [31:0] dlm_word;
	reg [71:0] mem_data72;
	integer	   dlm_idx;
	always @(posedge X_por_b) begin
		$display("%0t:%m:INFO:Initialize DLM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (dlm_idx = 0; dlm_idx < DLM_WORD_SIZE; dlm_idx = dlm_idx + 1) begin
			dlm_word = ((^data[dlm_idx]) === 1'bx) ? 32'h0 : data[dlm_idx];
			mem_data72[31:0] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:2:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (DLM_DW == 64) begin
				dlm_word = ((^data[dlm_idx+1]) === 1'bx) ? 32'd0 : data[dlm_idx+1];
				mem_data72[63:32] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
				if (DLM_ECC_TYPE == "ecc") begin
		                        mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                                mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				        `NDS_HART2_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[2:1] == 2'b00) begin
				        `NDS_HART2_DLM0[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b01) begin
				        `NDS_HART2_DLM1[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b10) begin
				        `NDS_HART2_DLM2[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b11) begin
				        `NDS_HART2_DLM3[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[1] == 0) begin
				        `NDS_HART2_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1] == 1) begin
				        `NDS_HART2_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif

				dlm_idx = dlm_idx+1;

				if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:2:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[63:32]);
				end
				vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			end
			else begin
				if (DLM_ECC_TYPE == "ecc") begin
	 	                       mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                               mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				      `NDS_HART2_DLM0[dlm_idx] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[1:0] == 2'b00) begin
				      `NDS_HART2_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b01) begin
				      `NDS_HART2_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b10) begin
				      `NDS_HART2_DLM2[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b11) begin
				      `NDS_HART2_DLM3[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[0] == 0) begin
				      `NDS_HART2_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[0] == 1) begin
				      `NDS_HART2_DLM1[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif
			end
		end
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`endif
`ifdef NDS_IO_HART3
generate
if (DLM_SIZE_KB != 0) begin : gen_init_hart3_dlm
	reg [VALEN-1:0] vma_addr;
	reg [31:0] dlm_word;
	reg [71:0] mem_data72;
	integer	   dlm_idx;
	always @(posedge X_por_b) begin
		$display("%0t:%m:INFO:Initialize DLM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (dlm_idx = 0; dlm_idx < DLM_WORD_SIZE; dlm_idx = dlm_idx + 1) begin
			dlm_word = ((^data[dlm_idx]) === 1'bx) ? 32'h0 : data[dlm_idx];
			mem_data72[31:0] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:3:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (DLM_DW == 64) begin
				dlm_word = ((^data[dlm_idx+1]) === 1'bx) ? 32'd0 : data[dlm_idx+1];
				mem_data72[63:32] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
				if (DLM_ECC_TYPE == "ecc") begin
		                        mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                                mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				        `NDS_HART3_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[2:1] == 2'b00) begin
				        `NDS_HART3_DLM0[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b01) begin
				        `NDS_HART3_DLM1[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b10) begin
				        `NDS_HART3_DLM2[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b11) begin
				        `NDS_HART3_DLM3[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[1] == 0) begin
				        `NDS_HART3_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1] == 1) begin
				        `NDS_HART3_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif

				dlm_idx = dlm_idx+1;

				if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:3:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[63:32]);
				end
				vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			end
			else begin
				if (DLM_ECC_TYPE == "ecc") begin
	 	                       mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                               mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				      `NDS_HART3_DLM0[dlm_idx] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[1:0] == 2'b00) begin
				      `NDS_HART3_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b01) begin
				      `NDS_HART3_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b10) begin
				      `NDS_HART3_DLM2[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b11) begin
				      `NDS_HART3_DLM3[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[0] == 0) begin
				      `NDS_HART3_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[0] == 1) begin
				      `NDS_HART3_DLM1[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif
			end
		end
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`endif
`ifdef NDS_IO_HART4
generate
if (DLM_SIZE_KB != 0) begin : gen_init_hart4_dlm
	reg [VALEN-1:0] vma_addr;
	reg [31:0] dlm_word;
	reg [71:0] mem_data72;
	integer	   dlm_idx;
	always @(posedge X_por_b) begin
		$display("%0t:%m:INFO:Initialize DLM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (dlm_idx = 0; dlm_idx < DLM_WORD_SIZE; dlm_idx = dlm_idx + 1) begin
			dlm_word = ((^data[dlm_idx]) === 1'bx) ? 32'h0 : data[dlm_idx];
			mem_data72[31:0] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:4:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (DLM_DW == 64) begin
				dlm_word = ((^data[dlm_idx+1]) === 1'bx) ? 32'd0 : data[dlm_idx+1];
				mem_data72[63:32] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
				if (DLM_ECC_TYPE == "ecc") begin
		                        mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                                mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				        `NDS_HART4_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[2:1] == 2'b00) begin
				        `NDS_HART4_DLM0[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b01) begin
				        `NDS_HART4_DLM1[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b10) begin
				        `NDS_HART4_DLM2[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b11) begin
				        `NDS_HART4_DLM3[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[1] == 0) begin
				        `NDS_HART4_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1] == 1) begin
				        `NDS_HART4_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif

				dlm_idx = dlm_idx+1;

				if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:4:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[63:32]);
				end
				vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			end
			else begin
				if (DLM_ECC_TYPE == "ecc") begin
	 	                       mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                               mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				      `NDS_HART4_DLM0[dlm_idx] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[1:0] == 2'b00) begin
				      `NDS_HART4_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b01) begin
				      `NDS_HART4_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b10) begin
				      `NDS_HART4_DLM2[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b11) begin
				      `NDS_HART4_DLM3[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[0] == 0) begin
				      `NDS_HART4_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[0] == 1) begin
				      `NDS_HART4_DLM1[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif
			end
		end
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`endif
`ifdef NDS_IO_HART5
generate
if (DLM_SIZE_KB != 0) begin : gen_init_hart5_dlm
	reg [VALEN-1:0] vma_addr;
	reg [31:0] dlm_word;
	reg [71:0] mem_data72;
	integer	   dlm_idx;
	always @(posedge X_por_b) begin
		$display("%0t:%m:INFO:Initialize DLM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (dlm_idx = 0; dlm_idx < DLM_WORD_SIZE; dlm_idx = dlm_idx + 1) begin
			dlm_word = ((^data[dlm_idx]) === 1'bx) ? 32'h0 : data[dlm_idx];
			mem_data72[31:0] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:5:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (DLM_DW == 64) begin
				dlm_word = ((^data[dlm_idx+1]) === 1'bx) ? 32'd0 : data[dlm_idx+1];
				mem_data72[63:32] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
				if (DLM_ECC_TYPE == "ecc") begin
		                        mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                                mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				        `NDS_HART5_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[2:1] == 2'b00) begin
				        `NDS_HART5_DLM0[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b01) begin
				        `NDS_HART5_DLM1[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b10) begin
				        `NDS_HART5_DLM2[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b11) begin
				        `NDS_HART5_DLM3[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[1] == 0) begin
				        `NDS_HART5_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1] == 1) begin
				        `NDS_HART5_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif

				dlm_idx = dlm_idx+1;

				if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:5:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[63:32]);
				end
				vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			end
			else begin
				if (DLM_ECC_TYPE == "ecc") begin
	 	                       mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                               mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				      `NDS_HART5_DLM0[dlm_idx] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[1:0] == 2'b00) begin
				      `NDS_HART5_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b01) begin
				      `NDS_HART5_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b10) begin
				      `NDS_HART5_DLM2[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b11) begin
				      `NDS_HART5_DLM3[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[0] == 0) begin
				      `NDS_HART5_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[0] == 1) begin
				      `NDS_HART5_DLM1[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif
			end
		end
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`endif
`ifdef NDS_IO_HART6
generate
if (DLM_SIZE_KB != 0) begin : gen_init_hart6_dlm
	reg [VALEN-1:0] vma_addr;
	reg [31:0] dlm_word;
	reg [71:0] mem_data72;
	integer	   dlm_idx;
	always @(posedge X_por_b) begin
		$display("%0t:%m:INFO:Initialize DLM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (dlm_idx = 0; dlm_idx < DLM_WORD_SIZE; dlm_idx = dlm_idx + 1) begin
			dlm_word = ((^data[dlm_idx]) === 1'bx) ? 32'h0 : data[dlm_idx];
			mem_data72[31:0] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:6:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (DLM_DW == 64) begin
				dlm_word = ((^data[dlm_idx+1]) === 1'bx) ? 32'd0 : data[dlm_idx+1];
				mem_data72[63:32] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
				if (DLM_ECC_TYPE == "ecc") begin
		                        mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                                mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				        `NDS_HART6_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[2:1] == 2'b00) begin
				        `NDS_HART6_DLM0[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b01) begin
				        `NDS_HART6_DLM1[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b10) begin
				        `NDS_HART6_DLM2[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b11) begin
				        `NDS_HART6_DLM3[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[1] == 0) begin
				        `NDS_HART6_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1] == 1) begin
				        `NDS_HART6_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif

				dlm_idx = dlm_idx+1;

				if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:6:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[63:32]);
				end
				vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			end
			else begin
				if (DLM_ECC_TYPE == "ecc") begin
	 	                       mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                               mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				      `NDS_HART6_DLM0[dlm_idx] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[1:0] == 2'b00) begin
				      `NDS_HART6_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b01) begin
				      `NDS_HART6_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b10) begin
				      `NDS_HART6_DLM2[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b11) begin
				      `NDS_HART6_DLM3[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[0] == 0) begin
				      `NDS_HART6_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[0] == 1) begin
				      `NDS_HART6_DLM1[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif
			end
		end
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`endif
`ifdef NDS_IO_HART7
generate
if (DLM_SIZE_KB != 0) begin : gen_init_hart7_dlm
	reg [VALEN-1:0] vma_addr;
	reg [31:0] dlm_word;
	reg [71:0] mem_data72;
	integer	   dlm_idx;
	always @(posedge X_por_b) begin
		$display("%0t:%m:INFO:Initialize DLM with NDSROM.dat content.", $time);
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b1);
		vma_addr = {VALEN{1'h0}};
		for (dlm_idx = 0; dlm_idx < DLM_WORD_SIZE; dlm_idx = dlm_idx + 1) begin
			dlm_word = ((^data[dlm_idx]) === 1'bx) ? 32'h0 : data[dlm_idx];
			mem_data72[31:0] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
			if (tb_debug_mon && (mem_data72[31:0] != 32'h0)) begin
				$display("%0t:ipipe:7:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[31:0]);
			end
			vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			if (DLM_DW == 64) begin
				dlm_word = ((^data[dlm_idx+1]) === 1'bx) ? 32'd0 : data[dlm_idx+1];
				mem_data72[63:32] = {dlm_word[7:0], dlm_word[15:8], dlm_word[23:16], dlm_word[31:24]};
				if (DLM_ECC_TYPE == "ecc") begin
		                        mem_data72[71:64] = ecc64_gen(mem_data72[63:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                                mem_data72[71:64] = parity64_gen(mem_data72[63:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				        `NDS_HART7_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[2:1] == 2'b00) begin
				        `NDS_HART7_DLM0[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b01) begin
				        `NDS_HART7_DLM1[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b10) begin
				        `NDS_HART7_DLM2[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[2:1] == 2'b11) begin
				        `NDS_HART7_DLM3[dlm_idx[31:3]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[1] == 0) begin
				        `NDS_HART7_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1] == 1) begin
				        `NDS_HART7_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif

				dlm_idx = dlm_idx+1;

				if (tb_debug_mon && (mem_data72[63:32] != 32'h0)) begin
					$display("%0t:ipipe:7:ext update pa:%x mask:f data:%x", $time, vma_addr + (DLM_BASE << 2), mem_data72[63:32]);
				end
				vma_addr = vma_addr + {{(VALEN-3){1'h0}}, 3'h4};
			end
			else begin
				if (DLM_ECC_TYPE == "ecc") begin
	 	                       mem_data72[38:32] = ecc32_gen(mem_data72[31:0]);
	                        end
	                        else if (DLM_ECC_TYPE == "parity") begin
	                               mem_data72[35:32] = parity32_gen(mem_data72[31:0]);
	                        end
                          `ifndef NDS_IO_DLM_RAM1
				      `NDS_HART7_DLM0[dlm_idx] = mem_data72[DLM_RAM_DW-1:0];
                          `endif
                          `ifdef NDS_IO_DLM_RAM1
                          `ifdef NDS_IO_DLM_RAM3
                          if (dlm_idx[1:0] == 2'b00) begin
				      `NDS_HART7_DLM0[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b01) begin
				      `NDS_HART7_DLM1[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b10) begin
				      `NDS_HART7_DLM2[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[1:0] == 2'b11) begin
				      `NDS_HART7_DLM3[dlm_idx[31:2]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `else
                          if (dlm_idx[0] == 0) begin
				      `NDS_HART7_DLM0[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          if (dlm_idx[0] == 1) begin
				      `NDS_HART7_DLM1[dlm_idx[31:1]] = mem_data72[DLM_RAM_DW-1:0];
                          end
                          `endif
                          `endif
			end
		end
		$display("%0t:ipipe:0:fast_reset mdlmb=%h", $realtime, 1'b0);
	end
end
endgenerate
`endif

`endif











integer	   ram_idx;
integer	   ram_idx_inc;
`ifdef NDS_L2C_BIU_DATA_WIDTH
localparam BIU_DATA_WIDTH	= `NDS_L2C_BIU_DATA_WIDTH;
`else
localparam BIU_DATA_WIDTH	= `NDS_BIU_DATA_WIDTH;
`endif
localparam BIU_DATA_MSB		= BIU_DATA_WIDTH - 1;
localparam BIU_DATA_RATIO	= BIU_DATA_WIDTH/32;
generate
reg [31:0] ram_word[0:(BIU_DATA_RATIO-1)];
reg [BIU_DATA_MSB+32:0] mem_data;
always @(posedge X_por_b) begin
	$display("%0t:%m:INFO:Initialize RAM with NDSROM.dat content.", $time);
	for (ram_idx = 0; ram_idx < IMAGE_SIZE; ram_idx = ram_idx + BIU_DATA_RATIO) begin
		for (ram_idx_inc = 0; ram_idx_inc < BIU_DATA_RATIO; ram_idx_inc = ram_idx_inc + 1) begin
			ram_word[ram_idx_inc] = ((^data[ram_idx + ram_idx_inc]) === 1'bx) ? 32'h0 : data[ram_idx + ram_idx_inc];
			mem_data[BIU_DATA_MSB+32:0] = {
					ram_word[ram_idx_inc][7:0],
					ram_word[ram_idx_inc][15:8],
					ram_word[ram_idx_inc][23:16],
					ram_word[ram_idx_inc][31:24],
					mem_data[BIU_DATA_MSB+32:32]};
		end
		//debugger
		`NDS_BENCH_TOP.u_sram_debugger.ram_inst.mem[ram_idx/BIU_DATA_RATIO] = mem_data[BIU_DATA_MSB+32:32];
		`ifndef NDS_SYN
			`NDS_RAM[ram_idx/BIU_DATA_RATIO] = mem_data[BIU_DATA_MSB+32:32];				
		`endif
	end
end
endgenerate

`ifdef NDS_SYN
initial begin
$readmemh("rom_hex/bank0_128.hex", `NDS_PLATFORM_CORE.ae350_ram_subsystem.BANK[0].u_sram_bank.uut.mem_core_array);
$readmemh("rom_hex/bank1_128.hex", `NDS_PLATFORM_CORE.ae350_ram_subsystem.BANK[1].u_sram_bank.uut.mem_core_array);
$readmemh("rom_hex/bank2_128.hex", `NDS_PLATFORM_CORE.ae350_ram_subsystem.BANK[2].u_sram_bank.uut.mem_core_array);
$readmemh("rom_hex/bank3_128.hex", `NDS_PLATFORM_CORE.ae350_ram_subsystem.BANK[3].u_sram_bank.uut.mem_core_array);
$readmemh("rom_hex/bank4_128.hex", `NDS_PLATFORM_CORE.ae350_ram_subsystem.BANK[4].u_sram_bank.uut.mem_core_array);
$readmemh("rom_hex/bank5_128.hex", `NDS_PLATFORM_CORE.ae350_ram_subsystem.BANK[5].u_sram_bank.uut.mem_core_array);
$readmemh("rom_hex/bank6_128.hex", `NDS_PLATFORM_CORE.ae350_ram_subsystem.BANK[6].u_sram_bank.uut.mem_core_array);
$readmemh("rom_hex/bank7_128.hex", `NDS_PLATFORM_CORE.ae350_ram_subsystem.BANK[7].u_sram_bank.uut.mem_core_array);
end
`endif



wire u_plic_support = `NDS_CPU_SUBSYSTEM.u_plic.VECTOR_PLIC_SUPPORT == "yes";
wire c_plic_support = `NDS_VECTOR_PLIC_SUPPORT_INT == `NDS_CFG_YES;
initial begin
	#10
	if ( (u_plic_support && ~c_plic_support) || ( ~u_plic_support && c_plic_support) ) begin
		#5;
		$display("%0t:ipipe:%0d:ERROR: VECTOR_PLIC_SUPPORT not match, support parameter in plic:%0d, in core_top:%0d", $time, 0, u_plic_support, c_plic_support);
		$finish;
	end
end






// synthesis translate_on

`ifdef AE350_SPI1_SUPPORT
`ifndef NDS_SPI_SLAVE_TEST
`ifndef NDS_SPI_3LINE_EPD
always @(posedge X_por_b) begin
	copy_image_to_spi_rom;
end

task copy_image_to_spi_rom;
parameter LOADER_SIZE = 32'h1000;
parameter SPI_BASE    = {`SAMPLE_AE350_SMU_RESET_VECTOR_HI_DEFAULT, `SAMPLE_AE350_SMU_RESET_VECTOR_LO_DEFAULT};
// synthesis translate_off
reg	[31:0]	data_32b;
reg	[31:0]	i;
reg 	[VALEN-1:0] vma_addr;
// synthesis translate_on

begin

	$display("%0t:%m:INFO:Copy loader data to SPI flash", $time);

	// synthesis translate_off
	vma_addr = {VALEN{1'h0}};
	vma_addr[31:0] = SPI_BASE[31:0];
	for (i = 32'h0; i < LOADER_SIZE; i = i + 32'h1) begin
		data_32b = loader_data[i];
		if (data_32b !== 32'hx) begin
			`SPI_FLASH_DATA[4*i  ][7:0] = data_32b[31:24];
			`SPI_FLASH_DATA[4*i+1][7:0] = data_32b[23:16];
			`SPI_FLASH_DATA[4*i+2][7:0] = data_32b[15:8];
			`SPI_FLASH_DATA[4*i+3][7:0] = data_32b[7:0];
			if (tb_debug_mon) begin
				$display("%0t:ipipe:ext update pa:%x mask:f data:%x", $time, vma_addr,
				{data_32b[7:0], data_32b[15:8], data_32b[23:16], data_32b[31:24]});
			end
		end
		vma_addr = vma_addr + 32'h4;
	end
	// synthesis translate_on
end
endtask
`endif
`endif
`endif


// synthesis translate_off
// synthesis translate_on



	// synthesis translate_off


	// synthesis translate_on

`ifdef INIT_CP_MODEL
initial begin: init_cp
        reg [31:0] i;
        $display("%0t:%m:INFO:Initialize CP RAM.", $time);
        for (i = 0; i < (1 << 20); i = i + 1) begin
                system.ae350_chip.cp_0.u_nds_ram_model_bwe.mem[i[31:1]] = {system.ae350_chip.cp_0.u_nds_ram_model_bwe.DATA_WIDTH{1'b0}};
                `ifdef NDS_IO_HART1
                system.ae350_chip.cp_1.u_nds_ram_model_bwe.mem[i[31:1]] = {system.ae350_chip.cp_1.u_nds_ram_model_bwe.DATA_WIDTH{1'b0}};
                `endif
                `ifdef NDS_IO_HART2
                system.ae350_chip.cp_2.u_nds_ram_model_bwe.mem[i[31:1]] = {system.ae350_chip.cp_2.u_nds_ram_model_bwe.DATA_WIDTH{1'b0}};
                `endif
                `ifdef NDS_IO_HART3
                system.ae350_chip.cp_3.u_nds_ram_model_bwe.mem[i[31:1]] = {system.ae350_chip.cp_3.u_nds_ram_model_bwe.DATA_WIDTH{1'b0}};
                `endif
                `ifdef NDS_IO_HART4
                system.ae350_chip.cp_4.u_nds_ram_model_bwe.mem[i[31:1]] = {system.ae350_chip.cp_4.u_nds_ram_model_bwe.DATA_WIDTH{1'b0}};
                `endif
                `ifdef NDS_IO_HART5
                system.ae350_chip.cp_5.u_nds_ram_model_bwe.mem[i[31:1]] = {system.ae350_chip.cp_5.u_nds_ram_model_bwe.DATA_WIDTH{1'b0}};
                `endif
                `ifdef NDS_IO_HART6
                system.ae350_chip.cp_6.u_nds_ram_model_bwe.mem[i[31:1]] = {system.ae350_chip.cp_6.u_nds_ram_model_bwe.DATA_WIDTH{1'b0}};
                `endif
                `ifdef NDS_IO_HART7
                system.ae350_chip.cp_7.u_nds_ram_model_bwe.mem[i[31:1]] = {system.ae350_chip.cp_7.u_nds_ram_model_bwe.DATA_WIDTH{1'b0}};
                `endif
        end
end
`endif

`ifdef NDS_SPI_SLAVE_TEST
reg [63:0] remap_reset_vector;

initial begin

		if (`ATCBMC300_ADDR_WIDTH == 64) begin : gen_atcbmc300_addr_eq_64
			remap_reset_vector = `ATCBMC300_SLV2_BASE_ADDR;
		end
		else begin : gen_atcbmc300_addr_lt_64
			remap_reset_vector = {{(64-`ATCBMC300_ADDR_WIDTH){1'b0}}, `ATCBMC300_SLV2_BASE_ADDR};
		end

	remap_reset_vector = remap_reset_vector + 64'h80;
	if (!(({`NDS_SMU.smu_apbif.RESET_VECTOR_HI_DEFAULT, `NDS_SMU.smu_apbif.RESET_VECTOR_DEFAULT} == remap_reset_vector) || (ILM_SIZE_KB == 0))) begin
		remap_reset_vector = `NDS_ILM_BASE + 64'h80;
	end

	force  `NDS_PLATFORM_CHIP.core_reset_vectors[63:0] = remap_reset_vector;
	$display("%0t:%m:INFO:force core0_reset_vector to 64'h%x when NDS_SPI_SLAVE_TEST is defined", $time, remap_reset_vector);
	`ifdef NDS_IO_HART1
		force  `NDS_PLATFORM_CHIP.core_reset_vectors[127:64] = remap_reset_vector;
		$display("%0t:%m:INFO:force core1_reset_vector to 64'h%x when NDS_SPI_SLAVE_TEST is defined", $time, remap_reset_vector);
	`endif
	`ifdef NDS_IO_HART2
		force  `NDS_PLATFORM_CHIP.core_reset_vectors[191:128] = remap_reset_vector;
		$display("%0t:%m:INFO:force core2_reset_vector to 64'h%x when NDS_SPI_SLAVE_TEST is defined", $time, remap_reset_vector);
	`endif
	`ifdef NDS_IO_HART3
		force  `NDS_PLATFORM_CHIP.core_reset_vectors[255:192] = remap_reset_vector;
		$display("%0t:%m:INFO:force core3_reset_vector to 64'h%x when NDS_SPI_SLAVE_TEST is defined", $time, remap_reset_vector);
	`endif
	`ifdef NDS_IO_HART4
		force  `NDS_PLATFORM_CHIP.core_reset_vectors[319:256] = remap_reset_vector;
		$display("%0t:%m:INFO:force core4_reset_vector to 64'h%x when NDS_SPI_SLAVE_TEST is defined", $time, remap_reset_vector);
	`endif
	`ifdef NDS_IO_HART5
		force  `NDS_PLATFORM_CHIP.core_reset_vectors[383:320] = remap_reset_vector;
		$display("%0t:%m:INFO:force core5_reset_vector to 64'h%x when NDS_SPI_SLAVE_TEST is defined", $time, remap_reset_vector);
	`endif
	`ifdef NDS_IO_HART6
		force  `NDS_PLATFORM_CHIP.core_reset_vectors[447:384] = remap_reset_vector;
		$display("%0t:%m:INFO:force core6_reset_vector to 64'h%x when NDS_SPI_SLAVE_TEST is defined", $time, remap_reset_vector);
	`endif
	`ifdef NDS_IO_HART7
		force  `NDS_PLATFORM_CHIP.core_reset_vectors[511:448] = remap_reset_vector;
		$display("%0t:%m:INFO:force core7_reset_vector to 64'h%x when NDS_SPI_SLAVE_TEST is defined", $time, remap_reset_vector);
	`endif
end
`endif

`define NDS_OSCH_PERIOD `AE350_OSCH_PERIOD
`ifdef NDS_TB_PAT
	`include "sync_tasks.vh"
	`include "nds_tb.pat"
`endif

`ifdef NDS_FAULT_INJECT
    `include "fault_inject.pat"
`endif

initial begin
        $timeformat(-9, 2, " ns");
end

function [6:0] ecc32_gen;
input   [31:0]  data;
reg     [6:0]   code;
begin
        code[0] =       data[30] ^ data[28] ^ data[26] ^ data[25] ^ data[23] ^ data[21] ^ data[19] ^ data[17] ^ data[15] ^ data[13]
                        ^ data[11] ^ data[10] ^ data[ 8] ^ data[ 6] ^ data[ 4] ^ data[ 3] ^ data[ 1] ^ data[ 0] ;
        code[1] =       data[31] ^ data[28] ^ data[27] ^ data[25] ^ data[24] ^ data[21] ^ data[20] ^ data[17] ^ data[16] ^ data[13]
                        ^ data[12] ^ data[10] ^ data[ 9] ^ data[ 6] ^ data[ 5] ^ data[ 3] ^ data[ 2] ^ data[ 0] ;
        code[2] =       data[31] ^ data[30] ^ data[29] ^ data[25] ^ data[24] ^ data[23] ^ data[22] ^ data[17] ^ data[16] ^ data[15]
                        ^ data[14] ^ data[10] ^ data[ 9] ^ data[ 8] ^ data[ 7] ^ data[ 3] ^ data[ 2] ^ data[ 1] ;
        code[3] =       data[25] ^ data[24] ^ data[23] ^ data[22] ^ data[21] ^ data[20] ^ data[19] ^ data[18] ^ data[10] ^ data[ 9]
                        ^ data[ 8] ^ data[ 7] ^ data[ 6] ^ data[ 5] ^ data[ 4] ;
        code[4] =       data[25] ^ data[24] ^ data[23] ^ data[22] ^ data[21] ^ data[20] ^ data[19] ^ data[18] ^ data[17] ^ data[16]
                        ^ data[15] ^ data[14] ^ data[13] ^ data[12] ^ data[11] ;
        code[5] =       (data[31] ^ data[30] ^ data[29] ^ data[28] ^ data[27] ^ data[26] );
        code[6] =       (data[29] ^ data[27] ^ data[26] ^ data[24] ^ data[23] ^ data[21] ^ data[18] ^ data[17] ^ data[14] ^ data[12]
                        ^ data[11] ^ data[10] ^ data[ 7] ^ data[ 5] ^ data[ 4] ^ data[ 2] ^ data[ 1] ^ data[ 0] );
        ecc32_gen = code;
end
endfunction

function [7:0] ecc64_gen;
input   [63:0]  data;
reg     [7:0]   code;
begin
        code[ 0] =        data[63] ^ data[61] ^ data[59] ^ data[57] ^ data[56] ^ data[54] ^ data[52] ^ data[50] ^ data[48] ^ data[46]
                        ^ data[44] ^ data[42] ^ data[40] ^ data[38] ^ data[36] ^ data[34] ^ data[32] ^ data[30] ^ data[28] ^ data[26]
                        ^ data[25] ^ data[23] ^ data[21] ^ data[19] ^ data[17] ^ data[15] ^ data[13] ^ data[11] ^ data[10] ^ data[ 8]
                        ^ data[ 6] ^ data[ 4] ^ data[ 3] ^ data[ 1] ^ data[ 0] ;
        code[ 1] =        data[63] ^ data[62] ^ data[59] ^ data[58] ^ data[56] ^ data[55] ^ data[52] ^ data[51] ^ data[48] ^ data[47]
                        ^ data[44] ^ data[43] ^ data[40] ^ data[39] ^ data[36] ^ data[35] ^ data[32] ^ data[31] ^ data[28] ^ data[27]
                        ^ data[25] ^ data[24] ^ data[21] ^ data[20] ^ data[17] ^ data[16] ^ data[13] ^ data[12] ^ data[10] ^ data[ 9]
                        ^ data[ 6] ^ data[ 5] ^ data[ 3] ^ data[ 2] ^ data[ 0] ;
        code[ 2] =        data[63] ^ data[62] ^ data[61] ^ data[60] ^ data[56] ^ data[55] ^ data[54] ^ data[53] ^ data[48] ^ data[47]
                        ^ data[46] ^ data[45] ^ data[40] ^ data[39] ^ data[38] ^ data[37] ^ data[32] ^ data[31] ^ data[30] ^ data[29]
                        ^ data[25] ^ data[24] ^ data[23] ^ data[22] ^ data[17] ^ data[16] ^ data[15] ^ data[14] ^ data[10] ^ data[ 9]
                        ^ data[ 8] ^ data[ 7] ^ data[ 3] ^ data[ 2] ^ data[ 1] ;
        code[ 3] =        data[56] ^ data[55] ^ data[54] ^ data[53] ^ data[52] ^ data[51] ^ data[50] ^ data[49] ^ data[40] ^ data[39]
                        ^ data[38] ^ data[37] ^ data[36] ^ data[35] ^ data[34] ^ data[33] ^ data[25] ^ data[24] ^ data[23] ^ data[22]
                        ^ data[21] ^ data[20] ^ data[19] ^ data[18] ^ data[10] ^ data[ 9] ^ data[ 8] ^ data[ 7] ^ data[ 6] ^ data[ 5]
                        ^ data[ 4] ;
        code[ 4] =        data[56] ^ data[55] ^ data[54] ^ data[53] ^ data[52] ^ data[51] ^ data[50] ^ data[49] ^ data[48] ^ data[47]
                        ^ data[46] ^ data[45] ^ data[44] ^ data[43] ^ data[42] ^ data[41] ^ data[25] ^ data[24] ^ data[23] ^ data[22]
                        ^ data[21] ^ data[20] ^ data[19] ^ data[18] ^ data[17] ^ data[16] ^ data[15] ^ data[14] ^ data[13] ^ data[12]
                        ^ data[11] ;
        code[ 5] =        data[56] ^ data[55] ^ data[54] ^ data[53] ^ data[52] ^ data[51] ^ data[50] ^ data[49] ^ data[48] ^ data[47]
                        ^ data[46] ^ data[45] ^ data[44] ^ data[43] ^ data[42] ^ data[41] ^ data[40] ^ data[39] ^ data[38] ^ data[37]
                        ^ data[36] ^ data[35] ^ data[34] ^ data[33] ^ data[32] ^ data[31] ^ data[30] ^ data[29] ^ data[28] ^ data[27]
                        ^ data[26] ;
        code[ 6] =      (data[63] ^ data[62] ^ data[61] ^ data[60] ^ data[59] ^ data[58] ^ data[57] );
        code[ 7] =      (data[63] ^ data[60] ^ data[58] ^ data[57] ^ data[56] ^ data[53] ^ data[51] ^ data[50] ^ data[47] ^ data[46]
                        ^ data[44] ^ data[41] ^ data[39] ^ data[38] ^ data[36] ^ data[33] ^ data[32] ^ data[29] ^ data[27] ^ data[26]
                        ^ data[24] ^ data[23] ^ data[21] ^ data[18] ^ data[17] ^ data[14] ^ data[12] ^ data[11] ^ data[10] ^ data[ 7]
                        ^ data[ 5] ^ data[ 4] ^ data[ 2] ^ data[ 1] ^ data[ 0] );
        ecc64_gen = code;
end
endfunction

function [3:0] parity32_gen;
input   [31:0]  data;
reg     [3:0]   code;
begin
        code[0] = ^data[7:0];
        code[1] = ^data[15:8];
        code[2] = ^data[23:16];
        code[3] = ^data[31:24];
        parity32_gen = code;
end
endfunction

function [7:0] parity64_gen;
input   [63:0]  data;
reg     [7:0]   code;
begin
        code[0] = ^data[7:0];
        code[1] = ^data[15:8];
        code[2] = ^data[23:16];
        code[3] = ^data[31:24];
        code[4] = ^data[39:32];
        code[5] = ^data[47:40];
        code[6] = ^data[55:48];
        code[7] = ^data[63:56];
        parity64_gen = code;
end
endfunction

`ifdef PLATFORM_DEBUG_PORT
genvar tapid;
generate
for (tapid = 0; tapid < JTAG_TAP_NUM; tapid += 1) begin : gen_jtag_taps
        if (tapid != DM_TAP_ID
        ) begin : gen_jtag_dummy_tap
                wire    tck     = `NDS_CHIP_AOPD.tap_tck [tapid];
                wire    trst    = `NDS_CHIP_AOPD.tap_trst[tapid];
                wire    tms     = `NDS_CHIP_AOPD.tap_tms [tapid];
                wire    tdi     = `NDS_CHIP_AOPD.tap_tdi [tapid];
                wire    tdo;
                `ifdef NDS_JTAG_DEVICE_MODEL
                        jtag_device dummy_tap (
                                .dbgi_n     (1'b1        ),
                                .edm_tck    (tck         ),
                                .edm_tdi    (tdi         ),
                                .edm_tms    (tms         ),
                                .edm_trst   (trst        ),
                                .jtagedm_ver(32'h0000063d),
                        .dbgack_n   (    ),
                        .edm_tdo    (tdo         )
                        );
                `else
                        assign tdo = tdi;
                `endif

                initial force `NDS_CHIP_AOPD.tap_tdo[tapid] = tdo;
        end
end
endgenerate
`endif

	
	bind ax45mpv_core_top instn_simple_pipe_mon instn_simple_pipe_mon (.*);



bind kv_core kv_define_macro_mon #(
	.CPUID(CPUID),
	.MIMPID(MIMPID),
	.ISA_BASE_INT(ISA_BASE_INT),
	.RVC_SUPPORT_INT(RVC_SUPPORT_INT),
	.RVN_SUPPORT_INT(RVN_SUPPORT_INT),
	.RVA_SUPPORT_INT(RVA_SUPPORT_INT),
	.RVB_SUPPORT_INT(RVB_SUPPORT_INT),
	.RVV_SUPPORT_INT(RVV_SUPPORT_INT),
	.QMAC_SUPPORT_INT(QMAC_SUPPORT_INT),
	.ACE_SUPPORT_INT(ACE_SUPPORT_INT),
	.ACE_STREAM_PORT(ACE_STREAM_PORT),
	.ACE_INST_FIFO_DEPTH(ACE_INST_FIFO_DEPTH),
	.DSP_SUPPORT_INT(DSP_SUPPORT_INT),
	.ACE_LS_SUPPORT_INT(ACE_LS_SUPPORT_INT),
	.ACE_GPR_2W_SUPPORT_INT(ACE_GPR_2W_SUPPORT_INT),
	.ACE_GPR_3R_SUPPORT_INT(ACE_GPR_3R_SUPPORT_INT),
	.SLAVE_PORT_SUPPORT_INT(SLAVE_PORT_SUPPORT_INT),
	.PC_GPR_PROBING_SUPPORT_INT(PC_GPR_PROBING_SUPPORT_INT),
	.VECTOR_PLIC_SUPPORT_INT(VECTOR_PLIC_SUPPORT_INT),
	.SLAVE_PORT_DATA_WIDTH(SLAVE_PORT_DATA_WIDTH),
	.SLAVE_PORT_ID_WIDTH(SLAVE_PORT_ID_WIDTH),
	.SLAVE_PORT_SOURCE_NUM(SLAVE_PORT_SOURCE_NUM),
	.SLAVE_PORT_ASYNC_SUPPORT(SLAVE_PORT_ASYNC_SUPPORT),
	.SLVP_PROTECTION_SUPPORT(SLVP_PROTECTION_SUPPORT),
	.SLV_ADDR_CODE_WIDTH(SLV_ADDR_CODE_WIDTH),
	.SLV_DATA_CODE_WIDTH(SLV_DATA_CODE_WIDTH),
	.SLV_CTRL_CODE_WIDTH(SLV_CTRL_CODE_WIDTH),
	.SLV_UTID_WIDTH(SLV_UTID_WIDTH),
	.VECTOR_SINT_SUPPORT_INT(VECTOR_SINT_SUPPORT_INT),
	.VECTOR_DOT_SUPPORT_INT(VECTOR_DOT_SUPPORT_INT),
	.VECTOR_PACKED_FP16_SUPPORT_INT(VECTOR_PACKED_FP16_SUPPORT_INT),
	.INT4_VECTOR_LOAD_SUPPORT_INT(INT4_VECTOR_LOAD_SUPPORT_INT),
	.LOCALINT_LCOFI(LOCALINT_LCOFI),
	.LOCALINT_SLPECC(LOCALINT_SLPECC),
	.LOCALINT_SBE(LOCALINT_SBE),
	.LOCALINT_HPMINT(LOCALINT_HPMINT),
	.LM_INTERFACE_INT(LM_INTERFACE_INT),
	.LM_ENABLE_CTRL_INT(LM_ENABLE_CTRL_INT),
	.ILM_SIZE_KB(ILM_SIZE_KB),
	.ILM_ECC_TYPE_INT(ILM_ECC_TYPE_INT),
	.ILM_DATA_WIDTH(ILM_DATA_WIDTH),
	.ILM_WAIT_PREFETCH(ILM_WAIT_PREFETCH),
	.DLM_SIZE_KB(DLM_SIZE_KB),
	.DLM_ECC_TYPE_INT(DLM_ECC_TYPE_INT),
	.DLM_DATA_WIDTH(DLM_DATA_WIDTH),
	.DCLS_TYPE(DCLS_TYPE),
	.EDC_AFTER_ECC(EDC_AFTER_ECC),
	.CACHE_LINE_SIZE(CACHE_LINE_SIZE),
	.ICACHE_SIZE_KB(ICACHE_SIZE_KB),
	.ICACHE_LRU_INT(ICACHE_LRU_INT),
	.ICACHE_WAY(ICACHE_WAY),
	.ICACHE_ECC_TYPE_INT(ICACHE_ECC_TYPE_INT),
	.ICACHE_FIRST_WORD_FIRST_INT(ICACHE_FIRST_WORD_FIRST_INT),
	.DCACHE_SIZE_KB(DCACHE_SIZE_KB),
	.DCACHE_LRU_INT(DCACHE_LRU_INT),
	.DCACHE_WAY(DCACHE_WAY),
	.DCACHE_ECC_TYPE_INT(DCACHE_ECC_TYPE_INT),
	.DCACHE_PREFETCH_SUPPORT_INT(DCACHE_PREFETCH_SUPPORT_INT),
	.WRITE_AROUND_SUPPORT_INT(WRITE_AROUND_SUPPORT_INT),
	.MSHR_DEPTH(MSHR_DEPTH),
	.DTAG_SOURCE_WIDTH(DTAG_SOURCE_WIDTH),
	.LSU_DATA_WIDTH(LSU_DATA_WIDTH),
	.LSU_MSHR_DEPTH(LSU_MSHR_DEPTH),
	.LSU_LOW_LATENCY(LSU_LOW_LATENCY),
	.LSU_NBLOAD_SUPPORT(LSU_NBLOAD_SUPPORT),
	.LSU_SB_DEPTH(LSU_SB_DEPTH),
	.LSU_RDB_WIDTH(LSU_RDB_WIDTH),
	.LSU_RDB_DEPTH(LSU_RDB_DEPTH),
	.DCU_DATA_WIDTH(DCU_DATA_WIDTH),
	.ICU_DATA_WIDTH(ICU_DATA_WIDTH),
	.FUSA_SUPPORT(FUSA_SUPPORT),
	.CM_SUPPORT_INT(CM_SUPPORT_INT),
	.CSR_COH_SUPPORT(CSR_COH_SUPPORT),
	.WPT_SUPPORT(WPT_SUPPORT),
	.DTAG_SUPPORT(DTAG_SUPPORT),
	.DCU_NOSH_SUPPORT(DCU_NOSH_SUPPORT),
	.PMA_NOSH_SUPPORT(PMA_NOSH_SUPPORT),
	.CLUSTER_SUPPORT_INT(CLUSTER_SUPPORT_INT),
	.L2C_CACHE_SIZE_KB(L2C_CACHE_SIZE_KB),
	.L2C_REG_BASE(L2C_REG_BASE),
	.IOCP_NUM(IOCP_NUM),
	.NCORE_CLUSTER(NCORE_CLUSTER),
	.VLEN(VLEN),
	.DLEN(DLEN),
	.ELEN(ELEN),
	.FELEN(FELEN),
	.VLS_DATA_WIDTH(VLS_DATA_WIDTH),
	.ASP_DATA_WIDTH(ASP_DATA_WIDTH),
	.SCPU_A_UW(SCPU_A_UW),
	.SCPU_C_UW(SCPU_C_UW),
	.SCPU_D_UW(SCPU_D_UW),
	.BIU_ADDR_CODE_WIDTH(BIU_ADDR_CODE_WIDTH),
	.BIU_DATA_CODE_WIDTH(BIU_DATA_CODE_WIDTH),
	.BIU_CTRL_CODE_WIDTH(BIU_CTRL_CODE_WIDTH),
	.BIU_UTID_WIDTH(BIU_UTID_WIDTH),
	.SOURCE_CODE_WIDTH(SOURCE_CODE_WIDTH),
	.BUS_PROTECTION_SUPPORT(BUS_PROTECTION_SUPPORT),
	.LSU_PREFETCH_INT(LSU_PREFETCH_INT),
	.FENCE_FLUSH_DCACHE_INT(FENCE_FLUSH_DCACHE_INT),
	.POWERBRAKE_SUPPORT_INT(POWERBRAKE_SUPPORT_INT),
	.STACKSAFE_SUPPORT_INT(STACKSAFE_SUPPORT_INT),
	.CODENSE_SUPPORT_INT(CODENSE_SUPPORT_INT),
	.UNALIGNED_ACCESS_INT(UNALIGNED_ACCESS_INT),
	.FPU_TYPE_INT(FPU_TYPE_INT),
	.FP16_SUPPORT_INT(FP16_SUPPORT_INT),
	.BFLOAT16_SUPPORT_INT(BFLOAT16_SUPPORT_INT),
	.BFLOAT16_ARITH_SUPPORT(BFLOAT16_ARITH_SUPPORT),
	.ZFBFMIN_SUPPORT_INT(ZFBFMIN_SUPPORT_INT),
	.ZVFBFMIN_SUPPORT_INT(ZVFBFMIN_SUPPORT_INT),
	.ZVFBFWMA_SUPPORT_INT(ZVFBFWMA_SUPPORT_INT),
	.ZILSD_SUPPORT(ZILSD_SUPPORT),
	.ZCMLSD_SUPPORT(ZCMLSD_SUPPORT),
	.PUSHPOP_TYPE(PUSHPOP_TYPE),
	.MMU_SCHEME_INT(MMU_SCHEME_INT),
	.ITLB_ENTRIES(ITLB_ENTRIES),
	.DTLB_ENTRIES(DTLB_ENTRIES),
	.STLB_ENTRIES(STLB_ENTRIES),
	.STLB_SP_ENTRIES(STLB_SP_ENTRIES),
	.STLB_ECC_TYPE(STLB_ECC_TYPE),
	.PALEN(PALEN),
	.PMP_ENTRIES(PMP_ENTRIES),
	.PMP_GRANULARITY(PMP_GRANULARITY),
	.PMA_ENTRIES(PMA_ENTRIES),
	.BIU_ASYNC_SUPPORT(BIU_ASYNC_SUPPORT),
	.BIU_ADDR_WIDTH(BIU_ADDR_WIDTH),
	.BIU_DATA_WIDTH(BIU_DATA_WIDTH),
	.BIU_PATH_X2_INT(BIU_PATH_X2_INT),
	.BIU_ID_WIDTH(BIU_ID_WIDTH),
	.PPI_SIZE_KB(PPI_SIZE_KB),
	.PPI_REGION_BASE(PPI_REGION_BASE),
	.PPI_ADDR_WIDTH(PPI_ADDR_WIDTH),
	.PPI_DATA_WIDTH(PPI_DATA_WIDTH),
	.PPI_ID_WIDTH(PPI_ID_WIDTH),
	.PPI_ASYNC_SUPPORT(PPI_ASYNC_SUPPORT),
	.PPI_INTERFACE(PPI_INTERFACE),
	.PPI_DATA_CODE_WIDTH(PPI_DATA_CODE_WIDTH),
	.PPI_ADDR_CODE_WIDTH(PPI_ADDR_CODE_WIDTH),
	.PPI_CTRL_CODE_WIDTH(PPI_CTRL_CODE_WIDTH),
	.PPI_UTID_WIDTH(PPI_UTID_WIDTH),
	.SPP_SIZE_KB(SPP_SIZE_KB),
	.SPP_REGION_BASE(SPP_REGION_BASE),
	.FLASHIF0_SIZE_KB(FLASHIF0_SIZE_KB),
	.FLASHIF0_REGION_BASE(FLASHIF0_REGION_BASE),
	.HVM_SIZE_KB(HVM_SIZE_KB),
	.HVM_BASE(HVM_BASE),
	.HVM_BANKS(HVM_BANKS),
	.HVM_ADDR_BANK_BIT(HVM_ADDR_BANK_BIT),
	.HVM_ADDR_WIDTH(HVM_ADDR_WIDTH),
	.HVM_SUBP_SUPPORT(HVM_SUBP_SUPPORT),
	.TL_SINK_WIDTH(TL_SINK_WIDTH),
	.L2_SOURCE_WIDTH(L2_SOURCE_WIDTH),
	.L2_ADDR_WIDTH(L2_ADDR_WIDTH),
	.L2_DATA_WIDTH(L2_DATA_WIDTH),
	.CORE_BRG_ASYNC(CORE_BRG_ASYNC),
	.CORE_BRG_REG(CORE_BRG_REG),
	.SYNC_STAGE(SYNC_STAGE),
	.ASYNC_FIFO_READ_SYNC(ASYNC_FIFO_READ_SYNC),
	.NUM_PRIVILEGE_LEVELS(NUM_PRIVILEGE_LEVELS),
	.SSCOFPMF_SUPPORT(SSCOFPMF_SUPPORT),
	.NUM_DLM_BANKS(NUM_DLM_BANKS),
	.BRANCH_PREDICTION_INT(BRANCH_PREDICTION_INT),
	.DEBUG_SUPPORT_INT(DEBUG_SUPPORT_INT),
	.NUM_TRIGGER(NUM_TRIGGER),
	.TRACE_INTERFACE_INT(TRACE_INTERFACE_INT),
	.TRAP_STATUS_INTERFACE(TRAP_STATUS_INTERFACE),
	.PERFORMANCE_MONITOR_INT(PERFORMANCE_MONITOR_INT),
	.MULTIPLIER_INT(MULTIPLIER_INT),
	.ILM_BASE(ILM_BASE),
	.DLM_BASE(DLM_BASE),
	.DEBUG_VEC(DEBUG_VEC),
	.DEVICE_REGION0_BASE(DEVICE_REGION0_BASE),
	.DEVICE_REGION0_MASK(DEVICE_REGION0_MASK),
	.DEVICE_REGION1_BASE(DEVICE_REGION1_BASE),
	.DEVICE_REGION1_MASK(DEVICE_REGION1_MASK),
	.DEVICE_REGION2_BASE(DEVICE_REGION2_BASE),
	.DEVICE_REGION2_MASK(DEVICE_REGION2_MASK),
	.DEVICE_REGION3_BASE(DEVICE_REGION3_BASE),
	.DEVICE_REGION3_MASK(DEVICE_REGION3_MASK),
	.DEVICE_REGION4_BASE(DEVICE_REGION4_BASE),
	.DEVICE_REGION4_MASK(DEVICE_REGION4_MASK),
	.DEVICE_REGION5_BASE(DEVICE_REGION5_BASE),
	.DEVICE_REGION5_MASK(DEVICE_REGION5_MASK),
	.DEVICE_REGION6_BASE(DEVICE_REGION6_BASE),
	.DEVICE_REGION6_MASK(DEVICE_REGION6_MASK),
	.DEVICE_REGION7_BASE(DEVICE_REGION7_BASE),
	.DEVICE_REGION7_MASK(DEVICE_REGION7_MASK),
	.WRITETHROUGH_REGION0_BASE(WRITETHROUGH_REGION0_BASE),
	.WRITETHROUGH_REGION0_MASK(WRITETHROUGH_REGION0_MASK),
	.WRITETHROUGH_REGION1_BASE(WRITETHROUGH_REGION1_BASE),
	.WRITETHROUGH_REGION1_MASK(WRITETHROUGH_REGION1_MASK),
	.WRITETHROUGH_REGION2_BASE(WRITETHROUGH_REGION2_BASE),
	.WRITETHROUGH_REGION2_MASK(WRITETHROUGH_REGION2_MASK),
	.WRITETHROUGH_REGION3_BASE(WRITETHROUGH_REGION3_BASE),
	.WRITETHROUGH_REGION3_MASK(WRITETHROUGH_REGION3_MASK),
	.WRITETHROUGH_REGION4_BASE(WRITETHROUGH_REGION4_BASE),
	.WRITETHROUGH_REGION4_MASK(WRITETHROUGH_REGION4_MASK),
	.WRITETHROUGH_REGION5_BASE(WRITETHROUGH_REGION5_BASE),
	.WRITETHROUGH_REGION5_MASK(WRITETHROUGH_REGION5_MASK),
	.WRITETHROUGH_REGION6_BASE(WRITETHROUGH_REGION6_BASE),
	.WRITETHROUGH_REGION6_MASK(WRITETHROUGH_REGION6_MASK),
	.WRITETHROUGH_REGION7_BASE(WRITETHROUGH_REGION7_BASE),
	.WRITETHROUGH_REGION7_MASK(WRITETHROUGH_REGION7_MASK),
	.BTB_RAM_ADDR_WIDTH(BTB_RAM_ADDR_WIDTH),
	.BTB_RAM_DATA_WIDTH(BTB_RAM_DATA_WIDTH),
	.BTB_ECC_TYPE(BTB_ECC_TYPE),
	.STLB_RAM_AW(STLB_RAM_AW),
	.STLB_RAM_DW(STLB_RAM_DW),
	.STLB_TAG_RAM_DW(STLB_TAG_RAM_DW),
	.STLB_DATA_RAM_DW(STLB_DATA_RAM_DW),
	.ICACHE_TAG_RAM_AW(ICACHE_TAG_RAM_AW),
	.ICACHE_TAG_RAM_DW(ICACHE_TAG_RAM_DW),
	.ICACHE_DATA_RAM_AW(ICACHE_DATA_RAM_AW),
	.ICACHE_DATA_RAM_DW(ICACHE_DATA_RAM_DW),
	.DCACHE_TAG_RAM_AW(DCACHE_TAG_RAM_AW),
	.DCACHE_TAG_RAM_DW(DCACHE_TAG_RAM_DW),
	.DCACHE_DATA_RAM_AW(DCACHE_DATA_RAM_AW),
	.DCACHE_DATA_RAM_DW(DCACHE_DATA_RAM_DW),
	.DCACHE_DATA_RAM_BWEW(DCACHE_DATA_RAM_BWEW),
	.DCACHE_WPT_RAM_AW(DCACHE_WPT_RAM_AW),
	.DCACHE_WPT_RAM_DW(DCACHE_WPT_RAM_DW),
	.DCACHE_WPT_RAM_BWEW(DCACHE_WPT_RAM_BWEW),
	.DLM_AW(DLM_AW),
	.DLM_RAM_AW(DLM_RAM_AW),
	.DLM_RAM_DW(DLM_RAM_DW),
	.DLM_RAM_BWEW(DLM_RAM_BWEW),
	.DLM_WAIT_CYCLE(DLM_WAIT_CYCLE),
	.ILM_AW(ILM_AW),
	.ILM_RAM_AW(ILM_RAM_AW),
	.ILM_RAM_DW(ILM_RAM_DW),
	.ILM_RAM_BWEW(ILM_RAM_BWEW),
	.ILM_WAIT_CYCLE(ILM_WAIT_CYCLE),
	.ISA_GP_INT(ISA_GP_INT),
	.ISA_LEA_INT(ISA_LEA_INT),
	.ISA_BEQC_INT(ISA_BEQC_INT),
	.ISA_BBZ_INT(ISA_BBZ_INT),
	.ISA_BFO_INT(ISA_BFO_INT),
	.ISA_STR_INT(ISA_STR_INT),
	.RAR_SUPPORT(RAR_SUPPORT),
	.LM_QOS_SUPPORT(LM_QOS_SUPPORT),
	.PFM_EVENT_WIDTH(PFM_EVENT_WIDTH)
) u_define_macro_mon_mon (.*);

`ifdef NDS_SYN
assign system.ae350_chip.ae350_pin.IO_RTE_pad.IRTE   = 1'b0;
assign system.ae350_chip.ae350_pin.PLL1_RTE_pad.IRTE = 1'b0;
assign system.ae350_chip.ae350_pin.PLL2_RTE_pad.IRTE = 1'b0;
`endif

`ifdef TEST_INT
//interrupt test
initial begin
	wait (system.ae350_chip.ae350_aopd.sample_ae350_smu.smu_apbif.ipclk_div[15:8] == 8'hff)
	force system.ae350_chip.ae350_vcpu_cluster_subsystem.int_src[63:60] = 4'b1111;
	#5ns;
	force system.ae350_chip.ae350_vcpu_cluster_subsystem.int_src[63:60] = 4'b0000;
end
`endif

`ifdef BYPASS_FLASH
// initial begin
// 	force system.ae350_chip.ae350_vcpu_cluster_subsystem.hart0_reset_vector[31:0] = 32'h00000000;
// 	force system.ae350_chip.ae350_vcpu_cluster_subsystem.hart1_reset_vector[31:0] = 32'h00000000;
// 	force system.ae350_chip.ae350_vcpu_cluster_subsystem.hart2_reset_vector[31:0] = 32'h00000000;
// 	force system.ae350_chip.ae350_vcpu_cluster_subsystem.hart3_reset_vector[31:0] = 32'h00000000;
// 	force system.ae350_chip.ae350_vcpu_cluster_subsystem.hart4_reset_vector[31:0] = 32'h00000000;
// 	force system.ae350_chip.ae350_vcpu_cluster_subsystem.hart5_reset_vector[31:0] = 32'h00000000;
// 	force system.ae350_chip.ae350_vcpu_cluster_subsystem.hart6_reset_vector[31:0] = 32'h00000000;
// 	force system.ae350_chip.ae350_vcpu_cluster_subsystem.hart7_reset_vector[31:0] = 32'h00000000;
// end
`endif

`ifdef EMU_PLL
reg pll1_clk_vir;
reg pll2_clk_vir;
initial begin
	force system.ae350_chip.ae350_aopd.sample_ae350_clkgen.pll1_clk = pll1_clk_vir;
        pll1_clk_vir = 1'b0;
        forever
                #(0.625)   pll1_clk_vir = ~pll1_clk_vir;
end
initial begin
	force system.ae350_chip.ae350_aopd.sample_ae350_clkgen.pll2_clk = pll2_clk_vir;
        pll2_clk_vir = 1'b0;
        forever
                #(0.5) pll2_clk_vir = ~pll2_clk_vir;
end
`endif


initial begin
  wait (system.ae350_chip.X_gpio[15:0] === 16'hcafe);
  $display("[%0t] GPIO Asserted, Simulation OK !!!", $time);
  $finish;
end

initial begin
  wait (system.ae350_chip.X_gpio[15:0] === 16'hdead);
  $display("[%0t] GPIO Asserted, Simulation Error !!!", $time);
  $finish;
end


initial begin
  wait (|system.ae350_chip.ram_araddr[22:20] === 1'b1);
  $display("[%0t] SRAM : Out-Of-1MB !!!", $time);
`ifdef NDS_SYN
  $finish;
`endif
end

endmodule

