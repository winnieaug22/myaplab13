// Copyright (C) 2024, Andes Technology Corp. Confidential Proprietary

module ae350_vcpu_cluster_subsystem (
    hart1_wakeup_event,
    hart1_core_wfi_mode,
    hart1_dcache_disable_init,
    hart1_icache_disable_init,
    hart1_nmi,
    hart1_reset_vector,
    dmactive,
    dmi_haddr,
    dmi_hburst,
    dmi_hprot,
    dmi_hrdata,
    dmi_hready,
    dmi_hreadyout,
    dmi_hresp,
    dmi_hsel,
    dmi_hsize,
    dmi_htrans,
    dmi_hwdata,
    dmi_hwrite,
    dmi_resetn,
    core_clk,
    core_l2_resetn,
    core_resetn,
    dbg_srst_req,
    dc_clk,
    hart0_wakeup_event,
    lm_clk,
    slvp_resetn,
    test_rstn,
    vpu_clk,
    vpu_clk_en,
    vpu_vace_clk,
    vpu_vace_clk_en,
    vpu_valu_clk,
    vpu_valu_clk_en,
    vpu_vdiv_clk,
    vpu_vdiv_clk_en,
    vpu_vfdiv_clk,
    vpu_vfdiv_clk_en,
    vpu_vfmis_clk,
    vpu_vfmis_clk_en,
    vpu_vlsu_clk,
    vpu_vlsu_clk_en,
    vpu_vmac_clk,
    vpu_vmac_clk_en,
    vpu_vmask_clk,
    vpu_vmask_clk_en,
    vpu_vpermut_clk,
    vpu_vpermut_clk_en,
    vpu_vsp_clk,
    vpu_vsp_clk_en,
    hvm_clk,
    hvm_reset_n,
    mmio_araddr,
    mmio_arburst,
    mmio_arcache,
    mmio_arid,
    mmio_arlen,
    mmio_arlock,
    mmio_arprot,
    mmio_arready,
    mmio_arsize,
    mmio_arvalid,
    mmio_awaddr,
    mmio_awburst,
    mmio_awcache,
    mmio_awid,
    mmio_awlen,
    mmio_awlock,
    mmio_awprot,
    mmio_awready,
    mmio_awsize,
    mmio_awvalid,
    mmio_bid,
    mmio_bready,
    mmio_bresp,
    mmio_bvalid,
    mmio_rdata,
    mmio_rid,
    mmio_rlast,
    mmio_rready,
    mmio_rresp,
    mmio_rvalid,
    mmio_wdata,
    mmio_wlast,
    mmio_wready,
    mmio_wstrb,
    mmio_wvalid,
    aclk,
    aresetn,
    hart0_core_wfi_mode,
    hart0_dcache_disable_init,
    hart0_icache_disable_init,
    hart0_nmi,
    hart0_reset_vector,
    mem_araddr,
    mem_arburst,
    mem_arcache,
    mem_arid,
    mem_arlen,
    mem_arlock,
    mem_arprot,
    mem_arready,
    mem_arsize,
    mem_arvalid,
    mem_awaddr,
    mem_awburst,
    mem_awcache,
    mem_awid,
    mem_awlen,
    mem_awlock,
    mem_awprot,
    mem_awready,
    mem_awsize,
    mem_awvalid,
    mem_bid,
    mem_bready,
    mem_bresp,
    mem_bvalid,
    mem_rdata,
    mem_rid,
    mem_rlast,
    mem_rready,
    mem_rresp,
    mem_rvalid,
    mem_wdata,
    mem_wlast,
    mem_wready,
    mem_wstrb,
    mem_wvalid,
    scan_enable,
    axi_bus_clk_en,
    l2_clk,
    l2_resetn,
    test_mode,
    l2c_err_int,
    int_src,
    mtime_clk,
    por_rstn
);
localparam SLVPORT_DLM_SEL_BIT = 21;
localparam PALEN = 38;
localparam BIU_ADDR_WIDTH = 38;
localparam BIU_ADDR_MSB = 38 - 1;
localparam BIU_ASYNC_SUPPORT = 0;
localparam COMPLEX_BRG_TYPE = 1;
localparam XLEN = 64;
localparam VALEN = 39;
localparam ADDR_WIDTH = PALEN;
localparam ADDR_MSB = (ADDR_WIDTH - 1);
localparam RESET_VECTOR_WIDTH = (VALEN > 32) ? 64 : 32;
localparam BIU_DATA_WIDTH = 128;
localparam BIU_DATA_MSB = (BIU_DATA_WIDTH - 1);
localparam BIU_WSTRB_WIDTH = (BIU_DATA_WIDTH / 8);
localparam BIU_WSTRB_MSB = (BIU_WSTRB_WIDTH - 1);
localparam IOCP_ID_WIDTH = 13;
localparam SLVPORT_ID_WIDTH = 13;
localparam SLVPORT_DATA_WIDTH = 128;
localparam SLVPORT_DATA_MSB = (SLVPORT_DATA_WIDTH - 1);
localparam SLVPORT_WSTRB_WIDTH = (SLVPORT_DATA_WIDTH / 8);
localparam SLVPORT_WSTRB_MSB = (SLVPORT_WSTRB_WIDTH - 1);
localparam BIU_ID_WIDTH = 7;
localparam BIU_ID_MSB = (BIU_ID_WIDTH - 1);
localparam PPI_DATA_WIDTH = 64;
localparam PPI_ID_WIDTH = 2;
localparam VECTOR_PLIC_SUPPORT = "no";
localparam NCE_DATA_WIDTH = (BIU_DATA_WIDTH > 64) ? 64 : BIU_DATA_WIDTH;
localparam NCE_DATA_MSB = (NCE_DATA_WIDTH - 1);
localparam NCE_WSTRB_WIDTH = (NCE_DATA_WIDTH / 8);
localparam NCE_WSTRB_MSB = (NCE_WSTRB_WIDTH - 1);
localparam DM_SYS_DATA_WIDTH = (BIU_DATA_WIDTH > 128) ? 128 : BIU_DATA_WIDTH;
localparam DM_SYS_DATA_MSB = (DM_SYS_DATA_WIDTH - 1);
localparam DM_SYS_WSTRB_WIDTH = (DM_SYS_DATA_WIDTH / 8);
localparam DM_SYS_WSTRB_MSB = (DM_SYS_WSTRB_WIDTH - 1);
localparam SIZEUP_DS_DATA_WIDTH = BIU_DATA_WIDTH;
localparam SIZEUP_DS_DATA_SIZE = $unsigned($clog2(SIZEUP_DS_DATA_WIDTH)) - 3;
localparam SIZEUP_ADDR_WIDTH = SIZEUP_DS_DATA_SIZE;
localparam SIZEUP_ADDR_MSB = (SIZEUP_ADDR_WIDTH - 1);
localparam NHART = 2;
localparam DLM_RAM_AW = 1;
localparam DLM_RAM_DW = 1;
localparam DLM_RAM_BWEW = 1;
localparam ILM_RAM_AW = 1;
localparam ILM_RAM_DW = 1;
localparam ILM_RAM_BWEW = 1;
localparam ILM_ECC_SUPPORT = "none" == "ecc";
localparam ILM_TL_UL_RAM_NUM = (XLEN == 64) ? 1 : 2;
localparam ILM_TL_UL_AW = ILM_RAM_AW + 3;
localparam ILM_TL_UL_EW = ILM_ECC_SUPPORT ? (XLEN == 64) ? 8 : 7 : 1;
localparam ILM_TL_UL_RAM_AW = ILM_RAM_AW;
localparam ILM_TL_UL_RAM_DW = (XLEN == 64) ? ILM_ECC_SUPPORT ? 72 : 64 : ILM_ECC_SUPPORT ? 39 : 32;
localparam ILM_TL_UL_RAM_BWEW = (ILM_TL_UL_RAM_DW == 39) ? 5 : ILM_TL_UL_RAM_DW / 8;
localparam PLIC_HW_TARGET_NUM = NHART * 2;
localparam PLIC_SW_TARGET_NUM = NHART;
localparam ILM_HDATA_WIDTH = XLEN;
localparam DLM_HDATA_WIDTH = XLEN;
localparam PROGBUF_SIZE = 8;
localparam HALTGROUP_COUNT = 0;
localparam PLDM_SYS_BUS_ACCESS = "no";
localparam DMXTRIGGER_COUNT = 0;
localparam DMXTRIGGER_MSB = (DMXTRIGGER_COUNT > 0) ? DMXTRIGGER_COUNT - 1 : 0;
localparam SYNC_STAGE = 2;
localparam AWUSER_MSB = 0;
localparam ARUSER_MSB = 0;
localparam WUSER_MSB = 0;
localparam RUSER_MSB = 0;
localparam BUSER_MSB = 0;
localparam AWUSER_WIDTH = 1;
localparam ARUSER_WIDTH = 1;
localparam WUSER_WIDTH = 1;
localparam RUSER_WIDTH = 1;
localparam BUSER_WIDTH = 1;
output [5:0] hart1_wakeup_event;
output hart1_core_wfi_mode;
input hart1_dcache_disable_init;
input hart1_icache_disable_init;
input hart1_nmi;
input [(VALEN - 1):0] hart1_reset_vector;
output dmactive;
input [8:0] dmi_haddr;
input [2:0] dmi_hburst;
input [3:0] dmi_hprot;
output [31:0] dmi_hrdata;
input dmi_hready;
output dmi_hreadyout;
output [1:0] dmi_hresp;
input dmi_hsel;
input [2:0] dmi_hsize;
input [1:0] dmi_htrans;
input [31:0] dmi_hwdata;
input dmi_hwrite;
input dmi_resetn;
input [(NHART - 1):0] core_clk;
input [(NHART - 1):0] core_l2_resetn;
input [(NHART - 1):0] core_resetn;
output dbg_srst_req;
input [(NHART - 1):0] dc_clk;
output [5:0] hart0_wakeup_event;
input [(NHART - 1):0] lm_clk;
input [(NHART - 1):0] slvp_resetn;
input test_rstn;
input [(NHART - 1):0] vpu_clk;
output [(NHART - 1):0] vpu_clk_en;
input [(NHART - 1):0] vpu_vace_clk;
output [(NHART - 1):0] vpu_vace_clk_en;
input [(NHART - 1):0] vpu_valu_clk;
output [(NHART - 1):0] vpu_valu_clk_en;
input [(NHART - 1):0] vpu_vdiv_clk;
output [(NHART - 1):0] vpu_vdiv_clk_en;
input [(NHART - 1):0] vpu_vfdiv_clk;
output [(NHART - 1):0] vpu_vfdiv_clk_en;
input [(NHART - 1):0] vpu_vfmis_clk;
output [(NHART - 1):0] vpu_vfmis_clk_en;
input [(NHART - 1):0] vpu_vlsu_clk;
output [(NHART - 1):0] vpu_vlsu_clk_en;
input [(NHART - 1):0] vpu_vmac_clk;
output [(NHART - 1):0] vpu_vmac_clk_en;
input [(NHART - 1):0] vpu_vmask_clk;
output [(NHART - 1):0] vpu_vmask_clk_en;
input [(NHART - 1):0] vpu_vpermut_clk;
output [(NHART - 1):0] vpu_vpermut_clk_en;
input [(NHART - 1):0] vpu_vsp_clk;
output [(NHART - 1):0] vpu_vsp_clk_en;
input hvm_clk;
input hvm_reset_n;
output [ADDR_MSB:0] mmio_araddr;
output [1:0] mmio_arburst;
output [3:0] mmio_arcache;
output [BIU_ID_MSB:0] mmio_arid;
output [7:0] mmio_arlen;
output mmio_arlock;
output [2:0] mmio_arprot;
input mmio_arready;
output [2:0] mmio_arsize;
output mmio_arvalid;
output [ADDR_MSB:0] mmio_awaddr;
output [1:0] mmio_awburst;
output [3:0] mmio_awcache;
output [BIU_ID_MSB:0] mmio_awid;
output [7:0] mmio_awlen;
output mmio_awlock;
output [2:0] mmio_awprot;
input mmio_awready;
output [2:0] mmio_awsize;
output mmio_awvalid;
input [BIU_ID_MSB:0] mmio_bid;
output mmio_bready;
input [1:0] mmio_bresp;
input mmio_bvalid;
input [(BIU_DATA_WIDTH - 1):0] mmio_rdata;
input [BIU_ID_MSB:0] mmio_rid;
input mmio_rlast;
output mmio_rready;
input [1:0] mmio_rresp;
input mmio_rvalid;
output [(BIU_DATA_WIDTH - 1):0] mmio_wdata;
output mmio_wlast;
input mmio_wready;
output [((BIU_DATA_WIDTH / 8) - 1):0] mmio_wstrb;
output mmio_wvalid;
input aclk;
input aresetn;
output hart0_core_wfi_mode;
input hart0_dcache_disable_init;
input hart0_icache_disable_init;
input hart0_nmi;
input [(VALEN - 1):0] hart0_reset_vector;
output [ADDR_MSB:0] mem_araddr;
output [1:0] mem_arburst;
output [3:0] mem_arcache;
output [BIU_ID_MSB:0] mem_arid;
output [7:0] mem_arlen;
output mem_arlock;
output [2:0] mem_arprot;
input mem_arready;
output [2:0] mem_arsize;
output mem_arvalid;
output [ADDR_MSB:0] mem_awaddr;
output [1:0] mem_awburst;
output [3:0] mem_awcache;
output [BIU_ID_MSB:0] mem_awid;
output [7:0] mem_awlen;
output mem_awlock;
output [2:0] mem_awprot;
input mem_awready;
output [2:0] mem_awsize;
output mem_awvalid;
input [BIU_ID_MSB:0] mem_bid;
output mem_bready;
input [1:0] mem_bresp;
input mem_bvalid;
input [(BIU_DATA_WIDTH - 1):0] mem_rdata;
input [BIU_ID_MSB:0] mem_rid;
input mem_rlast;
output mem_rready;
input [1:0] mem_rresp;
input mem_rvalid;
output [(BIU_DATA_WIDTH - 1):0] mem_wdata;
output mem_wlast;
input mem_wready;
output [((BIU_DATA_WIDTH / 8) - 1):0] mem_wstrb;
output mem_wvalid;
input scan_enable;
input axi_bus_clk_en;
input l2_clk;
input l2_resetn;
input test_mode;
output l2c_err_int;
input [127:1] int_src;	//#CYC
input mtime_clk;
input por_rstn;


wire [ADDR_MSB:0] inter2sdn_araddr;
wire [1:0] inter2sdn_arburst;
wire [3:0] inter2sdn_arcache;
wire [BIU_ID_MSB:0] inter2sdn_arid;
wire [3:0] inter2sdn_arid_dummy;
wire [7:0] inter2sdn_arlen;
wire inter2sdn_arlock;
wire [2:0] inter2sdn_arprot;
wire [2:0] inter2sdn_arsize;
wire inter2sdn_arvalid;
wire [ADDR_MSB:0] inter2sdn_awaddr;
wire [1:0] inter2sdn_awburst;
wire [3:0] inter2sdn_awcache;
wire [BIU_ID_MSB:0] inter2sdn_awid;
wire [3:0] inter2sdn_awid_dummy;
wire [7:0] inter2sdn_awlen;
wire inter2sdn_awlock;
wire [2:0] inter2sdn_awprot;
wire [2:0] inter2sdn_awsize;
wire inter2sdn_awvalid;
wire inter2sdn_bready;
wire inter2sdn_rready;
wire [BIU_DATA_MSB:0] inter2sdn_wdata;
wire inter2sdn_wlast;
wire [BIU_WSTRB_MSB:0] inter2sdn_wstrb;
wire inter2sdn_wvalid;
wire inter2sdn_arready;
wire inter2sdn_awready;
wire [BIU_ID_MSB:0] inter2sdn_bid;
wire [3:0] inter2sdn_bid_dummy;
wire [1:0] inter2sdn_bresp;
wire inter2sdn_bvalid;
wire [BIU_DATA_MSB:0] inter2sdn_rdata;
wire [BIU_ID_MSB:0] inter2sdn_rid;
wire [3:0] inter2sdn_rid_dummy;
wire inter2sdn_rlast;
wire [1:0] inter2sdn_rresp;
wire inter2sdn_rvalid;
wire inter2sdn_wready;
wire core1_clk;
wire core1_dcu_clk;
wire [63:0] core1_hart_id;
wire core1_l2_clk;
wire core1_l2_reset_n;
wire core1_lm_clk;
wire core1_reset_n;
wire core1_slv1_clk;
wire core1_slv1_clk_en;
wire core1_slv_clk;
wire core1_slv_clk_en;
wire core1_slvp_reset_n;
wire hart1_ueip;
wire vpu1_clk;
wire vpu1_hvm_clk;
wire vpu1_vace_clk;
wire vpu1_valu_clk;
wire vpu1_vdiv_clk;
wire vpu1_vfdiv_clk;
wire vpu1_vfmis_clk;
wire vpu1_vlsu_clk;
wire vpu1_vmac_clk;
wire vpu1_vmask_clk;
wire vpu1_vpermut_clk;
wire vpu1_vsp_clk;
wire hart1_meiack;
wire hart1_seiack;
wire hart1_stoptime;
wire vpu1_clk_en;
wire vpu1_vace_clk_en;
wire vpu1_valu_clk_en;
wire vpu1_vdiv_clk_en;
wire vpu1_vfdiv_clk_en;
wire vpu1_vfmis_clk_en;
wire vpu1_vlsu_clk_en;
wire vpu1_vmac_clk_en;
wire vpu1_vmask_clk_en;
wire vpu1_vpermut_clk_en;
wire vpu1_vsp_clk_en;
wire hart1_debugint;
wire hart1_meip;
wire hart1_msip;
wire hart1_mtip;
wire hart1_resethaltreq;
wire hart1_seip;
wire core0_hart_halted;
wire core0_hart_unavail;
wire core0_hart_under_reset;
wire [ADDR_MSB:0] dm_araddr;
wire [1:0] dm_arburst;
wire [3:0] dm_arcache;
wire [7:0] dm_arlen;
wire dm_arlock;
wire [2:0] dm_arprot;
wire [2:0] dm_arsize;
wire [ADDR_MSB:0] dm_awaddr;
wire [1:0] dm_awburst;
wire [3:0] dm_awcache;
wire [7:0] dm_awlen;
wire dm_awlock;
wire [2:0] dm_awprot;
wire [2:0] dm_awsize;
wire [1:0] dm_sup_bresp;
wire [NCE_DATA_MSB:0] dm_wdata;
wire dm_wlast;
wire [NCE_WSTRB_MSB:0] dm_wstrb;
wire dm_arvalid;
wire dm_awvalid;
wire dm_bready;
wire dm_rready;
wire dm_wvalid;
wire dm_sup_arready;
wire dm_sup_awready;
wire [BIU_ID_MSB:0] dm_sup_bid;
wire dm_sup_bvalid;
wire [DM_SYS_DATA_MSB:0] dm_sup_rdata;
wire [BIU_ID_MSB:0] dm_sup_rid;
wire dm_sup_rlast;
wire [1:0] dm_sup_rresp;
wire dm_sup_rvalid;
wire dm_sup_wready;
wire dm_arready;
wire dm_awready;
wire [1:0] dm_bresp;
wire dm_bvalid;
wire [NCE_DATA_MSB:0] dm_rdata;
wire dm_rlast;
wire [1:0] dm_rresp;
wire dm_rvalid;
wire [ADDR_MSB:0] dm_sup_araddr;
wire [1:0] dm_sup_arburst;
wire [3:0] dm_sup_arcache;
wire [BIU_ID_MSB:0] dm_sup_arid;
wire [7:0] dm_sup_arlen;
wire dm_sup_arlock;
wire [2:0] dm_sup_arprot;
wire [2:0] dm_sup_arsize;
wire dm_sup_arvalid;
wire [ADDR_MSB:0] dm_sup_awaddr;
wire [1:0] dm_sup_awburst;
wire [3:0] dm_sup_awcache;
wire [BIU_ID_MSB:0] dm_sup_awid;
wire [7:0] dm_sup_awlen;
wire dm_sup_awlock;
wire [2:0] dm_sup_awprot;
wire [2:0] dm_sup_awsize;
wire dm_sup_awvalid;
wire dm_sup_bready;
wire dm_sup_rready;
wire [DM_SYS_DATA_MSB:0] dm_sup_wdata;
wire dm_sup_wlast;
wire [DM_SYS_WSTRB_MSB:0] dm_sup_wstrb;
wire dm_sup_wvalid;
wire dm_wready;
wire ndmreset;
wire [3:0] nds_unused_dm_bid;
wire [(NCE_DATA_WIDTH - 1):0] nds_unused_dm_hrdata;
wire nds_unused_dm_hreadyout;
wire [1:0] nds_unused_dm_hresp;
wire [3:0] nds_unused_dm_rid;
wire [(ADDR_WIDTH - 1):0] nds_unused_dm_sup_haddr;
wire [2:0] nds_unused_dm_sup_hburst;
wire nds_unused_dm_sup_hbusreq;
wire [3:0] nds_unused_dm_sup_hprot;
wire [2:0] nds_unused_dm_sup_hsize;
wire [1:0] nds_unused_dm_sup_htrans;
wire [(DM_SYS_DATA_WIDTH - 1):0] nds_unused_dm_sup_hwdata;
wire nds_unused_dm_sup_hwrite;
wire [DMXTRIGGER_MSB:0] nds_unused_xtrigger_halt_out;
wire [DMXTRIGGER_MSB:0] nds_unused_xtrigger_resume_out;
wire l2c_err_int_int;
wire l2c_bank0_data_ram_clk;
wire l2c_bank0_data_ram_clk_en;
wire l2c_bank1_data_ram_clk;
wire l2c_bank1_data_ram_clk_en;
wire [3:0] nds_unused_plicsw_bid;
wire [(NCE_DATA_WIDTH - 1):0] nds_unused_plicsw_hrdata;
wire nds_unused_plicsw_hreadyout;
wire [1:0] nds_unused_plicsw_hresp;
wire [3:0] nds_unused_plicsw_rid;
wire [9:0] nds_unused_plicsw_t0_eiid;
wire [9:0] nds_unused_plicsw_t10_eiid;
wire nds_unused_plicsw_t10_eip;
wire [9:0] nds_unused_plicsw_t11_eiid;
wire nds_unused_plicsw_t11_eip;
wire [9:0] nds_unused_plicsw_t12_eiid;
wire nds_unused_plicsw_t12_eip;
wire [9:0] nds_unused_plicsw_t13_eiid;
wire nds_unused_plicsw_t13_eip;
wire [9:0] nds_unused_plicsw_t14_eiid;
wire nds_unused_plicsw_t14_eip;
wire [9:0] nds_unused_plicsw_t15_eiid;
wire nds_unused_plicsw_t15_eip;
wire [9:0] nds_unused_plicsw_t1_eiid;
wire [9:0] nds_unused_plicsw_t2_eiid;
wire [9:0] nds_unused_plicsw_t3_eiid;
wire [9:0] nds_unused_plicsw_t4_eiid;
wire [9:0] nds_unused_plicsw_t5_eiid;
wire [9:0] nds_unused_plicsw_t6_eiid;
wire [9:0] nds_unused_plicsw_t7_eiid;
wire [9:0] nds_unused_plicsw_t8_eiid;
wire nds_unused_plicsw_t8_eip;
wire [9:0] nds_unused_plicsw_t9_eiid;
wire nds_unused_plicsw_t9_eip;
wire core1_hart_halted;
wire core1_hart_unavail;
wire core1_hart_under_reset;
wire [ADDR_MSB:0] dm_sys_araddr;
wire [1:0] dm_sys_arburst;
wire [3:0] dm_sys_arcache;
wire [BIU_ID_MSB:0] dm_sys_arid;
wire [7:0] dm_sys_arlen;
wire dm_sys_arlock;
wire [2:0] dm_sys_arprot;
wire dm_sys_arready;
wire [2:0] dm_sys_arsize;
wire [ADDR_MSB:0] dm_sys_awaddr;
wire [1:0] dm_sys_awburst;
wire [3:0] dm_sys_awcache;
wire [BIU_ID_MSB:0] dm_sys_awid;
wire [7:0] dm_sys_awlen;
wire dm_sys_awlock;
wire [2:0] dm_sys_awprot;
wire dm_sys_awready;
wire [2:0] dm_sys_awsize;
wire [BIU_ID_MSB:0] dm_sys_bid;
wire [1:0] dm_sys_bresp;
wire dm_sys_bvalid;
wire [(BIU_DATA_WIDTH - 1):0] dm_sys_rdata;
wire [BIU_ID_MSB:0] dm_sys_rid;
wire dm_sys_rlast;
wire [1:0] dm_sys_rresp;
wire dm_sys_rvalid;
wire dm_sys_wready;
wire dm_sys_arvalid;
wire dm_sys_awvalid;
wire dm_sys_bready;
wire dm_sys_rready;
wire [(BIU_DATA_WIDTH - 1):0] dm_sys_wdata;
wire dm_sys_wlast;
wire [((BIU_DATA_WIDTH / 8) - 1):0] dm_sys_wstrb;
wire dm_sys_wvalid;
wire core0_clk;
wire core0_dcu_clk;
wire [63:0] core0_hart_id;
wire core0_l2_clk;
wire core0_l2_reset_n;
wire core0_lm_clk;
wire core0_reset_n;
wire core0_slv1_clk;
wire core0_slv1_clk_en;
wire core0_slv_clk;
wire core0_slv_clk_en;
wire core0_slvp_reset_n;
wire [(NHART - 1):0] dm_hart_unavail;
wire [(NHART - 1):0] dm_hart_under_reset;
wire hart0_ueip;
wire [3:0] mmio_exmon_bid_dummy;
wire [3:0] mmio_exmon_rid_dummy;
wire [ADDR_MSB:0] plic_araddr;
wire [1:0] plic_arburst;
wire [3:0] plic_arcache;
wire [7:0] plic_arlen;
wire plic_arlock;
wire [2:0] plic_arprot;
wire [2:0] plic_arsize;
wire [ADDR_MSB:0] plic_awaddr;
wire [1:0] plic_awburst;
wire [3:0] plic_awcache;
wire [7:0] plic_awlen;
wire plic_awlock;
wire [2:0] plic_awprot;
wire [2:0] plic_awsize;
wire [NCE_DATA_MSB:0] plic_wdata;
wire plic_wlast;
wire [NCE_WSTRB_MSB:0] plic_wstrb;
wire [ADDR_MSB:0] plicsw_araddr;
wire [1:0] plicsw_arburst;
wire [3:0] plicsw_arcache;
wire [7:0] plicsw_arlen;
wire plicsw_arlock;
wire [2:0] plicsw_arprot;
wire [2:0] plicsw_arsize;
wire [ADDR_MSB:0] plicsw_awaddr;
wire [1:0] plicsw_awburst;
wire [3:0] plicsw_awcache;
wire [7:0] plicsw_awlen;
wire plicsw_awlock;
wire [2:0] plicsw_awprot;
wire [2:0] plicsw_awsize;
wire [NCE_DATA_MSB:0] plicsw_wdata;
wire plicsw_wlast;
wire [NCE_WSTRB_MSB:0] plicsw_wstrb;
wire [ADDR_MSB:0] plmt_araddr;
wire [1:0] plmt_arburst;
wire [3:0] plmt_arcache;
wire [7:0] plmt_arlen;
wire plmt_arlock;
wire [2:0] plmt_arprot;
wire [2:0] plmt_arsize;
wire [ADDR_MSB:0] plmt_awaddr;
wire [1:0] plmt_awburst;
wire [3:0] plmt_awcache;
wire [7:0] plmt_awlen;
wire plmt_awlock;
wire [2:0] plmt_awprot;
wire [2:0] plmt_awsize;
wire [NCE_DATA_MSB:0] plmt_wdata;
wire plmt_wlast;
wire [NCE_WSTRB_MSB:0] plmt_wstrb;
wire [BIU_ID_MSB + 4:0] sdn2busdec_arid;
wire [BIU_ID_MSB + 4:0] sdn2busdec_awid;
wire stoptime;
wire vpu0_clk;
wire vpu0_hvm_clk;
wire vpu0_vace_clk;
wire vpu0_valu_clk;
wire vpu0_vdiv_clk;
wire vpu0_vfdiv_clk;
wire vpu0_vfmis_clk;
wire vpu0_vlsu_clk;
wire vpu0_vmac_clk;
wire vpu0_vmask_clk;
wire vpu0_vpermut_clk;
wire vpu0_vsp_clk;
wire mmio_exmon_arready;
wire mmio_exmon_awready;
wire [(BIU_ID_WIDTH - 1):0] mmio_exmon_bid;
wire [1:0] mmio_exmon_bresp;
wire mmio_exmon_bvalid;
wire [(BIU_DATA_WIDTH - 1):0] mmio_exmon_rdata;
wire [(BIU_ID_WIDTH - 1):0] mmio_exmon_rid;
wire mmio_exmon_rlast;
wire [1:0] mmio_exmon_rresp;
wire mmio_exmon_rvalid;
wire mmio_exmon_wready;
wire [3:0] nds_unused_arqos;
wire [3:0] nds_unused_arregion;
wire [3:0] nds_unused_awqos;
wire [3:0] nds_unused_awregion;
wire axi_mmio_arready;
wire axi_mmio_awready;
wire [BIU_ID_MSB:0] axi_mmio_bid;
wire [1:0] axi_mmio_bresp;
wire axi_mmio_bvalid;
wire [(BIU_DATA_WIDTH - 1):0] axi_mmio_rdata;
wire [BIU_ID_MSB:0] axi_mmio_rid;
wire axi_mmio_rlast;
wire [1:0] axi_mmio_rresp;
wire axi_mmio_rvalid;
wire axi_mmio_wready;
wire [(ADDR_WIDTH - 1):0] mmio_exmon_araddr;
wire [1:0] mmio_exmon_arburst;
wire [3:0] mmio_exmon_arcache;
wire [(BIU_ID_WIDTH - 1):0] mmio_exmon_arid;
wire [3:0] mmio_exmon_arid_dummy;
wire [7:0] mmio_exmon_arlen;
wire mmio_exmon_arlock;
wire [2:0] mmio_exmon_arprot;
wire [2:0] mmio_exmon_arsize;
wire mmio_exmon_arvalid;
wire [(ADDR_WIDTH - 1):0] mmio_exmon_awaddr;
wire [1:0] mmio_exmon_awburst;
wire [3:0] mmio_exmon_awcache;
wire [(BIU_ID_WIDTH - 1):0] mmio_exmon_awid;
wire [3:0] mmio_exmon_awid_dummy;
wire [7:0] mmio_exmon_awlen;
wire mmio_exmon_awlock;
wire [2:0] mmio_exmon_awprot;
wire [2:0] mmio_exmon_awsize;
wire mmio_exmon_awvalid;
wire mmio_exmon_bready;
wire mmio_exmon_rready;
wire [(BIU_DATA_WIDTH - 1):0] mmio_exmon_wdata;
wire mmio_exmon_wlast;
wire [(BIU_DATA_WIDTH / 8) - 1:0] mmio_exmon_wstrb;
wire mmio_exmon_wvalid;
wire [ADDR_MSB:0] busdec2nce_araddr;
wire [1:0] busdec2nce_arburst;
wire [3:0] busdec2nce_arcache;
wire [7:0] busdec2nce_arlen;
wire busdec2nce_arlock;
wire [2:0] busdec2nce_arprot;
wire [2:0] busdec2nce_arsize;
wire [ADDR_MSB:0] busdec2nce_awaddr;
wire [1:0] busdec2nce_awburst;
wire [3:0] busdec2nce_awcache;
wire [7:0] busdec2nce_awlen;
wire busdec2nce_awlock;
wire [2:0] busdec2nce_awprot;
wire [2:0] busdec2nce_awsize;
wire [NCE_DATA_MSB:0] busdec2nce_wdata;
wire busdec2nce_wlast;
wire [NCE_WSTRB_MSB:0] busdec2nce_wstrb;
wire plic_arvalid;
wire plic_awvalid;
wire plic_bready;
wire plic_rready;
wire plic_wvalid;
wire plicsw_arvalid;
wire plicsw_awvalid;
wire plicsw_bready;
wire plicsw_rready;
wire plicsw_wvalid;
wire plmt_arvalid;
wire plmt_awvalid;
wire plmt_bready;
wire plmt_rready;
wire plmt_wvalid;
wire sdn2busdec_arready;
wire sdn2busdec_awready;
wire [BIU_ID_MSB + 4:0] sdn2busdec_bid;
wire [1:0] sdn2busdec_bresp;
wire sdn2busdec_bvalid;
wire [NCE_DATA_MSB:0] sdn2busdec_rdata;
wire [BIU_ID_MSB + 4:0] sdn2busdec_rid;
wire sdn2busdec_rlast;
wire [1:0] sdn2busdec_rresp;
wire sdn2busdec_rvalid;
wire sdn2busdec_wready;
wire [ADDR_MSB:0] sdn2busdec_araddr;
wire [1:0] sdn2busdec_arburst;
wire [3:0] sdn2busdec_arcache;
wire [7:0] sdn2busdec_arlen;
wire sdn2busdec_arlock;
wire [2:0] sdn2busdec_arprot;
wire [2:0] sdn2busdec_arsize;
wire sdn2busdec_arvalid;
wire [ADDR_MSB:0] sdn2busdec_awaddr;
wire [1:0] sdn2busdec_awburst;
wire [3:0] sdn2busdec_awcache;
wire [7:0] sdn2busdec_awlen;
wire sdn2busdec_awlock;
wire [2:0] sdn2busdec_awprot;
wire [2:0] sdn2busdec_awsize;
wire sdn2busdec_awvalid;
wire sdn2busdec_bready;
wire sdn2busdec_rready;
wire [NCE_DATA_MSB:0] sdn2busdec_wdata;
wire sdn2busdec_wlast;
wire [NCE_WSTRB_MSB:0] sdn2busdec_wstrb;
wire sdn2busdec_wvalid;
wire [ADDR_MSB:0] axi_mmio_araddr;
wire [1:0] axi_mmio_arburst;
wire [3:0] axi_mmio_arcache;
wire [BIU_ID_MSB:0] axi_mmio_arid;
wire [7:0] axi_mmio_arlen;
wire axi_mmio_arlock;
wire [2:0] axi_mmio_arprot;
wire [2:0] axi_mmio_arsize;
wire axi_mmio_arvalid;
wire [ADDR_MSB:0] axi_mmio_awaddr;
wire [1:0] axi_mmio_awburst;
wire [3:0] axi_mmio_awcache;
wire [BIU_ID_MSB:0] axi_mmio_awid;
wire [7:0] axi_mmio_awlen;
wire axi_mmio_awlock;
wire [2:0] axi_mmio_awprot;
wire [2:0] axi_mmio_awsize;
wire axi_mmio_awvalid;
wire axi_mmio_bready;
wire axi_mmio_rready;
wire [(BIU_DATA_WIDTH - 1):0] axi_mmio_wdata;
wire axi_mmio_wlast;
wire [((BIU_DATA_WIDTH / 8) - 1):0] axi_mmio_wstrb;
wire axi_mmio_wvalid;
wire hart0_meiack;
wire hart0_seiack;
wire hart0_stoptime;
wire vpu0_clk_en;
wire vpu0_vace_clk_en;
wire vpu0_valu_clk_en;
wire vpu0_vdiv_clk_en;
wire vpu0_vfdiv_clk_en;
wire vpu0_vfmis_clk_en;
wire vpu0_vlsu_clk_en;
wire vpu0_vmac_clk_en;
wire vpu0_vmask_clk_en;
wire vpu0_vpermut_clk_en;
wire vpu0_vsp_clk_en;
wire hart0_debugint;
wire plic_hart0_meiack;
wire plic_hart1_meiack;
wire plic_hart2_meiack;
wire plic_hart3_meiack;
wire plic_hart4_meiack;
wire plic_hart5_meiack;
wire plic_hart6_meiack;
wire plic_hart7_meiack;
wire hart0_meip;
wire hart0_msip;
wire hart0_mtip;
wire [(NHART - 1):0] dm_debugint;
wire [(NHART - 1):0] dm_resethaltreq;
wire [9:0] hart0_meiid;
wire [9:0] hart0_seiid;
wire [9:0] hart1_meiid;
wire [9:0] hart1_seiid;
wire [9:0] hart2_meiid;
wire [9:0] hart2_seiid;
wire [9:0] hart3_meiid;
wire [9:0] hart3_seiid;
wire [9:0] hart4_meiid;
wire [9:0] hart4_seiid;
wire [9:0] hart5_meiid;
wire [9:0] hart5_seiid;
wire [9:0] hart6_meiid;
wire [9:0] hart6_seiid;
wire [9:0] hart7_meiid;
wire [9:0] hart7_seiid;
wire [3:0] nds_unused_plic_bid;
wire [(NCE_DATA_WIDTH - 1):0] nds_unused_plic_hrdata;
wire nds_unused_plic_hreadyout;
wire [1:0] nds_unused_plic_hresp;
wire [3:0] nds_unused_plic_rid;
wire plic_arready;
wire plic_awready;
wire [1:0] plic_bresp;
wire plic_bvalid;
wire plic_hart0_meip;
wire plic_hart0_seip;
wire plic_hart1_meip;
wire plic_hart1_seip;
wire plic_hart2_meip;
wire plic_hart2_seip;
wire plic_hart3_meip;
wire plic_hart3_seip;
wire plic_hart4_meip;
wire plic_hart4_seip;
wire plic_hart5_meip;
wire plic_hart5_seip;
wire plic_hart6_meip;
wire plic_hart6_seip;
wire plic_hart7_meip;
wire plic_hart7_seip;
wire [NCE_DATA_MSB:0] plic_rdata;
wire plic_rlast;
wire [1:0] plic_rresp;
wire plic_rvalid;
wire plic_wready;
wire plicsw_arready;
wire plicsw_awready;
wire [1:0] plicsw_bresp;
wire plicsw_bvalid;
wire plicsw_hart0_msip;
wire plicsw_hart1_msip;
wire plicsw_hart2_msip;
wire plicsw_hart3_msip;
wire plicsw_hart4_msip;
wire plicsw_hart5_msip;
wire plicsw_hart6_msip;
wire plicsw_hart7_msip;
wire [NCE_DATA_MSB:0] plicsw_rdata;
wire plicsw_rlast;
wire [1:0] plicsw_rresp;
wire plicsw_rvalid;
wire plicsw_wready;
wire [NHART - 1:0] mtip;
wire [3:0] nds_unused_plmt_bid;
wire [(NCE_DATA_WIDTH - 1):0] nds_unused_plmt_hrdata;
wire nds_unused_plmt_hreadyout;
wire [1:0] nds_unused_plmt_hresp;
wire [3:0] nds_unused_plmt_rid;
wire plmt_arready;
wire plmt_awready;
wire [1:0] plmt_bresp;
wire plmt_bvalid;
wire [NCE_DATA_MSB:0] plmt_rdata;
wire plmt_rlast;
wire [1:0] plmt_rresp;
wire plmt_rvalid;
wire plmt_wready;
wire hart0_resethaltreq;
wire plic_hart0_seiack;
wire plic_hart1_seiack;
wire plic_hart2_seiack;
wire plic_hart3_seiack;
wire plic_hart4_seiack;
wire plic_hart5_seiack;
wire plic_hart6_seiack;
wire plic_hart7_seiack;
wire hart0_seip;
wire plmt_hart0_stoptime;
wire plmt_hart1_stoptime;
wire plmt_hart2_stoptime;
wire plmt_hart3_stoptime;
wire plmt_hart4_stoptime;
wire plmt_hart5_stoptime;
wire plmt_hart6_stoptime;
wire plmt_hart7_stoptime;
assign hart0_wakeup_event = {plic_hart0_meip,plic_hart0_seip,1'b0,mtip[0],plicsw_hart0_msip,dm_debugint[0]};
assign hart0_ueip = 1'b0;
assign core0_clk = core_clk[0];
assign vpu0_clk = vpu_clk[0];
assign vpu0_vlsu_clk = vpu_vlsu_clk[0];
assign vpu0_valu_clk = vpu_valu_clk[0];
assign vpu0_vfmis_clk = vpu_vfmis_clk[0];
assign vpu0_vmac_clk = vpu_vmac_clk[0];
assign vpu0_vfdiv_clk = vpu_vfdiv_clk[0];
assign vpu0_vdiv_clk = vpu_vdiv_clk[0];
assign vpu0_vmask_clk = vpu_vmask_clk[0];
assign vpu0_vpermut_clk = vpu_vpermut_clk[0];
assign vpu0_vace_clk = vpu_vace_clk[0];
assign vpu0_vsp_clk = vpu_vsp_clk[0];
assign vpu0_hvm_clk = hvm_clk;
assign vpu_clk_en[0] = vpu0_clk_en;
assign vpu_vlsu_clk_en[0] = vpu0_vlsu_clk_en;
assign vpu_valu_clk_en[0] = vpu0_valu_clk_en;
assign vpu_vfmis_clk_en[0] = vpu0_vfmis_clk_en;
assign vpu_vmac_clk_en[0] = vpu0_vmac_clk_en;
assign vpu_vfdiv_clk_en[0] = vpu0_vfdiv_clk_en;
assign vpu_vdiv_clk_en[0] = vpu0_vdiv_clk_en;
assign vpu_vmask_clk_en[0] = vpu0_vmask_clk_en;
assign vpu_vpermut_clk_en[0] = vpu0_vpermut_clk_en;
assign vpu_vace_clk_en[0] = vpu0_vace_clk_en;
assign vpu_vsp_clk_en[0] = vpu0_vsp_clk_en;
assign core0_dcu_clk = dc_clk[0];
assign core0_reset_n = core_resetn[0];
assign core0_l2_reset_n = core_l2_resetn[0];
assign core0_l2_clk = l2_clk;
assign core0_slvp_reset_n = slvp_resetn[0];
assign core0_lm_clk = lm_clk[0];
assign core0_slv_clk = aclk;
assign core0_slv_clk_en = axi_bus_clk_en;
assign core0_slv1_clk = aclk;
assign core0_slv1_clk_en = axi_bus_clk_en;
assign core0_hart_id = 64'd0;
assign hart1_wakeup_event = {plic_hart1_meip,plic_hart1_seip,1'b0,mtip[1],plicsw_hart1_msip,dm_debugint[1]};
assign hart1_ueip = 1'b0;
assign core1_clk = core_clk[1];
assign vpu1_clk = vpu_clk[1];
assign vpu1_vlsu_clk = vpu_vlsu_clk[1];
assign vpu1_valu_clk = vpu_valu_clk[1];
assign vpu1_vfmis_clk = vpu_vfmis_clk[1];
assign vpu1_vmac_clk = vpu_vmac_clk[1];
assign vpu1_vfdiv_clk = vpu_vfdiv_clk[1];
assign vpu1_vdiv_clk = vpu_vdiv_clk[1];
assign vpu1_vmask_clk = vpu_vmask_clk[1];
assign vpu1_vpermut_clk = vpu_vpermut_clk[1];
assign vpu1_vace_clk = vpu_vace_clk[1];
assign vpu1_vsp_clk = vpu_vsp_clk[1];
assign vpu1_hvm_clk = hvm_clk;
assign vpu_clk_en[1] = vpu1_clk_en;
assign vpu_vlsu_clk_en[1] = vpu1_vlsu_clk_en;
assign vpu_valu_clk_en[1] = vpu1_valu_clk_en;
assign vpu_vfmis_clk_en[1] = vpu1_vfmis_clk_en;
assign vpu_vmac_clk_en[1] = vpu1_vmac_clk_en;
assign vpu_vfdiv_clk_en[1] = vpu1_vfdiv_clk_en;
assign vpu_vdiv_clk_en[1] = vpu1_vdiv_clk_en;
assign vpu_vmask_clk_en[1] = vpu1_vmask_clk_en;
assign vpu_vpermut_clk_en[1] = vpu1_vpermut_clk_en;
assign vpu_vace_clk_en[1] = vpu1_vace_clk_en;
assign vpu_vsp_clk_en[1] = vpu1_vsp_clk_en;
assign core1_dcu_clk = dc_clk[1];
assign core1_reset_n = core_resetn[1];
assign core1_l2_reset_n = core_l2_resetn[1];
assign core1_l2_clk = l2_clk;
assign core1_slvp_reset_n = slvp_resetn[1];
assign core1_lm_clk = lm_clk[1];
assign core1_slv_clk = aclk;
assign core1_slv_clk_en = axi_bus_clk_en;
assign core1_slv1_clk = aclk;
assign core1_slv1_clk_en = axi_bus_clk_en;
assign core1_hart_id = 64'd1;
wire nds_unused_core_l2_resetn = |core_l2_resetn;
assign mmio_exmon_bid_dummy = 4'b0;
assign mmio_exmon_rid_dummy = 4'b0;
generate
    if (BIU_DATA_WIDTH > NCE_DATA_WIDTH) begin:gen_connect_axi_sdn
        assign sdn2busdec_arid = {(BIU_ID_WIDTH + 4){1'b0}};
        assign sdn2busdec_awid = {(BIU_ID_WIDTH + 4){1'b0}};
    end
    else begin:gen_connect_axi
        assign sdn2busdec_arid = {inter2sdn_arid,inter2sdn_arid_dummy};
        assign sdn2busdec_araddr = inter2sdn_araddr;
        assign sdn2busdec_arburst = inter2sdn_arburst;
        assign sdn2busdec_arcache = inter2sdn_arcache;
        assign sdn2busdec_arlen = inter2sdn_arlen;
        assign sdn2busdec_arlock = inter2sdn_arlock;
        assign sdn2busdec_arprot = inter2sdn_arprot;
        assign sdn2busdec_arsize = inter2sdn_arsize;
        assign sdn2busdec_arvalid = inter2sdn_arvalid;
        assign inter2sdn_arready = sdn2busdec_arready;
        assign sdn2busdec_awid = {inter2sdn_awid,inter2sdn_awid_dummy};
        assign sdn2busdec_awaddr = inter2sdn_awaddr;
        assign sdn2busdec_awburst = inter2sdn_awburst;
        assign sdn2busdec_awcache = inter2sdn_awcache;
        assign sdn2busdec_awlen = inter2sdn_awlen;
        assign sdn2busdec_awlock = inter2sdn_awlock;
        assign sdn2busdec_awprot = inter2sdn_awprot;
        assign sdn2busdec_awsize = inter2sdn_awsize;
        assign sdn2busdec_awvalid = inter2sdn_awvalid;
        assign inter2sdn_awready = sdn2busdec_awready;
        assign {inter2sdn_bid,inter2sdn_bid_dummy} = sdn2busdec_bid;
        assign inter2sdn_bresp = sdn2busdec_bresp;
        assign inter2sdn_bvalid = sdn2busdec_bvalid;
        assign sdn2busdec_bready = inter2sdn_bready;
        assign {inter2sdn_rid,inter2sdn_rid_dummy} = sdn2busdec_rid;
        assign inter2sdn_rdata = sdn2busdec_rdata;
        assign inter2sdn_rlast = sdn2busdec_rlast;
        assign inter2sdn_rresp = sdn2busdec_rresp;
        assign inter2sdn_rvalid = sdn2busdec_rvalid;
        assign sdn2busdec_rready = inter2sdn_rready;
        assign sdn2busdec_wdata = inter2sdn_wdata;
        assign sdn2busdec_wlast = inter2sdn_wlast;
        assign sdn2busdec_wstrb = inter2sdn_wstrb;
        assign sdn2busdec_wvalid = inter2sdn_wvalid;
        assign inter2sdn_wready = sdn2busdec_wready;
    end
endgenerate
assign plic_awaddr = busdec2nce_awaddr;
assign plic_awlen = busdec2nce_awlen;
assign plic_awsize = busdec2nce_awsize;
assign plic_awburst = busdec2nce_awburst;
assign plic_awlock = busdec2nce_awlock;
assign plic_awcache = busdec2nce_awcache;
assign plic_awprot = busdec2nce_awprot;
assign plic_wdata = busdec2nce_wdata;
assign plic_wstrb = busdec2nce_wstrb;
assign plic_wlast = busdec2nce_wlast;
assign plic_araddr = busdec2nce_araddr;
assign plic_arlen = busdec2nce_arlen;
assign plic_arsize = busdec2nce_arsize;
assign plic_arburst = busdec2nce_arburst;
assign plic_arlock = busdec2nce_arlock;
assign plic_arcache = busdec2nce_arcache;
assign plic_arprot = busdec2nce_arprot;
assign plmt_awaddr = busdec2nce_awaddr;
assign plmt_awlen = busdec2nce_awlen;
assign plmt_awsize = busdec2nce_awsize;
assign plmt_awburst = busdec2nce_awburst;
assign plmt_awlock = busdec2nce_awlock;
assign plmt_awcache = busdec2nce_awcache;
assign plmt_awprot = busdec2nce_awprot;
assign plmt_wdata = busdec2nce_wdata;
assign plmt_wstrb = busdec2nce_wstrb;
assign plmt_wlast = busdec2nce_wlast;
assign plmt_araddr = busdec2nce_araddr;
assign plmt_arlen = busdec2nce_arlen;
assign plmt_arsize = busdec2nce_arsize;
assign plmt_arburst = busdec2nce_arburst;
assign plmt_arlock = busdec2nce_arlock;
assign plmt_arcache = busdec2nce_arcache;
assign plmt_arprot = busdec2nce_arprot;
assign plicsw_awaddr = busdec2nce_awaddr;
assign plicsw_awlen = busdec2nce_awlen;
assign plicsw_awsize = busdec2nce_awsize;
assign plicsw_awburst = busdec2nce_awburst;
assign plicsw_awlock = busdec2nce_awlock;
assign plicsw_awcache = busdec2nce_awcache;
assign plicsw_awprot = busdec2nce_awprot;
assign plicsw_wdata = busdec2nce_wdata;
assign plicsw_wstrb = busdec2nce_wstrb;
assign plicsw_wlast = busdec2nce_wlast;
assign plicsw_araddr = busdec2nce_araddr;
assign plicsw_arlen = busdec2nce_arlen;
assign plicsw_arsize = busdec2nce_arsize;
assign plicsw_arburst = busdec2nce_arburst;
assign plicsw_arlock = busdec2nce_arlock;
assign plicsw_arcache = busdec2nce_arcache;
assign plicsw_arprot = busdec2nce_arprot;
assign dm_awaddr = busdec2nce_awaddr;
assign dm_awlen = busdec2nce_awlen;
assign dm_awsize = busdec2nce_awsize;
assign dm_awburst = busdec2nce_awburst;
assign dm_awlock = busdec2nce_awlock;
assign dm_awcache = busdec2nce_awcache;
assign dm_awprot = busdec2nce_awprot;
assign dm_wdata = busdec2nce_wdata;
assign dm_wstrb = busdec2nce_wstrb;
assign dm_wlast = busdec2nce_wlast;
assign dm_araddr = busdec2nce_araddr;
assign dm_arlen = busdec2nce_arlen;
assign dm_arsize = busdec2nce_arsize;
assign dm_arburst = busdec2nce_arburst;
assign dm_arlock = busdec2nce_arlock;
assign dm_arcache = busdec2nce_arcache;
assign dm_arprot = busdec2nce_arprot;
assign plmt_hart2_stoptime = 1'b0;
assign plmt_hart3_stoptime = 1'b0;
assign plmt_hart4_stoptime = 1'b0;
assign plmt_hart5_stoptime = 1'b0;
assign plmt_hart6_stoptime = 1'b0;
assign plmt_hart7_stoptime = 1'b0;
assign stoptime = plmt_hart0_stoptime | plmt_hart1_stoptime | plmt_hart2_stoptime | plmt_hart3_stoptime | plmt_hart4_stoptime | plmt_hart5_stoptime | plmt_hart6_stoptime | plmt_hart7_stoptime;
generate
    if (BIU_DATA_WIDTH > DM_SYS_DATA_WIDTH) begin:gen_connect_axi_dm_sup
        assign dm_sys_araddr = dm_sup_araddr;
        assign dm_sys_arburst = dm_sup_arburst;
        assign dm_sys_arcache = dm_sup_arcache;
        assign dm_sys_arid = {BIU_ID_WIDTH{1'b0}};
        assign dm_sys_arlen = dm_sup_arlen;
        assign dm_sys_arlock = dm_sup_arlock;
        assign dm_sys_arprot = dm_sup_arprot;
        assign dm_sys_arsize = dm_sup_arsize;
        assign dm_sys_awaddr = dm_sup_awaddr;
        assign dm_sys_awburst = dm_sup_awburst;
        assign dm_sys_awcache = dm_sup_awcache;
        assign dm_sys_awid = {BIU_ID_WIDTH{1'b0}};
        assign dm_sys_awlen = dm_sup_awlen;
        assign dm_sys_awlock = dm_sup_awlock;
        assign dm_sys_awprot = dm_sup_awprot;
        assign dm_sys_awsize = dm_sup_awsize;
        assign dm_sup_bresp = dm_sys_bresp;
    end
    else begin:gen_connect_axi_dm
        assign dm_sup_arready = dm_sys_arready;
        assign dm_sup_awready = dm_sys_awready;
        assign dm_sup_rvalid = dm_sys_rvalid;
        assign dm_sup_rdata = dm_sys_rdata;
        assign dm_sup_rid = dm_sys_rid;
        assign dm_sup_rlast = dm_sys_rlast;
        assign dm_sup_rresp = dm_sys_rresp;
        assign dm_sup_wready = dm_sys_wready;
        assign dm_sup_bvalid = dm_sys_bvalid;
        assign dm_sup_bid = dm_sys_bid;
        assign dm_sup_bresp = dm_sys_bresp;
        assign dm_sys_araddr = dm_sup_araddr;
        assign dm_sys_arburst = dm_sup_arburst;
        assign dm_sys_arcache = dm_sup_arcache;
        assign dm_sys_arid = dm_sup_arid;
        assign dm_sys_arlen = dm_sup_arlen;
        assign dm_sys_arlock = dm_sup_arlock;
        assign dm_sys_arprot = dm_sup_arprot;
        assign dm_sys_arsize = dm_sup_arsize;
        assign dm_sys_arvalid = dm_sup_arvalid;
        assign dm_sys_awaddr = dm_sup_awaddr;
        assign dm_sys_awburst = dm_sup_awburst;
        assign dm_sys_awcache = dm_sup_awcache;
        assign dm_sys_awid = dm_sup_awid;
        assign dm_sys_awlen = dm_sup_awlen;
        assign dm_sys_awlock = dm_sup_awlock;
        assign dm_sys_awprot = dm_sup_awprot;
        assign dm_sys_awsize = dm_sup_awsize;
        assign dm_sys_awvalid = dm_sup_awvalid;
        assign dm_sys_rready = dm_sup_rready;
        assign dm_sys_wdata = dm_sup_wdata;
        assign dm_sys_wlast = dm_sup_wlast;
        assign dm_sys_wstrb = dm_sup_wstrb;
        assign dm_sys_wvalid = dm_sup_wvalid;
        assign dm_sys_bready = dm_sup_bready;
    end
endgenerate
assign dm_sys_arready = 1'b1;
assign dm_sys_awready = 1'b1;
assign dm_sys_rvalid = 1'b0;
assign dm_sys_rdata = {BIU_DATA_WIDTH{1'b0}};
assign dm_sys_rid = {BIU_ID_WIDTH{1'b0}};
assign dm_sys_rlast = 1'b0;
assign dm_sys_rresp = 2'b0;
assign dm_sys_wready = 1'b1;
assign dm_sys_bvalid = 1'b0;
assign dm_sys_bid = {BIU_ID_WIDTH{1'b0}};
assign dm_sys_bresp = 2'b0;
assign dbg_srst_req = ndmreset;
assign plic_hart2_meiack = 1'b0;
assign plic_hart3_meiack = 1'b0;
assign plic_hart4_meiack = 1'b0;
assign plic_hart5_meiack = 1'b0;
assign plic_hart6_meiack = 1'b0;
assign plic_hart7_meiack = 1'b0;
assign plic_hart2_seiack = 1'b0;
assign plic_hart3_seiack = 1'b0;
assign plic_hart4_seiack = 1'b0;
assign plic_hart5_seiack = 1'b0;
assign plic_hart6_seiack = 1'b0;
assign plic_hart7_seiack = 1'b0;
assign dm_hart_unavail[0] = core0_hart_unavail;
assign dm_hart_under_reset[0] = core0_hart_under_reset;
assign dm_hart_unavail[1] = core1_hart_unavail;
assign dm_hart_under_reset[1] = core1_hart_under_reset;
generate
    if (COMPLEX_BRG_TYPE != 2 && BIU_ASYNC_SUPPORT != 1) begin:gen_core0_no_sync
        assign hart0_debugint = dm_debugint[0];
        assign hart0_resethaltreq = dm_resethaltreq[0];
        assign hart0_seip = plic_hart0_seip;
        assign plic_hart0_seiack = hart0_seiack;
        assign hart0_meip = plic_hart0_meip;
        assign plic_hart0_meiack = hart0_meiack;
        assign hart0_msip = plicsw_hart0_msip;
        assign hart0_mtip = mtip[0];
        assign plmt_hart0_stoptime = hart0_stoptime;
    end
endgenerate
generate
    if (COMPLEX_BRG_TYPE != 2 && BIU_ASYNC_SUPPORT != 1) begin:gen_core1_no_sync
        assign hart1_debugint = dm_debugint[1];
        assign hart1_resethaltreq = dm_resethaltreq[1];
        assign hart1_seip = plic_hart1_seip;
        assign plic_hart1_seiack = hart1_seiack;
        assign hart1_meip = plic_hart1_meip;
        assign plic_hart1_meiack = hart1_meiack;
        assign hart1_msip = plicsw_hart1_msip;
        assign hart1_mtip = mtip[1];
        assign plmt_hart1_stoptime = hart1_stoptime;
    end
endgenerate
generate
    if (BIU_ASYNC_SUPPORT != 1) begin:gen_l2_no_sync
        assign l2c_err_int = l2c_err_int_int;
    end
endgenerate
wire nds_unused_wire;
wire nds_unused_sys_wire;
wire nds_unused_hart0_wire;
wire nds_unused_hart1_wire;
wire nds_unused_hart2_wire;
wire nds_unused_hart3_wire;
wire nds_unused_hart4_wire;
wire nds_unused_hart5_wire;
wire nds_unused_hart6_wire;
wire nds_unused_hart7_wire;
assign nds_unused_wire = nds_unused_sys_wire | nds_unused_hart0_wire | nds_unused_hart1_wire | nds_unused_hart2_wire | nds_unused_hart3_wire | nds_unused_hart4_wire | nds_unused_hart5_wire | nds_unused_hart6_wire | nds_unused_hart7_wire;
assign nds_unused_hart0_wire = (|core0_hart_id[63:0]) | core0_lm_clk | core0_slv_clk_en | core0_slv_clk | core0_slv1_clk_en | core0_slv1_clk | core0_slvp_reset_n | core0_l2_clk | core0_l2_reset_n | core0_hart_halted | hart0_ueip | vpu0_hvm_clk;
assign nds_unused_hart1_wire = 1'b0 | (|core1_hart_id[63:0]) | core1_lm_clk | core1_slv_clk_en | core1_slv_clk | core1_slv1_clk_en | core1_slv1_clk | core1_slvp_reset_n | core1_l2_clk | core1_l2_reset_n | core1_hart_halted | hart1_ueip | vpu1_hvm_clk;
assign nds_unused_hart2_wire = 1'b0 | (|hart2_meiid[9:0]) | (|hart2_seiid[9:0]) | plic_hart2_meip | plicsw_hart2_msip | plic_hart2_seip;
assign nds_unused_hart3_wire = 1'b0 | (|hart3_meiid[9:0]) | (|hart3_seiid[9:0]) | plic_hart3_meip | plicsw_hart3_msip | plic_hart3_seip;
assign nds_unused_hart4_wire = 1'b0 | (|hart4_meiid[9:0]) | (|hart4_seiid[9:0]) | plic_hart4_meip | plicsw_hart4_msip | plic_hart4_seip;
assign nds_unused_hart5_wire = 1'b0 | (|hart5_meiid[9:0]) | (|hart5_seiid[9:0]) | plic_hart5_meip | plicsw_hart5_msip | plic_hart5_seip;
assign nds_unused_hart6_wire = 1'b0 | (|hart6_meiid[9:0]) | (|hart6_seiid[9:0]) | plic_hart6_meip | plicsw_hart6_msip | plic_hart6_seip;
assign nds_unused_hart7_wire = 1'b0 | (|hart7_meiid[9:0]) | (|hart7_seiid[9:0]) | plic_hart7_meip | plicsw_hart7_msip | plic_hart7_seip;
assign nds_unused_sys_wire = (|dm_hart_under_reset[NHART - 1:0]) | (|sdn2busdec_bid) | (|sdn2busdec_rid) | (|mmio_exmon_awid_dummy) | (|mmio_exmon_arid_dummy) | (|dm_sys_awid[BIU_ID_MSB:0]) | (|dm_sys_awaddr[ADDR_MSB:0]) | (|dm_sys_awburst[1:0]) | (|dm_sys_awsize[2:0]) | (|dm_sys_awlen[7:0]) | (|dm_sys_awcache[3:0]) | dm_sys_awlock | (|dm_sys_awprot[2:0]) | dm_sys_awvalid | (|dm_sys_wdata[(BIU_DATA_WIDTH - 1):0]) | (|dm_sys_wstrb[((BIU_DATA_WIDTH / 8) - 1):0]) | dm_sys_wvalid | dm_sys_wlast | (|dm_sys_arid[BIU_ID_MSB:0]) | (|dm_sys_araddr[ADDR_MSB:0]) | (|dm_sys_arburst[1:0]) | (|dm_sys_arsize[2:0]) | (|dm_sys_arlen[7:0]) | (|dm_sys_arcache[3:0]) | dm_sys_arlock | (|dm_sys_arprot[2:0]) | dm_sys_arvalid | (|dm_sys_rid[BIU_ID_MSB:0]) | (|dm_sys_bid[BIU_ID_MSB:0]) | dm_sys_rready | dm_sys_bready;
atcbmc301 #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(BIU_DATA_WIDTH)
) u_axi_bmc (
    .us0_araddr(axi_mmio_araddr[ADDR_MSB:0]),
    .us0_arburst(axi_mmio_arburst),
    .us0_arcache(axi_mmio_arcache),
    .us0_arid(axi_mmio_arid),
    .us0_arlen(axi_mmio_arlen),
    .us0_arlock(axi_mmio_arlock),
    .us0_arprot(axi_mmio_arprot),
    .us0_arready(axi_mmio_arready),
    .us0_arsize(axi_mmio_arsize),
    .us0_arvalid(axi_mmio_arvalid),
    .us0_awaddr(axi_mmio_awaddr[ADDR_MSB:0]),
    .us0_awburst(axi_mmio_awburst),
    .us0_awcache(axi_mmio_awcache),
    .us0_awid(axi_mmio_awid),
    .us0_awlen(axi_mmio_awlen),
    .us0_awlock(axi_mmio_awlock),
    .us0_awprot(axi_mmio_awprot),
    .us0_awready(axi_mmio_awready),
    .us0_awsize(axi_mmio_awsize),
    .us0_awvalid(axi_mmio_awvalid),
    .us0_bid(axi_mmio_bid),
    .us0_bready(axi_mmio_bready),
    .us0_bresp(axi_mmio_bresp),
    .us0_bvalid(axi_mmio_bvalid),
    .us0_rdata(axi_mmio_rdata),
    .us0_rid(axi_mmio_rid),
    .us0_rlast(axi_mmio_rlast),
    .us0_rready(axi_mmio_rready),
    .us0_rresp(axi_mmio_rresp),
    .us0_rvalid(axi_mmio_rvalid),
    .us0_wdata(axi_mmio_wdata),
    .us0_wlast(axi_mmio_wlast),
    .us0_wready(axi_mmio_wready),
    .us0_wstrb(axi_mmio_wstrb),
    .us0_wvalid(axi_mmio_wvalid),
    .ds1_araddr(inter2sdn_araddr),
    .ds1_arburst(inter2sdn_arburst),
    .ds1_arcache(inter2sdn_arcache),
    .ds1_arid({inter2sdn_arid,inter2sdn_arid_dummy}),
    .ds1_arlen(inter2sdn_arlen),
    .ds1_arlock(inter2sdn_arlock),
    .ds1_arprot(inter2sdn_arprot),
    .ds1_arready(inter2sdn_arready),
    .ds1_arsize(inter2sdn_arsize),
    .ds1_arvalid(inter2sdn_arvalid),
    .ds1_awaddr(inter2sdn_awaddr),
    .ds1_awburst(inter2sdn_awburst),
    .ds1_awcache(inter2sdn_awcache),
    .ds1_awid({inter2sdn_awid,inter2sdn_awid_dummy}),
    .ds1_awlen(inter2sdn_awlen),
    .ds1_awlock(inter2sdn_awlock),
    .ds1_awprot(inter2sdn_awprot),
    .ds1_awready(inter2sdn_awready),
    .ds1_awsize(inter2sdn_awsize),
    .ds1_awvalid(inter2sdn_awvalid),
    .ds1_bid({inter2sdn_bid,inter2sdn_bid_dummy}),
    .ds1_bready(inter2sdn_bready),
    .ds1_bresp(inter2sdn_bresp),
    .ds1_bvalid(inter2sdn_bvalid),
    .ds1_rdata(inter2sdn_rdata),
    .ds1_rid({inter2sdn_rid,inter2sdn_rid_dummy}),
    .ds1_rlast(inter2sdn_rlast),
    .ds1_rready(inter2sdn_rready),
    .ds1_rresp(inter2sdn_rresp),
    .ds1_rvalid(inter2sdn_rvalid),
    .ds1_wdata(inter2sdn_wdata),
    .ds1_wlast(inter2sdn_wlast),
    .ds1_wready(inter2sdn_wready),
    .ds1_wstrb(inter2sdn_wstrb),
    .ds1_wvalid(inter2sdn_wvalid),
    .ds2_araddr(mmio_exmon_araddr),
    .ds2_arburst(mmio_exmon_arburst),
    .ds2_arcache(mmio_exmon_arcache),
    .ds2_arid({mmio_exmon_arid,mmio_exmon_arid_dummy}),
    .ds2_arlen(mmio_exmon_arlen),
    .ds2_arlock(mmio_exmon_arlock),
    .ds2_arprot(mmio_exmon_arprot),
    .ds2_arready(mmio_exmon_arready),
    .ds2_arsize(mmio_exmon_arsize),
    .ds2_arvalid(mmio_exmon_arvalid),
    .ds2_awaddr(mmio_exmon_awaddr),
    .ds2_awburst(mmio_exmon_awburst),
    .ds2_awcache(mmio_exmon_awcache),
    .ds2_awid({mmio_exmon_awid,mmio_exmon_awid_dummy}),
    .ds2_awlen(mmio_exmon_awlen),
    .ds2_awlock(mmio_exmon_awlock),
    .ds2_awprot(mmio_exmon_awprot),
    .ds2_awready(mmio_exmon_awready),
    .ds2_awsize(mmio_exmon_awsize),
    .ds2_awvalid(mmio_exmon_awvalid),
    .ds2_bid({mmio_exmon_bid,mmio_exmon_bid_dummy}),
    .ds2_bready(mmio_exmon_bready),
    .ds2_bresp(mmio_exmon_bresp),
    .ds2_bvalid(mmio_exmon_bvalid),
    .ds2_rdata(mmio_exmon_rdata),
    .ds2_rid({mmio_exmon_rid,mmio_exmon_rid_dummy}),
    .ds2_rlast(mmio_exmon_rlast),
    .ds2_rready(mmio_exmon_rready),
    .ds2_rresp(mmio_exmon_rresp),
    .ds2_rvalid(mmio_exmon_rvalid),
    .ds2_wdata(mmio_exmon_wdata),
    .ds2_wlast(mmio_exmon_wlast),
    .ds2_wready(mmio_exmon_wready),
    .ds2_wstrb(mmio_exmon_wstrb),
    .ds2_wvalid(mmio_exmon_wvalid),
    .aclk(aclk),
    .aresetn(aresetn)
);
generate
    if ((BIU_DATA_WIDTH > NCE_DATA_WIDTH)) begin:gen_axi_sdn
        atcsizedn300 #(
            .ADDR_WIDTH(ADDR_WIDTH),
            .DS_DATA_WIDTH(NCE_DATA_WIDTH),
            .ID_WIDTH(BIU_ID_WIDTH + 4),
            .US_DATA_WIDTH(BIU_DATA_WIDTH)
        ) u_axi_sdn (
            .ds_bready(sdn2busdec_bready),
            .ds_bresp(sdn2busdec_bresp),
            .ds_bvalid(sdn2busdec_bvalid),
            .ds_rdata(sdn2busdec_rdata),
            .ds_rlast(sdn2busdec_rlast),
            .ds_rready(sdn2busdec_rready),
            .ds_rresp(sdn2busdec_rresp),
            .ds_rvalid(sdn2busdec_rvalid),
            .ds_wdata(sdn2busdec_wdata),
            .ds_wlast(sdn2busdec_wlast),
            .ds_wready(sdn2busdec_wready),
            .ds_wstrb(sdn2busdec_wstrb),
            .ds_wvalid(sdn2busdec_wvalid),
            .us_bid({inter2sdn_bid,inter2sdn_bid_dummy}),
            .us_bready(inter2sdn_bready),
            .us_bresp(inter2sdn_bresp),
            .us_bvalid(inter2sdn_bvalid),
            .us_rdata(inter2sdn_rdata),
            .us_rid({inter2sdn_rid,inter2sdn_rid_dummy}),
            .us_rlast(inter2sdn_rlast),
            .us_rready(inter2sdn_rready),
            .us_rresp(inter2sdn_rresp),
            .us_rvalid(inter2sdn_rvalid),
            .us_wdata(inter2sdn_wdata),
            .us_wlast(inter2sdn_wlast),
            .us_wready(inter2sdn_wready),
            .us_wstrb(inter2sdn_wstrb),
            .us_wvalid(inter2sdn_wvalid),
            .ds_arready(sdn2busdec_arready),
            .aclk(aclk),
            .aresetn(aresetn),
            .ds_awready(sdn2busdec_awready),
            .ds_araddr(sdn2busdec_araddr),
            .ds_arburst(sdn2busdec_arburst),
            .ds_arcache(sdn2busdec_arcache),
            .ds_arlen(sdn2busdec_arlen),
            .ds_arlock(sdn2busdec_arlock),
            .ds_arprot(sdn2busdec_arprot),
            .ds_arsize(sdn2busdec_arsize),
            .ds_arvalid(sdn2busdec_arvalid),
            .us_araddr(inter2sdn_araddr),
            .us_arburst(inter2sdn_arburst),
            .us_arcache(inter2sdn_arcache),
            .us_arid({inter2sdn_arid,inter2sdn_arid_dummy}),
            .us_arlen(inter2sdn_arlen),
            .us_arlock(inter2sdn_arlock),
            .us_arprot(inter2sdn_arprot),
            .us_arready(inter2sdn_arready),
            .us_arsize(inter2sdn_arsize),
            .us_arvalid(inter2sdn_arvalid),
            .ds_awaddr(sdn2busdec_awaddr),
            .ds_awburst(sdn2busdec_awburst),
            .ds_awcache(sdn2busdec_awcache),
            .ds_awlen(sdn2busdec_awlen),
            .ds_awlock(sdn2busdec_awlock),
            .ds_awprot(sdn2busdec_awprot),
            .ds_awsize(sdn2busdec_awsize),
            .ds_awvalid(sdn2busdec_awvalid),
            .us_awaddr(inter2sdn_awaddr),
            .us_awburst(inter2sdn_awburst),
            .us_awcache(inter2sdn_awcache),
            .us_awid({inter2sdn_awid,inter2sdn_awid_dummy}),
            .us_awlen(inter2sdn_awlen),
            .us_awlock(inter2sdn_awlock),
            .us_awprot(inter2sdn_awprot),
            .us_awready(inter2sdn_awready),
            .us_awsize(inter2sdn_awsize),
            .us_awvalid(inter2sdn_awvalid)
        );
    end
endgenerate
atcexmon300 #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(BIU_DATA_WIDTH),
    .ID_WIDTH(BIU_ID_WIDTH),
    .NUM_EX_SEQ(8)
) u_atcexmon300 (
    .aclk(aclk),
    .aresetn(aresetn),
    .us_awid(mmio_exmon_awid),
    .us_awaddr(mmio_exmon_awaddr),
    .us_awlock(mmio_exmon_awlock),
    .us_awburst(mmio_exmon_awburst),
    .us_awlen(mmio_exmon_awlen),
    .us_awcache(mmio_exmon_awcache),
    .us_awprot(mmio_exmon_awprot),
    .us_awsize(mmio_exmon_awsize),
    .us_awqos(4'b0),
    .us_awregion(4'b0),
    .us_awvalid(mmio_exmon_awvalid),
    .us_awready(mmio_exmon_awready),
    .us_wdata(mmio_exmon_wdata),
    .us_wstrb(mmio_exmon_wstrb),
    .us_wlast(mmio_exmon_wlast),
    .us_wvalid(mmio_exmon_wvalid),
    .us_wready(mmio_exmon_wready),
    .us_bresp(mmio_exmon_bresp),
    .us_bid(mmio_exmon_bid),
    .us_bvalid(mmio_exmon_bvalid),
    .us_bready(mmio_exmon_bready),
    .us_arid(mmio_exmon_arid),
    .us_araddr(mmio_exmon_araddr),
    .us_arlock(mmio_exmon_arlock),
    .us_arburst(mmio_exmon_arburst),
    .us_arlen(mmio_exmon_arlen),
    .us_arcache(mmio_exmon_arcache),
    .us_arprot(mmio_exmon_arprot),
    .us_arsize(mmio_exmon_arsize),
    .us_arqos(4'b0),
    .us_arregion(4'b0),
    .us_arvalid(mmio_exmon_arvalid),
    .us_arready(mmio_exmon_arready),
    .us_rid(mmio_exmon_rid),
    .us_rresp(mmio_exmon_rresp),
    .us_rdata(mmio_exmon_rdata),
    .us_rlast(mmio_exmon_rlast),
    .us_rvalid(mmio_exmon_rvalid),
    .us_rready(mmio_exmon_rready),
    .ds_awid(mmio_awid),
    .ds_awaddr(mmio_awaddr),
    .ds_awlock(mmio_awlock),
    .ds_awburst(mmio_awburst),
    .ds_awlen(mmio_awlen),
    .ds_awcache(mmio_awcache),
    .ds_awprot(mmio_awprot),
    .ds_awsize(mmio_awsize),
    .ds_awqos(nds_unused_awqos),
    .ds_awregion(nds_unused_awregion),
    .ds_awvalid(mmio_awvalid),
    .ds_awready(mmio_awready),
    .ds_wdata(mmio_wdata),
    .ds_wstrb(mmio_wstrb),
    .ds_wlast(mmio_wlast),
    .ds_wvalid(mmio_wvalid),
    .ds_wready(mmio_wready),
    .ds_bresp(mmio_bresp),
    .ds_bid(mmio_bid),
    .ds_bvalid(mmio_bvalid),
    .ds_bready(mmio_bready),
    .ds_arid(mmio_arid),
    .ds_araddr(mmio_araddr),
    .ds_arlock(mmio_arlock),
    .ds_arburst(mmio_arburst),
    .ds_arlen(mmio_arlen),
    .ds_arcache(mmio_arcache),
    .ds_arprot(mmio_arprot),
    .ds_arsize(mmio_arsize),
    .ds_arqos(nds_unused_arqos),
    .ds_arregion(nds_unused_arregion),
    .ds_arvalid(mmio_arvalid),
    .ds_arready(mmio_arready),
    .ds_rid(mmio_rid),
    .ds_rresp(mmio_rresp),
    .ds_rdata(mmio_rdata),
    .ds_rlast(mmio_rlast),
    .ds_rvalid(mmio_rvalid),
    .ds_rready(mmio_rready)
);
atcbusdec301 #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(NCE_DATA_WIDTH),
    .ID_WIDTH(BIU_ID_WIDTH + 4)
) u_axi_busdec (
    .ds1_awvalid(plic_awvalid),
    .ds1_awready(plic_awready),
    .ds1_wvalid(plic_wvalid),
    .ds1_wready(plic_wready),
    .ds1_bresp(plic_bresp),
    .ds1_bvalid(plic_bvalid),
    .ds1_bready(plic_bready),
    .ds1_arvalid(plic_arvalid),
    .ds1_arready(plic_arready),
    .ds1_rdata(plic_rdata),
    .ds1_rresp(plic_rresp),
    .ds1_rlast(plic_rlast),
    .ds1_rvalid(plic_rvalid),
    .ds1_rready(plic_rready),
    .ds2_awvalid(plmt_awvalid),
    .ds2_awready(plmt_awready),
    .ds2_wvalid(plmt_wvalid),
    .ds2_wready(plmt_wready),
    .ds2_bresp(plmt_bresp),
    .ds2_bvalid(plmt_bvalid),
    .ds2_bready(plmt_bready),
    .ds2_arvalid(plmt_arvalid),
    .ds2_arready(plmt_arready),
    .ds2_rdata(plmt_rdata),
    .ds2_rresp(plmt_rresp),
    .ds2_rlast(plmt_rlast),
    .ds2_rvalid(plmt_rvalid),
    .ds2_rready(plmt_rready),
    .ds3_awvalid(plicsw_awvalid),
    .ds3_awready(plicsw_awready),
    .ds3_wvalid(plicsw_wvalid),
    .ds3_wready(plicsw_wready),
    .ds3_bresp(plicsw_bresp),
    .ds3_bvalid(plicsw_bvalid),
    .ds3_bready(plicsw_bready),
    .ds3_arvalid(plicsw_arvalid),
    .ds3_arready(plicsw_arready),
    .ds3_rdata(plicsw_rdata),
    .ds3_rresp(plicsw_rresp),
    .ds3_rlast(plicsw_rlast),
    .ds3_rvalid(plicsw_rvalid),
    .ds3_rready(plicsw_rready),
    .ds4_awvalid(dm_awvalid),
    .ds4_awready(dm_awready),
    .ds4_wvalid(dm_wvalid),
    .ds4_wready(dm_wready),
    .ds4_bresp(dm_bresp),
    .ds4_bvalid(dm_bvalid),
    .ds4_bready(dm_bready),
    .ds4_arvalid(dm_arvalid),
    .ds4_arready(dm_arready),
    .ds4_rdata(dm_rdata),
    .ds4_rresp(dm_rresp),
    .ds4_rlast(dm_rlast),
    .ds4_rvalid(dm_rvalid),
    .ds4_rready(dm_rready),
    .ds_awaddr(busdec2nce_awaddr),
    .ds_awlen(busdec2nce_awlen),
    .ds_awsize(busdec2nce_awsize),
    .ds_awburst(busdec2nce_awburst),
    .ds_awlock(busdec2nce_awlock),
    .ds_awcache(busdec2nce_awcache),
    .ds_awprot(busdec2nce_awprot),
    .ds_wdata(busdec2nce_wdata),
    .ds_wstrb(busdec2nce_wstrb),
    .ds_wlast(busdec2nce_wlast),
    .ds_araddr(busdec2nce_araddr),
    .ds_arlen(busdec2nce_arlen),
    .ds_arsize(busdec2nce_arsize),
    .ds_arburst(busdec2nce_arburst),
    .ds_arlock(busdec2nce_arlock),
    .ds_arcache(busdec2nce_arcache),
    .ds_arprot(busdec2nce_arprot),
    .us_awid(sdn2busdec_awid),
    .us_awaddr(sdn2busdec_awaddr),
    .us_awlen(sdn2busdec_awlen),
    .us_awsize(sdn2busdec_awsize),
    .us_awburst(sdn2busdec_awburst),
    .us_awlock(sdn2busdec_awlock),
    .us_awcache(sdn2busdec_awcache),
    .us_awprot(sdn2busdec_awprot),
    .us_awvalid(sdn2busdec_awvalid),
    .us_awready(sdn2busdec_awready),
    .us_wdata(sdn2busdec_wdata),
    .us_wstrb(sdn2busdec_wstrb),
    .us_wlast(sdn2busdec_wlast),
    .us_wvalid(sdn2busdec_wvalid),
    .us_wready(sdn2busdec_wready),
    .us_bid(sdn2busdec_bid),
    .us_bresp(sdn2busdec_bresp),
    .us_bvalid(sdn2busdec_bvalid),
    .us_bready(sdn2busdec_bready),
    .us_arid(sdn2busdec_arid),
    .us_araddr(sdn2busdec_araddr),
    .us_arlen(sdn2busdec_arlen),
    .us_arsize(sdn2busdec_arsize),
    .us_arburst(sdn2busdec_arburst),
    .us_arlock(sdn2busdec_arlock),
    .us_arcache(sdn2busdec_arcache),
    .us_arprot(sdn2busdec_arprot),
    .us_arvalid(sdn2busdec_arvalid),
    .us_arready(sdn2busdec_arready),
    .us_rid(sdn2busdec_rid),
    .us_rdata(sdn2busdec_rdata),
    .us_rresp(sdn2busdec_rresp),
    .us_rlast(sdn2busdec_rlast),
    .us_rvalid(sdn2busdec_rvalid),
    .us_rready(sdn2busdec_rready),
    .aclk(aclk),
    .aresetn(aresetn)
);
ax45mpv_cluster u_cluster(
    .core0_icache_disable_init(hart0_icache_disable_init),
    .core0_seiack(hart0_seiack),
    .core0_seiid(hart0_seiid),
    .core0_seip(hart0_seip),
    .core0_debugint(hart0_debugint),
    .core0_hart_halted(core0_hart_halted),
    .core0_hart_unavail(core0_hart_unavail),
    .core0_hart_under_reset(core0_hart_under_reset),
    .core0_resethaltreq(hart0_resethaltreq),
    .core0_stoptime(hart0_stoptime),
    .vpu0_clk_en(vpu0_clk_en),
    .vpu0_vace_clk_en(vpu0_vace_clk_en),
    .vpu0_valu_clk_en(vpu0_valu_clk_en),
    .vpu0_vdiv_clk_en(vpu0_vdiv_clk_en),
    .vpu0_vfdiv_clk_en(vpu0_vfdiv_clk_en),
    .vpu0_vfmis_clk_en(vpu0_vfmis_clk_en),
    .vpu0_vlsu_clk_en(vpu0_vlsu_clk_en),
    .vpu0_vmac_clk_en(vpu0_vmac_clk_en),
    .vpu0_vmask_clk_en(vpu0_vmask_clk_en),
    .vpu0_vpermut_clk_en(vpu0_vpermut_clk_en),
    .vpu0_vsp_clk_en(vpu0_vsp_clk_en),
    .core1_clk(core1_clk),
    .core1_dcache_disable_init(hart1_dcache_disable_init),
    .core1_dcu_clk(core1_dcu_clk),
    .core1_hart_id(64'd1),
    .core1_meiack(hart1_meiack),
    .core1_meiid(hart1_meiid),
    .core1_meip(hart1_meip),
    .core1_msip(hart1_msip),
    .core1_mtip(hart1_mtip),
    .core1_nmi(hart1_nmi),
    .core1_reset_n(core1_reset_n),
    .core1_reset_vector(hart1_reset_vector),
    .core1_wfi_mode(hart1_core_wfi_mode),
    .vpu1_clk(vpu1_clk),
    .vpu1_vace_clk(vpu1_vace_clk),
    .vpu1_valu_clk(vpu1_valu_clk),
    .vpu1_vdiv_clk(vpu1_vdiv_clk),
    .vpu1_vfdiv_clk(vpu1_vfdiv_clk),
    .vpu1_vfmis_clk(vpu1_vfmis_clk),
    .vpu1_vlsu_clk(vpu1_vlsu_clk),
    .vpu1_vmac_clk(vpu1_vmac_clk),
    .vpu1_vmask_clk(vpu1_vmask_clk),
    .vpu1_vpermut_clk(vpu1_vpermut_clk),
    .vpu1_vsp_clk(vpu1_vsp_clk),
    .l2c_bank0_data_ram_clk(l2c_bank0_data_ram_clk),
    .l2c_bank0_data_ram_clk_en(l2c_bank0_data_ram_clk_en),
    .l2c_bank1_data_ram_clk(l2c_bank1_data_ram_clk),
    .l2c_bank1_data_ram_clk_en(l2c_bank1_data_ram_clk_en),
    .l2c_disable_init(1'b0),
    .l2c_err_int(l2c_err_int_int),
    .mem_aclk_en(axi_bus_clk_en),
    .mmio_aclk_en(axi_bus_clk_en),
    .core1_debugint(hart1_debugint),
    .core1_hart_halted(core1_hart_halted),
    .core1_hart_unavail(core1_hart_unavail),
    .core1_hart_under_reset(core1_hart_under_reset),
    .core1_resethaltreq(hart1_resethaltreq),
    .core1_stoptime(hart1_stoptime),
    .core1_icache_disable_init(hart1_icache_disable_init),
    .core1_seiack(hart1_seiack),
    .core1_seiid(hart1_seiid),
    .core1_seip(hart1_seip),
    .vpu1_clk_en(vpu1_clk_en),
    .vpu1_vace_clk_en(vpu1_vace_clk_en),
    .vpu1_valu_clk_en(vpu1_valu_clk_en),
    .vpu1_vdiv_clk_en(vpu1_vdiv_clk_en),
    .vpu1_vfdiv_clk_en(vpu1_vfdiv_clk_en),
    .vpu1_vfmis_clk_en(vpu1_vfmis_clk_en),
    .vpu1_vlsu_clk_en(vpu1_vlsu_clk_en),
    .vpu1_vmac_clk_en(vpu1_vmac_clk_en),
    .vpu1_vmask_clk_en(vpu1_vmask_clk_en),
    .vpu1_vpermut_clk_en(vpu1_vpermut_clk_en),
    .vpu1_vsp_clk_en(vpu1_vsp_clk_en),
    .core0_clk(core0_clk),
    .core0_dcache_disable_init(hart0_dcache_disable_init),
    .core0_dcu_clk(core0_dcu_clk),
    .core0_hart_id(64'd0),
    .core0_meiack(hart0_meiack),
    .core0_meiid(hart0_meiid),
    .core0_meip(hart0_meip),
    .core0_msip(hart0_msip),
    .core0_mtip(hart0_mtip),
    .core0_nmi(hart0_nmi),
    .core0_reset_n(core0_reset_n),
    .core0_reset_vector(hart0_reset_vector),
    .core0_wfi_mode(hart0_core_wfi_mode),
    .vpu0_clk(vpu0_clk),
    .vpu0_vace_clk(vpu0_vace_clk),
    .vpu0_valu_clk(vpu0_valu_clk),
    .vpu0_vdiv_clk(vpu0_vdiv_clk),
    .vpu0_vfdiv_clk(vpu0_vfdiv_clk),
    .vpu0_vfmis_clk(vpu0_vfmis_clk),
    .vpu0_vlsu_clk(vpu0_vlsu_clk),
    .vpu0_vmac_clk(vpu0_vmac_clk),
    .vpu0_vmask_clk(vpu0_vmask_clk),
    .vpu0_vpermut_clk(vpu0_vpermut_clk),
    .vpu0_vsp_clk(vpu0_vsp_clk),
    .scan_enable(scan_enable),
    .test_mode(test_mode),
    .l2_clk(l2_clk),
    .l2_resetn(l2_resetn),
    .mem_araddr(mem_araddr),
    .mem_arburst(mem_arburst),
    .mem_arcache(mem_arcache),
    .mem_arid(mem_arid),
    .mem_arlen(mem_arlen),
    .mem_arlock(mem_arlock),
    .mem_arprot(mem_arprot),
    .mem_arready(mem_arready),
    .mem_arsize(mem_arsize),
    .mem_arvalid(mem_arvalid),
    .mem_awaddr(mem_awaddr),
    .mem_awburst(mem_awburst),
    .mem_awcache(mem_awcache),
    .mem_awid(mem_awid),
    .mem_awlen(mem_awlen),
    .mem_awlock(mem_awlock),
    .mem_awprot(mem_awprot),
    .mem_awready(mem_awready),
    .mem_awsize(mem_awsize),
    .mem_awvalid(mem_awvalid),
    .mem_bid(mem_bid),
    .mem_bready(mem_bready),
    .mem_bresp(mem_bresp),
    .mem_bvalid(mem_bvalid),
    .mem_rdata(mem_rdata),
    .mem_rid(mem_rid),
    .mem_rlast(mem_rlast),
    .mem_rready(mem_rready),
    .mem_rresp(mem_rresp),
    .mem_rvalid(mem_rvalid),
    .mem_wdata(mem_wdata),
    .mem_wlast(mem_wlast),
    .mem_wready(mem_wready),
    .mem_wstrb(mem_wstrb),
    .mem_wvalid(mem_wvalid),
    .mmio_araddr(axi_mmio_araddr),
    .mmio_arburst(axi_mmio_arburst),
    .mmio_arcache(axi_mmio_arcache),
    .mmio_arid(axi_mmio_arid),
    .mmio_arlen(axi_mmio_arlen),
    .mmio_arlock(axi_mmio_arlock),
    .mmio_arprot(axi_mmio_arprot),
    .mmio_arready(axi_mmio_arready),
    .mmio_arsize(axi_mmio_arsize),
    .mmio_arvalid(axi_mmio_arvalid),
    .mmio_awaddr(axi_mmio_awaddr),
    .mmio_awburst(axi_mmio_awburst),
    .mmio_awcache(axi_mmio_awcache),
    .mmio_awid(axi_mmio_awid),
    .mmio_awlen(axi_mmio_awlen),
    .mmio_awlock(axi_mmio_awlock),
    .mmio_awprot(axi_mmio_awprot),
    .mmio_awready(axi_mmio_awready),
    .mmio_awsize(axi_mmio_awsize),
    .mmio_awvalid(axi_mmio_awvalid),
    .mmio_bid(axi_mmio_bid),
    .mmio_bready(axi_mmio_bready),
    .mmio_bresp(axi_mmio_bresp),
    .mmio_bvalid(axi_mmio_bvalid),
    .mmio_rdata(axi_mmio_rdata),
    .mmio_rid(axi_mmio_rid),
    .mmio_rlast(axi_mmio_rlast),
    .mmio_rready(axi_mmio_rready),
    .mmio_rresp(axi_mmio_rresp),
    .mmio_rvalid(axi_mmio_rvalid),
    .mmio_wdata(axi_mmio_wdata),
    .mmio_wlast(axi_mmio_wlast),
    .mmio_wready(axi_mmio_wready),
    .mmio_wstrb(axi_mmio_wstrb),
    .mmio_wvalid(axi_mmio_wvalid)
);
nceplmt100 #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .BUS_TYPE("axi"),
    .DATA_WIDTH(NCE_DATA_WIDTH),
    .GRAY_WIDTH(2),
    .NHART(NHART),
    .SYNC_STAGE(SYNC_STAGE)
) u_plmt (
    .araddr(plmt_araddr),
    .arburst(plmt_arburst),
    .arcache(plmt_arcache),
    .arid(4'd0),
    .arlen(plmt_arlen),
    .arlock(plmt_arlock),
    .arprot(plmt_arprot),
    .arready(plmt_arready),
    .arsize(plmt_arsize),
    .arvalid(plmt_arvalid),
    .awaddr(plmt_awaddr),
    .awburst(plmt_awburst),
    .awcache(plmt_awcache),
    .awid(4'd0),
    .awlen(plmt_awlen),
    .awlock(plmt_awlock),
    .awprot(plmt_awprot),
    .awready(plmt_awready),
    .awsize(plmt_awsize),
    .awvalid(plmt_awvalid),
    .bid(nds_unused_plmt_bid),
    .bready(plmt_bready),
    .bresp(plmt_bresp),
    .bvalid(plmt_bvalid),
    .haddr({ADDR_WIDTH{1'b0}}),
    .hburst(3'd0),
    .hrdata(nds_unused_plmt_hrdata),
    .hready(1'd0),
    .hreadyout(nds_unused_plmt_hreadyout),
    .hresp(nds_unused_plmt_hresp),
    .hsel(1'd0),
    .hsize(3'd0),
    .htrans(2'd0),
    .hwdata({NCE_DATA_WIDTH{1'b0}}),
    .hwrite(1'd0),
    .mtip(mtip),
    .rdata(plmt_rdata),
    .rid(nds_unused_plmt_rid),
    .rlast(plmt_rlast),
    .rready(plmt_rready),
    .rresp(plmt_rresp),
    .rvalid(plmt_rvalid),
    .wdata(plmt_wdata),
    .wlast(plmt_wlast),
    .wready(plmt_wready),
    .wstrb(plmt_wstrb),
    .wvalid(plmt_wvalid),
    .clk(aclk),
    .resetn(aresetn),
    .mtime_clk(mtime_clk),
    .por_rstn(por_rstn),
    .test_mode(test_mode),
    .stoptime(stoptime)
);
ncepldm200 #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(NCE_DATA_WIDTH),
    .DMXTRIGGER_COUNT(DMXTRIGGER_COUNT),
    .HALTGROUP_COUNT(HALTGROUP_COUNT),
    .NHART(NHART),
    .PROGBUF_SIZE(PROGBUF_SIZE),
    .RV_BUS_TYPE("axi"),
    .SYNC_STAGE(SYNC_STAGE),
    .SYSTEM_BUS_ACCESS_SUPPORT(PLDM_SYS_BUS_ACCESS),
    .SYS_ADDR_WIDTH(ADDR_WIDTH),
    .SYS_BUS_TYPE("axi"),
    .SYS_DATA_WIDTH(DM_SYS_DATA_WIDTH),
    .SYS_ID_WIDTH(BIU_ID_WIDTH)
) u_pldm (
    .debugint(dm_debugint),
    .resethaltreq(dm_resethaltreq),
    .dmactive(dmactive),
    .ndmreset(ndmreset),
    .clk(aclk),
    .dmi_resetn(dmi_resetn),
    .hart_nonexistent({NHART{1'b0}}),
    .hart_unavail(dm_hart_unavail),
    .hart_under_reset(dm_hart_under_reset),
    .bus_resetn(aresetn),
    .rv_haddr({ADDR_WIDTH{1'b0}}),
    .rv_htrans(2'd0),
    .rv_hwrite(1'd0),
    .rv_hsize(3'd0),
    .rv_hburst(3'd0),
    .rv_hprot(4'd0),
    .rv_hwdata({NCE_DATA_WIDTH{1'b0}}),
    .rv_hsel(1'd0),
    .rv_hready(1'd0),
    .rv_hrdata(nds_unused_dm_hrdata),
    .rv_hreadyout(nds_unused_dm_hreadyout),
    .rv_hresp(nds_unused_dm_hresp),
    .rv_awid(4'd0),
    .rv_awaddr(dm_awaddr),
    .rv_awlen(dm_awlen),
    .rv_awsize(dm_awsize),
    .rv_awburst(dm_awburst),
    .rv_awlock(dm_awlock),
    .rv_awcache(dm_awcache),
    .rv_awprot(dm_awprot),
    .rv_awvalid(dm_awvalid),
    .rv_awready(dm_awready),
    .rv_wdata(dm_wdata),
    .rv_wstrb(dm_wstrb),
    .rv_wlast(dm_wlast),
    .rv_wvalid(dm_wvalid),
    .rv_wready(dm_wready),
    .rv_bid(nds_unused_dm_bid),
    .rv_bresp(dm_bresp),
    .rv_bvalid(dm_bvalid),
    .rv_bready(dm_bready),
    .rv_arid(4'd0),
    .rv_araddr(dm_araddr),
    .rv_arlen(dm_arlen),
    .rv_arsize(dm_arsize),
    .rv_arburst(dm_arburst),
    .rv_arlock(dm_arlock),
    .rv_arcache(dm_arcache),
    .rv_arprot(dm_arprot),
    .rv_arvalid(dm_arvalid),
    .rv_arready(dm_arready),
    .rv_rid(nds_unused_dm_rid),
    .rv_rdata(dm_rdata),
    .rv_rresp(dm_rresp),
    .rv_rlast(dm_rlast),
    .rv_rvalid(dm_rvalid),
    .rv_rready(dm_rready),
    .sys_awid(dm_sup_awid),
    .sys_awaddr(dm_sup_awaddr),
    .sys_awlen(dm_sup_awlen),
    .sys_awsize(dm_sup_awsize),
    .sys_awburst(dm_sup_awburst),
    .sys_awlock(dm_sup_awlock),
    .sys_awcache(dm_sup_awcache),
    .sys_awprot(dm_sup_awprot),
    .sys_awvalid(dm_sup_awvalid),
    .sys_awready(dm_sup_awready),
    .sys_wdata(dm_sup_wdata),
    .sys_wstrb(dm_sup_wstrb),
    .sys_wlast(dm_sup_wlast),
    .sys_wvalid(dm_sup_wvalid),
    .sys_wready(dm_sup_wready),
    .sys_bid(dm_sup_bid),
    .sys_bresp(dm_sup_bresp),
    .sys_bvalid(dm_sup_bvalid),
    .sys_bready(dm_sup_bready),
    .sys_arid(dm_sup_arid),
    .sys_araddr(dm_sup_araddr),
    .sys_arlen(dm_sup_arlen),
    .sys_arsize(dm_sup_arsize),
    .sys_arburst(dm_sup_arburst),
    .sys_arlock(dm_sup_arlock),
    .sys_arcache(dm_sup_arcache),
    .sys_arprot(dm_sup_arprot),
    .sys_arvalid(dm_sup_arvalid),
    .sys_arready(dm_sup_arready),
    .sys_rid(dm_sup_rid),
    .sys_rdata(dm_sup_rdata),
    .sys_rresp(dm_sup_rresp),
    .sys_rlast(dm_sup_rlast),
    .sys_rvalid(dm_sup_rvalid),
    .sys_rready(dm_sup_rready),
    .sys_haddr(nds_unused_dm_sup_haddr),
    .sys_htrans(nds_unused_dm_sup_htrans),
    .sys_hwrite(nds_unused_dm_sup_hwrite),
    .sys_hsize(nds_unused_dm_sup_hsize),
    .sys_hburst(nds_unused_dm_sup_hburst),
    .sys_hprot(nds_unused_dm_sup_hprot),
    .sys_hwdata(nds_unused_dm_sup_hwdata),
    .sys_hbusreq(nds_unused_dm_sup_hbusreq),
    .sys_hrdata({DM_SYS_DATA_WIDTH{1'b0}}),
    .sys_hready(1'b0),
    .sys_hresp(2'h0),
    .sys_hgrant(1'b0),
    .dmi_haddr(dmi_haddr),
    .dmi_htrans(dmi_htrans),
    .dmi_hwrite(dmi_hwrite),
    .dmi_hsize(dmi_hsize),
    .dmi_hburst(dmi_hburst),
    .dmi_hprot(dmi_hprot),
    .dmi_hwdata(dmi_hwdata),
    .dmi_hsel(dmi_hsel),
    .dmi_hready(dmi_hready),
    .dmi_hrdata(dmi_hrdata),
    .dmi_hreadyout(dmi_hreadyout),
    .dmi_hresp(dmi_hresp),
    .xtrigger_halt_in({(DMXTRIGGER_MSB + 1){1'b0}}),
    .xtrigger_halt_out(nds_unused_xtrigger_halt_out),
    .xtrigger_resume_in({(DMXTRIGGER_MSB + 1){1'b0}}),
    .xtrigger_resume_out(nds_unused_xtrigger_resume_out)
);
generate
    if ((BIU_DATA_WIDTH > DM_SYS_DATA_WIDTH)) begin:gen_axi_dm_sup
        atcsizeup300 #(
            .DS_DATA_WIDTH(SIZEUP_DS_DATA_WIDTH),
            .ID_WIDTH(BIU_ID_WIDTH),
            .US_DATA_WIDTH(DM_SYS_DATA_WIDTH)
        ) u_axi_dm_sup (
            .aclk(aclk),
            .aresetn(aresetn),
            .us_arvalid(dm_sup_arvalid),
            .us_arid(dm_sup_arid),
            .us_araddr(dm_sup_araddr[SIZEUP_ADDR_MSB:0]),
            .us_arlen(dm_sup_arlen[3:0]),
            .us_arsize(dm_sup_arsize),
            .us_arburst(dm_sup_arburst),
            .us_arready(dm_sup_arready),
            .us_awvalid(dm_sup_awvalid),
            .us_awid(dm_sup_awid),
            .us_awaddr(dm_sup_awaddr[SIZEUP_ADDR_MSB:0]),
            .us_awlen(dm_sup_awlen[3:0]),
            .us_awsize(dm_sup_awsize),
            .us_awburst(dm_sup_awburst),
            .us_awready(dm_sup_awready),
            .ds_arvalid(dm_sys_arvalid),
            .ds_arready(dm_sys_arready),
            .ds_awvalid(dm_sys_awvalid),
            .ds_awready(dm_sys_awready),
            .us_rid(dm_sup_rid),
            .us_rvalid(dm_sup_rvalid),
            .us_rdata(dm_sup_rdata),
            .us_rready(dm_sup_rready),
            .ds_rlast(dm_sys_rlast),
            .ds_rvalid(dm_sys_rvalid),
            .ds_rdata(dm_sys_rdata),
            .ds_rready(dm_sys_rready),
            .us_wstrb(dm_sup_wstrb),
            .us_wlast(dm_sup_wlast),
            .us_wvalid(dm_sup_wvalid),
            .us_wdata(dm_sup_wdata),
            .us_wready(dm_sup_wready),
            .ds_wstrb(dm_sys_wstrb),
            .ds_wvalid(dm_sys_wvalid),
            .ds_wdata(dm_sys_wdata),
            .ds_wready(dm_sys_wready),
            .ds_wlast(dm_sys_wlast),
            .us_rlast(dm_sup_rlast),
            .us_rresp(dm_sup_rresp),
            .ds_rresp(dm_sys_rresp),
            .us_bid(dm_sup_bid),
            .us_bvalid(dm_sup_bvalid),
            .us_bready(dm_sup_bready),
            .ds_bvalid(dm_sys_bvalid),
            .ds_bready(dm_sys_bready)
        );
    end
endgenerate
nceplic100 #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .ASYNC_INT(1024'hc000000),
    .DATA_WIDTH(NCE_DATA_WIDTH),
    .PROGRAMMABLE_TRIGGER(0),	//#CYC
    .EDGE_TRIGGER(1024'h0),
    .INT_NUM(127),	//31 #CYC
    .MAX_PRIORITY(3),
    .PLIC_BUS("axi"),
    .SYNC_STAGE(SYNC_STAGE),
    .TARGET_NUM(PLIC_HW_TARGET_NUM[5:0]),
    .VECTOR_PLIC_SUPPORT(VECTOR_PLIC_SUPPORT)
) u_plic (
    .araddr(plic_araddr),
    .arburst(plic_arburst),
    .arcache(plic_arcache),
    .arid(4'd0),
    .arlen(plic_arlen),
    .arlock(plic_arlock),
    .arprot(plic_arprot),
    .arready(plic_arready),
    .arsize(plic_arsize),
    .arvalid(plic_arvalid),
    .awaddr(plic_awaddr),
    .awburst(plic_awburst),
    .awcache(plic_awcache),
    .awid(4'd0),
    .awlen(plic_awlen),
    .awlock(plic_awlock),
    .awprot(plic_awprot),
    .awready(plic_awready),
    .awsize(plic_awsize),
    .awvalid(plic_awvalid),
    .bid(nds_unused_plic_bid),
    .bready(plic_bready),
    .bresp(plic_bresp),
    .bvalid(plic_bvalid),
    .haddr({ADDR_WIDTH{1'b0}}),
    .hburst(3'd0),
    .hrdata(nds_unused_plic_hrdata),
    .hready(1'b0),
    .hreadyout(nds_unused_plic_hreadyout),
    .hresp(nds_unused_plic_hresp),
    .hsel(1'b0),
    .hsize(3'd0),
    .htrans(2'd0),
    .hwdata({NCE_DATA_WIDTH{1'b0}}),
    .hwrite(1'b0),
    .rdata(plic_rdata),
    .rid(nds_unused_plic_rid),
    .rlast(plic_rlast),
    .rready(plic_rready),
    .rresp(plic_rresp),
    .rvalid(plic_rvalid),
    .wdata(plic_wdata),
    .wlast(plic_wlast),
    .wready(plic_wready),
    .wstrb(plic_wstrb),
    .wvalid(plic_wvalid),
    .clk(aclk),
    .reset_n(aresetn),
    .int_src(int_src),
    .t0_eip(plic_hart0_meip),
    .t0_eiid(hart0_meiid),
    .t0_eiack(plic_hart0_meiack),
    .t1_eip(plic_hart0_seip),
    .t1_eiid(hart0_seiid),
    .t1_eiack(plic_hart0_seiack),
    .t2_eip(plic_hart1_meip),
    .t2_eiid(hart1_meiid),
    .t2_eiack(plic_hart1_meiack),
    .t3_eip(plic_hart1_seip),
    .t3_eiid(hart1_seiid),
    .t3_eiack(plic_hart1_seiack),
    .t4_eip(plic_hart2_meip),
    .t4_eiid(hart2_meiid),
    .t4_eiack(plic_hart2_meiack),
    .t5_eip(plic_hart2_seip),
    .t5_eiid(hart2_seiid),
    .t5_eiack(plic_hart2_seiack),
    .t6_eip(plic_hart3_meip),
    .t6_eiid(hart3_meiid),
    .t6_eiack(plic_hart3_meiack),
    .t7_eip(plic_hart3_seip),
    .t7_eiid(hart3_seiid),
    .t7_eiack(plic_hart3_seiack),
    .t8_eip(plic_hart4_meip),
    .t8_eiid(hart4_meiid),
    .t8_eiack(plic_hart4_meiack),
    .t9_eip(plic_hart4_seip),
    .t9_eiid(hart4_seiid),
    .t9_eiack(plic_hart4_seiack),
    .t10_eip(plic_hart5_meip),
    .t10_eiid(hart5_meiid),
    .t10_eiack(plic_hart5_meiack),
    .t11_eip(plic_hart5_seip),
    .t11_eiid(hart5_seiid),
    .t11_eiack(plic_hart5_seiack),
    .t12_eip(plic_hart6_meip),
    .t12_eiid(hart6_meiid),
    .t12_eiack(plic_hart6_meiack),
    .t13_eip(plic_hart6_seip),
    .t13_eiid(hart6_seiid),
    .t13_eiack(plic_hart6_seiack),
    .t14_eip(plic_hart7_meip),
    .t14_eiid(hart7_meiid),
    .t14_eiack(plic_hart7_meiack),
    .t15_eip(plic_hart7_seip),
    .t15_eiid(hart7_seiid),
    .t15_eiack(plic_hart7_seiack)
);
nceplic100 #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(NCE_DATA_WIDTH),
    .EDGE_TRIGGER(1024'd0),
    .INT_NUM(16),
    .MAX_PRIORITY(3),
    .PLIC_BUS("axi"),
    .TARGET_NUM(PLIC_SW_TARGET_NUM[5:0]),
    .VECTOR_PLIC_SUPPORT("no")
) u_plic_sw (
    .araddr(plicsw_araddr),
    .arburst(plicsw_arburst),
    .arcache(plicsw_arcache),
    .arid(4'd0),
    .arlen(plicsw_arlen),
    .arlock(plicsw_arlock),
    .arprot(plicsw_arprot),
    .arready(plicsw_arready),
    .arsize(plicsw_arsize),
    .arvalid(plicsw_arvalid),
    .awaddr(plicsw_awaddr),
    .awburst(plicsw_awburst),
    .awcache(plicsw_awcache),
    .awid(4'd0),
    .awlen(plicsw_awlen),
    .awlock(plicsw_awlock),
    .awprot(plicsw_awprot),
    .awready(plicsw_awready),
    .awsize(plicsw_awsize),
    .awvalid(plicsw_awvalid),
    .bid(nds_unused_plicsw_bid),
    .bready(plicsw_bready),
    .bresp(plicsw_bresp),
    .bvalid(plicsw_bvalid),
    .haddr({ADDR_WIDTH{1'b0}}),
    .hburst(3'd0),
    .hrdata(nds_unused_plicsw_hrdata),
    .hready(1'b0),
    .hreadyout(nds_unused_plicsw_hreadyout),
    .hresp(nds_unused_plicsw_hresp),
    .hsel(1'b0),
    .hsize(3'd0),
    .htrans(2'd0),
    .hwdata({NCE_DATA_WIDTH{1'b0}}),
    .hwrite(1'b0),
    .rdata(plicsw_rdata),
    .rid(nds_unused_plicsw_rid),
    .rlast(plicsw_rlast),
    .rready(plicsw_rready),
    .rresp(plicsw_rresp),
    .rvalid(plicsw_rvalid),
    .wdata(plicsw_wdata),
    .wlast(plicsw_wlast),
    .wready(plicsw_wready),
    .wstrb(plicsw_wstrb),
    .wvalid(plicsw_wvalid),
    .clk(aclk),
    .reset_n(aresetn),
    .int_src(16'd0),
    .t0_eip(plicsw_hart0_msip),
    .t0_eiid(nds_unused_plicsw_t0_eiid),
    .t0_eiack(1'b0),
    .t1_eip(plicsw_hart1_msip),
    .t1_eiid(nds_unused_plicsw_t1_eiid),
    .t1_eiack(1'b0),
    .t2_eip(plicsw_hart2_msip),
    .t2_eiid(nds_unused_plicsw_t2_eiid),
    .t2_eiack(1'b0),
    .t3_eip(plicsw_hart3_msip),
    .t3_eiid(nds_unused_plicsw_t3_eiid),
    .t3_eiack(1'b0),
    .t4_eip(plicsw_hart4_msip),
    .t4_eiid(nds_unused_plicsw_t4_eiid),
    .t4_eiack(1'b0),
    .t5_eip(plicsw_hart5_msip),
    .t5_eiid(nds_unused_plicsw_t5_eiid),
    .t5_eiack(1'b0),
    .t6_eip(plicsw_hart6_msip),
    .t6_eiid(nds_unused_plicsw_t6_eiid),
    .t6_eiack(1'b0),
    .t7_eip(plicsw_hart7_msip),
    .t7_eiid(nds_unused_plicsw_t7_eiid),
    .t7_eiack(1'b0),
    .t8_eip(nds_unused_plicsw_t8_eip),
    .t8_eiid(nds_unused_plicsw_t8_eiid),
    .t8_eiack(1'b0),
    .t9_eip(nds_unused_plicsw_t9_eip),
    .t9_eiid(nds_unused_plicsw_t9_eiid),
    .t9_eiack(1'b0),
    .t10_eip(nds_unused_plicsw_t10_eip),
    .t10_eiid(nds_unused_plicsw_t10_eiid),
    .t10_eiack(1'b0),
    .t11_eip(nds_unused_plicsw_t11_eip),
    .t11_eiid(nds_unused_plicsw_t11_eiid),
    .t11_eiack(1'b0),
    .t12_eip(nds_unused_plicsw_t12_eip),
    .t12_eiid(nds_unused_plicsw_t12_eiid),
    .t12_eiack(1'b0),
    .t13_eip(nds_unused_plicsw_t13_eip),
    .t13_eiid(nds_unused_plicsw_t13_eiid),
    .t13_eiack(1'b0),
    .t14_eip(nds_unused_plicsw_t14_eip),
    .t14_eiid(nds_unused_plicsw_t14_eiid),
    .t14_eiack(1'b0),
    .t15_eip(nds_unused_plicsw_t15_eip),
    .t15_eiid(nds_unused_plicsw_t15_eiid),
    .t15_eiack(1'b0)
);
kv_clkdiv #(
    .RATIO(2)
) u_l2c_bank0_data_ram_clkgen (
    .clk_in(l2_clk),
    .resetn(l2_resetn),
    .clk_en(l2c_bank0_data_ram_clk_en),
    .clk_out(l2c_bank0_data_ram_clk)
);
kv_clkdiv #(
    .RATIO(2)
) u_l2c_bank1_data_ram_clkgen (
    .clk_in(l2_clk),
    .resetn(l2_resetn),
    .clk_en(l2c_bank1_data_ram_clk_en),
    .clk_out(l2c_bank1_data_ram_clk)
);
generate
    if (COMPLEX_BRG_TYPE == 2 || BIU_ASYNC_SUPPORT == 1) begin:gen_core0_sync
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_debugint0_sync (
            .resetn(core0_reset_n),
            .clk(core0_clk),
            .d(dm_debugint[0]),
            .q(hart0_debugint)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_resethaltreq0_sync (
            .resetn(core0_reset_n),
            .clk(core0_clk),
            .d(dm_resethaltreq[0]),
            .q(hart0_resethaltreq)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_seip0_sync (
            .resetn(core0_reset_n),
            .clk(core0_clk),
            .d(plic_hart0_seip),
            .q(hart0_seip)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_seiack0_sync (
            .resetn(aresetn),
            .clk(aclk),
            .d(hart0_seiack),
            .q(plic_hart0_seiack)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_meip0_sync (
            .resetn(core0_reset_n),
            .clk(core0_clk),
            .d(plic_hart0_meip),
            .q(hart0_meip)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_meiack0_sync (
            .resetn(aresetn),
            .clk(aclk),
            .d(hart0_meiack),
            .q(plic_hart0_meiack)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_msip0_sync (
            .resetn(core0_reset_n),
            .clk(core0_clk),
            .d(plicsw_hart0_msip),
            .q(hart0_msip)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_mtip0_sync (
            .resetn(core0_reset_n),
            .clk(core0_clk),
            .d(mtip[0]),
            .q(hart0_mtip)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_stoptime0_sync (
            .resetn(aresetn),
            .clk(aclk),
            .d(hart0_stoptime),
            .q(plmt_hart0_stoptime)
        );
    end
endgenerate
generate
    if (COMPLEX_BRG_TYPE == 2 || BIU_ASYNC_SUPPORT == 1) begin:gen_core1_sync
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_debugint1_sync (
            .resetn(core1_reset_n),
            .clk(core1_clk),
            .d(dm_debugint[1]),
            .q(hart1_debugint)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_resethaltreq1_sync (
            .resetn(core1_reset_n),
            .clk(core1_clk),
            .d(dm_resethaltreq[1]),
            .q(hart1_resethaltreq)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_seip1_sync (
            .resetn(core1_reset_n),
            .clk(core1_clk),
            .d(plic_hart1_seip),
            .q(hart1_seip)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_seiack1_sync (
            .resetn(aresetn),
            .clk(aclk),
            .d(hart1_seiack),
            .q(plic_hart1_seiack)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_meip1_sync (
            .resetn(core1_reset_n),
            .clk(core1_clk),
            .d(plic_hart1_meip),
            .q(hart1_meip)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_meiack1_sync (
            .resetn(aresetn),
            .clk(aclk),
            .d(hart1_meiack),
            .q(plic_hart1_meiack)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_msip1_sync (
            .resetn(core1_reset_n),
            .clk(core1_clk),
            .d(plicsw_hart1_msip),
            .q(hart1_msip)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_mtip1_sync (
            .resetn(core1_reset_n),
            .clk(core1_clk),
            .d(mtip[1]),
            .q(hart1_mtip)
        );
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_stoptime1_sync (
            .resetn(aresetn),
            .clk(aclk),
            .d(hart1_stoptime),
            .q(plmt_hart1_stoptime)
        );
    end
endgenerate
generate
    if (BIU_ASYNC_SUPPORT == 1) begin:gen_l2_sync
        kv_sync_l2l #(
            .RESET_VALUE(1'b0),
            .SYNC_STAGE(SYNC_STAGE)
        ) u_l2c_err_int_sync (
            .resetn(aresetn),
            .clk(aclk),
            .d(l2c_err_int_int),
            .q(l2c_err_int)
        );
    end
endgenerate
endmodule

