#winnie_s
#alias vnc 'vncserver :58 -geometry 2560x1440 -depth 24 -dpi 109'
#alias vnck 'vncserver -kill :58'
#alias naseda  '/autohome/AI/eda'
#alias nasip   '/autohome/AI/ip'
#alias nastech '/autohome/AI/tech'
#alias cdh 'cd /runtmph1/ailab/home/cyc'
#alias cdht 'cd /runtmph1/ailab/tools'
#alias cdst 'cd /autohome/AI/tools'
#alias arc 'ARChitect2 &'
#alias cc 'coreConsultant&'
#alias ca 'coreAssembler&'
#alias int 'integrator&'
##alias vim 'gvim'
#alias cdsim 'cd /runtmph1/user/aiallen/prj_neuchips/sim'
#alias cdnetlist 'cd /runtmph1/netlist'
##alias cdsrc 'cd /autohome/AI/user/aiallen/AILAB'
#alias cdsrc 'cd /runtmph1/user/aiallen/prj_ailab/AILAB'
#alias cdsyn 'cd /runtmph1/user/aiallen/prj_ailab/syn_top'
#alias cdnetlist 'cd /runtmph1/netlist/'
#winnie_e
#setenv CDS_LIC_FILE 35280@satum
#setenv SNPSLMD_LICENSE_FILE 31750@satum:27020@aplab12:27020@aplab13
#setenv SYNOPSYS /runtmps1/ailab/tools/eda/snps
#setenv SYNOPSYS /autohome/AI/tools/eda/snps
unsetenv SNPSLMD_LICENSE_FILE
#setenv LM_LICENSE_FILE 27020@aplab12:27020@aplab13:31750@satum:27020@DESKTOP-4C1SN99
setenv LM_LICENSE_FILE 27020@aplab12:27020@aplab13:31750@satum:27020@DESKTOP-4C1SN99:27020@aplab15:27020@aplab14:31750@mars
setenv SYNOPSYS_HOME /autohome/AI/tools/eda/snps
#setenv DESIGNWARE_HOME /autohome/AI/tools/neuchip_ip
setenv DESIGNWARE_HOME /autohome/AI/tools/ip
#setenv VCS_HOME $SYNOPSYS_HOME/vcs/R-2020.12-SP1
setenv VCS_HOME $SYNOPSYS_HOME/vcs/V-2023.12-SP2
#setenv DC_HOME  $SYNOPSYS_HOME/syn/Q-2019.12-SP4
setenv DC_HOME  $SYNOPSYS_HOME/syn/V-2023.12-SP5
setenv SYNOPSYS $DC_HOME
#setenv NOVAS_HOME $SYNOPSYS_HOME/verdi/R-2020.12-SP1
#setenv VERDI_HOME $SYNOPSYS_HOME/verdi/R-2020.12-SP1
setenv VERDI_HOME $SYNOPSYS_HOME/verdi/V-2023.12-SP2
setenv METAWARE_ROOT "$SYNOPSYS_HOME/MW_ARC/MetaWare"
setenv ARCHITECT_ROOT "$SYNOPSYS_HOME/ARChitect_W-2024.09/ARChitect"
setenv VERILATOR_ROOT "$SYNOPSYS_HOME/ARChitect_W-2024.09/xCAM"
#setenv VC_STATIC_HOME "$SYNOPSYS_HOME/vc_static/R-2020.12-1"
setenv VC_STATIC_HOME "$SYNOPSYS_HOME/vc_static/V-2023.12-SP2"
#setenv SPYGLASS_HOME $SYNOPSYS_HOME/spyglass/R-2020.12-SP2/SPYGLASS_HOME
setenv SPYGLASS_HOME $SYNOPSYS_HOME/spyglass/V-2023.12-SP2/SPYGLASS_HOME
setenv VC_SPYGLASS_HANDOFF_KIT_DIR ../vc_spyglass_handoff_kit_P-2019.06_v1
#setenv NDS_HOME /autohome/AI/user/aicyc/edge/ax45mp_8c
#setenv NDS_HOME /autohome/AI/user/aicyc/common/ax45mpv_advanced
setenv PATH  "$SYNOPSYS_HOME/installer_v5.1:$PATH"
setenv PATH  "$SYNOPSYS_HOME/icc2/Q-2019.12-SP1/bin:$PATH"
setenv PATH  "$SYNOPSYS_HOME/MW_ARC/MetaWare/arc/bin64:$PATH"
#setenv PATH  "$SYNOPSYS_HOME/coretools/R-2020.12-SP3/bin:$PATH"
#setenv PATH  "$SYNOPSYS_HOME/coretools/Q-2020.03-SP3/bin:$PATH"
setenv PATH  "$SYNOPSYS_HOME/coretools/V-2024.03/bin:$PATH"
#setenv PATH  "$SYNOPSYS_HOME/coretools/W-2024.09/bin:$PATH"
#setenv PATH  "$SYNOPSYS_HOME/vcs/R-2020.12-SP1/bin:$PATH"
setenv PATH  "$SYNOPSYS_HOME/vcs/V-2023.12-SP2/bin:$PATH"
#setenv PATH  "$SYNOPSYS_HOME/vc_static/Q-2020.03-SP1/bin:$PATH"
setenv PATH  "$SYNOPSYS_HOME/vc_static/V-2023.12-SP2/bin:$PATH"
#setenv PATH  "$SYNOPSYS_HOME/fm/R-2020.09-SP5/bin:$PATH"
setenv PATH  "$SYNOPSYS_HOME/fm/V-2023.12-SP5/bin:$PATH"
setenv PATH  "$SYNOPSYS_HOME/scl/2021.03/linux64/bin:$PATH"
#setenv PATH  "$SYNOPSYS_HOME/verdi/R-2020.12-SP1/bin:$PATH"
setenv PATH  "$SYNOPSYS_HOME/verdi/V-2023.12-SP2/bin:$PATH"
#setenv PATH  "$SYNOPSYS_HOME/syn/Q-2019.12-SP4/bin:$PATH"
setenv PATH  "$SYNOPSYS_HOME/syn/V-2023.12-SP5/bin:$PATH"
#setenv PATH  "$SYNOPSYS_HOME/pts/Q-2019.12-SP1/bin:$PATH"
setenv PATH  "$SYNOPSYS_HOME/pts/V-2023.12-SP5/bin:$PATH"
setenv PATH  "$SYNOPSYS_HOME/vera/vera_vI-2014.03-1_linux/bin:$PATH"
setenv PATH  "$SYNOPSYS_HOME/scl/2018.06-SP1/linux64/bin:$PATH"
#setenv PATH  "$SYNOPSYS_HOME/prime/R-2020.09-SP5/bin:$PATH"
setenv PATH  "$SYNOPSYS_HOME/prime/V-2023.12-SP5/bin:$PATH"
#setenv PATH  "$SYNOPSYS_HOME/embedit/R-2021.03/bin:$PATH"
setenv PATH  "$SYNOPSYS_HOME/embedit/W-2024.12/bin:$PATH"
#setenv PATH  "$SYNOPSYS_HOME/ARC/ARChitect/bin/linux64:$PATH"
setenv PATH  "$SYNOPSYS_HOME/ARChitect_W-2024.09/ARChitect/bin/linux64:$PATH"
setenv PATH  "$SYNOPSYS_HOME/lc/Q-2019.12-SP1/bin:$PATH"
setenv PATH  "$SYNOPSYS_HOME/customcompiler/Q-2020.03/bin:$PATH"
setenv PATH  "$ARCHITECT_ROOT/../xCAM/bin:$PATH"
setenv PATH  "$SYNOPSYS_HOME/protocomp/O-2018.09/bin:$PATH"
setenv PATH  "$DESIGNWARE_HOME/bin:$PATH"
setenv PATH  /autohome/AI/tools/eda/xilinx/Vivado/2018.3/bin:$PATH
setenv PATH  "$METAWARE_ROOT/arc/bin:$PATH"
#winnie
#setenv PATH  "$NDS_HOME/tools/bin:$PATH"
setenv PATH  /usr/bin:$PATH
#setenv TRANSACTOR_DIR /autohome/AI/user/aiallen/ARChitect_folder/HAPS_XACTOR
#setenv XILINX_VIVADO /autohome/AI/user/aiallen/ARChitect_folder/HAPS_XACTOR
setenv VERA_HOME "$SYNOPSYS_HOME/vera/vera_vI-2014.03-1_linux"
setenv COMPLIB /autohome/AI/tools/tech/v-comp
setenv TECH_LIB  "ts12ncfslogl20esh096f_ssgnp0p72vn40c.db  ts12ncfllogl20esh096f_ssgnp0p72vn40c.db"
setenv TECH_LIB_PATH "/autohome/AI/tools/tech/v-logic/v-logic_ts12ncfslogl20esh096f/DesignWare_logic_libs/tsmc12nllf/20hd/esh/svt/3.02a/liberty/logic_synth /autohome/AI/tools/tech/v-logic/v-logic_ts12ncfllogl20esh096f/DesignWare_logic_libs/tsmc12nllf/20hd/esh/lvt/3.02a/liberty/logic_synth"
setenv PAD_LIB "tphn16ffcllgv18essgnp0p72v1p62vm40c.db"
setenv PAD_LIB_PATH "/autohome/AI/tools/tech/ailab_tech/tphn16ffcllgv18e_110i_F/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tphn16ffcllgv18e_110i"
setenv DDRPHY_LIB "dwc_ddrphymaster_top_ss0p72vn40c_rcworst_CCworst.db dwc_ddrphyacx4_top_ew_ss0p72vn40c_rcworst_CCworst.db dwc_ddrphydbyte_top_ew_ss0p72vn40c_rcworst_CCworst.db"
setenv DDRPHY_LIB_PATH "/autohome/AI/tools/ip/synopsys/dwc_lpddr4_multiphy_v2_tsmc16ffc18/3.00a/master/3.20a/timing/7M_2Xa1Xd_h_3Xe_vhv/lib /autohome/AI/tools/ip/synopsys/dwc_lpddr4_multiphy_v2_tsmc16ffc18/3.00a/acx4_ew/3.00a/timing/7M_2Xa1Xd_h_3Xe_vhv/lib /autohome/AI/tools/ip/synopsys/dwc_lpddr4_multiphy_v2_tsmc16ffc18/3.00a/dbyte_ew/3.00a/timing/7M_2Xa1Xd_h_3Xe_vhv/lib"
setenv USBPHY_LIB "dwc_usb3_pads_sspx1_hspx1_ns_ss0p72vn40c_rcworst_CCworst.db dwc_usb3_sspx1_hspx1_ns_ss0p72vn40c_rcworst_CCworst.db"
setenv USBPHY_LIB_PATH "/autohome/AI/tools/ip/synopsys/dwc_usb3_femtophy_otg_tsmc16ffc_x1ns/4.03b/phy/4.03b/timing/9M_2Xa1Xd_h_3Xe_vhv_2Z/lib /autohome/AI/tools/ip/synopsys/dwc_usb3_femtophy_otg_tsmc16ffc_x1ns/4.03b/pads_fc/4.03a/timing/9M_2Xa1Xd_h_3Xe_vhv_2Z/lib"
setenv PLL_LIB "dwc_z19606_ns_ss0p72vn40c_rcworst_CCworst.db"
setenv PLL_LIB_PATH "/autohome/AI/tools/ip/synopsys/dwc_pll5ghz_tsmc16ffcns/2.30a/macro/timing/lib"
setenv MIPIPHY_LIB "dwc_mipi_2_rx_dphy_ns_core_ss0p72vn40c_rcworst_CCworst.db dwc_mipi_2_rx_io_ss0p72vn40c_rcworst_CCworst.db"
setenv MIPIPHY_LIB_PATH "/autohome/AI/tools/ip/synopsys/dwc_mipi_d_r2_tsmc16ffc18ns/7.05a/macro/timing/9M_2Xa1Xd_h_3Xe_vhv_2Z/lib /autohome/AI/tools/ip/synopsys/dwc_mipi_d_r2_tsmc16ffc18ns/7.05a/pads_fc/timing/9M_2Xa1Xd_h_3Xe_vhv_2Z/lib"
setenv SDPHY_LIB "dwc_emmc_sd_phy3318_full_ssg0p72vn40c_rcworst_ccworst.db"
setenv SDPHY_LIB_PATH "/autohome/AI/tools/ip/synopsys/dwc_sd_emmc_tsmc16ffc/1.02c/emmc_sd_phy3318/1.02c/timing/9M_2Xa1Xd_h_3Xe_vhv_2Z/full/lib"
setenv NOVAS_LIBS "$TECH_LIB $PAD_LIB $DDRPHY_LIB $USBPHY_LIB $PLL_LIB $MIPIPHY_LIB $SDPHY_LIB"
setenv NOVAS_LIBPATHS "$TECH_LIB_PATH $PAD_LIB_PATH $DDRPHY_LIB_PATH $USBPHY_LIB_PATH $PLL_LIB_PATH $MIPIPHY_LIB_PATH $SDPHY_LIB_PATH"
#setenv FLEXLM_DIAGNOSTICS 3

#SET IP MIPI 
setenv CSI2_HOST_PHY_PATH "/autohome/AI/tools/ip/synopsys/dwc_mipi_d_r2_tsmc16ffc18ns/7.05a/macro"
setenv CSI2_HOST_PHY_LIBNAME "/autohome/AI/tools/ip/synopsys/dwc_mipi_d_r2_tsmc16ffc18ns/7.05a/macro/timing/9M_2Xa1Xd_h_3Xe_vhv_2Z/lib/dwc_mipi_2_rx_dphy_ns_core_ss0p72vn40c_rcworst_CCworst.db"

#setenv LD_LIBRARY_PATH $ARCHITECT_ROOT/lib/linux_x86_64:$ARCHITECT_ROOT/lib/linux:$LD_LIBRARY_PATH
#if ( ! $?PATH ) then
#	setenv PATH ""	
#endif
#setenv PATH "${ARCHITECT_ROOT}/bin/linux64:${VERILATOR_ROOT}/i686-RHEL4-gcc-3.2.3/bin:${VERILATOR_ROOT}/bin:${PATH}"
if ( ! $?LD_LIBRARY_PATH ) then
	setenv LD_LIBRARY_PATH ""	
endif
setenv LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:${ARCHITECT_ROOT}/lib/linux_x86_64:${ARCHITECT_ROOT}/lib/linux"
#setenv METAWARE_ROOT "$SYNOPSYS_HOME/MW_ARC/MetaWare"

#setenv METAWARE_ROOT ""$SYNOPSYS_HOME/MW_ARC/MetaWare""
setenv NSIM_HOME ""$SYNOPSYS_HOME/MW_ARC_2024.09/nSIM/nSIM_64""
# Do NOT modify these lines; they are used to uninstall.
if ( ! $?LD_LIBRARY_PATH ) then
	setenv LD_LIBRARY_PATH ""	
endif
setenv LD_LIBRARY_PATH "$SYNOPSYS_HOME/MW_ARC_2024.09/license/bin:${LD_LIBRARY_PATH}"
# Do NOT modify these lines; they are used to uninstall.
if ( ! $?LD_LIBRARY_PATH ) then
	setenv LD_LIBRARY_PATH ""	
endif
setenv LD_LIBRARY_PATH "$SYNOPSYS_HOME/MW_ARC_2024.09/MetaWare/arc/bin:${LD_LIBRARY_PATH}"
# Do NOT modify these lines; they are used to uninstall.
if ( ! $?PATH ) then
	setenv PATH ""	
endif
setenv PATH "$SYNOPSYS_HOME/MW_ARC_2024.09/MetaWare/ide:${PATH}"
# Do NOT modify these lines; they are used to uninstall.
if ( ! $?PATH ) then
	setenv PATH ""	
endif
setenv PATH "$SYNOPSYS_HOME/MW_ARC_2024.09/MetaWare/arc/bin:${PATH}"
# End comments by InstallAnywhere on Wed May 13 11:36:44 CST 2020 6.

# New environment setting added by MetaWare Development Toolkit on Wed May 13 11:36:44 CST 2020 7.
# The unmodified version of this file is saved in /autohome/AI/user/aiallen/.cshrc55501141.
# Do NOT modify these lines; they are used to uninstall.
if ( ! $?LD_LIBRARY_PATH ) then
	setenv LD_LIBRARY_PATH ""	
endif
setenv LD_LIBRARY_PATH "$SYNOPSYS_HOME/MW_ARC_2024.09/nSIM/nSIM_64/lib:${LD_LIBRARY_PATH}"
# End comments by InstallAnywhere on Wed May 13 11:36:44 CST 2020 7.

# New environment setting added by MetaWare Development Toolkit on Wed May 13 11:36:44 CST 2020 8.
# The unmodified version of this file is saved in /autohome/AI/user/aiallen/.cshrc55501141.
# Do NOT modify these lines; they are used to uninstall.
if ( ! $?PATH ) then
	setenv PATH ""	
endif
setenv PATH "$SYNOPSYS_HOME/MW_ARC_2024.09/nSIM/nSIM/bin:${PATH}"
# End comments by InstallAnywhere on Wed May 13 11:36:44 CST 2020 8.
# The unmodified version of this file is saved in /autohome/AI/user/aiallen/.cshrc1740229911.
# Do NOT modify these lines; they are used to uninstall.
if ( ! $?PATH ) then
	setenv PATH ""	
endif
setenv PATH "${ARCHITECT_ROOT}/bin/linux64:${VERILATOR_ROOT}/i686-RHEL4-gcc-3.2.3/bin:${VERILATOR_ROOT}/bin:${PATH}"
# End comments by InstallAnywhere on Tue Sep 29 11:36:00 CST 2020 5.

# New environment setting added by ARChitect IP Configurator on Tue Sep 29 11:36:00 CST 2020 7.
# The unmodified version of this file is saved in /autohome/AI/user/aiallen/.cshrc1740229911.
# Do NOT modify these lines; they are used to uninstall.
if ( ! $?LD_LIBRARY_PATH ) then
	setenv LD_LIBRARY_PATH ""	
endif
setenv LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:${ARCHITECT_ROOT}/lib/linux_x86_64:${VERILATOR_ROOT}/bin"
# End comments by InstallAnywhere on Tue Sep 29 11:36:00 CST 2020 7.


# New environment setting added by MetaWare Development Toolkit on Wed Dec 09 16:35:37 CST 2020 1.
# The unmodified version of this file is saved in /autohome/AI/user/aiallen/.cshrc1993157003.
# Do NOT modify these lines; they are used to uninstall.
setenv NSIM_HOME ""/autohome/AI/tools/eda/snps/MW_ARC_2024.09/nSIM/nSIM_64""
# End comments by InstallAnywhere on Thu Feb 13 10:36:11 CST 2025 2.

# New environment setting added by MetaWare Development Toolkit on Thu Feb 13 10:36:11 CST 2025 3.
# The unmodified version of this file is saved in /autohome/AI/user/aiallen/.cshrc236056808.
# Do NOT modify these lines; they are used to uninstall.
if ( ! $?LD_LIBRARY_PATH ) then
	setenv LD_LIBRARY_PATH ""	
endif
setenv LD_LIBRARY_PATH "/autohome/AI/tools/eda/snps/MW_ARC_2024.09/license/bin:${LD_LIBRARY_PATH}"
# End comments by InstallAnywhere on Thu Feb 13 10:36:11 CST 2025 3.

# New environment setting added by MetaWare Development Toolkit on Thu Feb 13 10:36:11 CST 2025 4.
# The unmodified version of this file is saved in /autohome/AI/user/aiallen/.cshrc236056808.
# Do NOT modify these lines; they are used to uninstall.
if ( ! $?LD_LIBRARY_PATH ) then
	setenv LD_LIBRARY_PATH ""	
endif
setenv LD_LIBRARY_PATH "/autohome/AI/tools/eda/snps/MW_ARC_2024.09/MetaWare/arc/bin:${LD_LIBRARY_PATH}"
# End comments by InstallAnywhere on Thu Feb 13 10:36:11 CST 2025 4.

# New environment setting added by MetaWare Development Toolkit on Thu Feb 13 10:36:11 CST 2025 5.
# The unmodified version of this file is saved in /autohome/AI/user/aiallen/.cshrc236056808.
# Do NOT modify these lines; they are used to uninstall.
if ( ! $?LD_LIBRARY_PATH ) then
	setenv LD_LIBRARY_PATH ""	
endif
setenv LD_LIBRARY_PATH "/autohome/AI/tools/eda/snps/MW_ARC_2024.09/nSIM/nSIM_64/lib:${LD_LIBRARY_PATH}"
# End comments by InstallAnywhere on Thu Feb 13 10:36:11 CST 2025 5.

# New environment setting added by MetaWare Development Toolkit on Thu Feb 13 10:36:11 CST 2025 6.
# The unmodified version of this file is saved in /autohome/AI/user/aiallen/.cshrc236056808.
# Do NOT modify these lines; they are used to uninstall.
if ( ! $?PATH ) then
	setenv PATH ""	
endif
setenv PATH "/autohome/AI/tools/eda/snps/MW_ARC_2024.09/nSIM/nSIM_64/bin:${PATH}"
# End comments by InstallAnywhere on Thu Feb 13 10:36:11 CST 2025 6.

# New environment setting added by MetaWare Development Toolkit on Thu Feb 13 10:36:11 CST 2025 7.
# The unmodified version of this file is saved in /autohome/AI/user/aiallen/.cshrc236056808.
# Do NOT modify these lines; they are used to uninstall.
if ( ! $?PATH ) then
	setenv PATH ""	
endif
setenv PATH "/autohome/AI/tools/eda/snps/MW_ARC_2024.09/MetaWare/ide:${PATH}"
# End comments by InstallAnywhere on Thu Feb 13 10:36:11 CST 2025 7.

# New environment setting added by MetaWare Development Toolkit on Thu Feb 13 10:56:51 CST 2025 1.
# The unmodified version of this file is saved in /autohome/AI/user/aiallen/.cshrc357192276.
# Do NOT modify these lines; they are used to uninstall.
setenv METAWARE_ROOT ""/autohome/AI/tools/eda/snps/MW_ARC_2024.09/MetaWare""
# End comments by InstallAnywhere on Thu Feb 13 10:56:51 CST 2025 1.

# New environment setting added by MetaWare Development Toolkit on Thu Feb 13 10:56:51 CST 2025 2.
# The unmodified version of this file is saved in /autohome/AI/user/aiallen/.cshrc357192276.
# Do NOT modify these lines; they are used to uninstall.
setenv NSIM_HOME ""/autohome/AI/tools/eda/snps/MW_ARC_2024.09/nSIM/nSIM_64""
# End comments by InstallAnywhere on Thu Feb 13 10:56:51 CST 2025 2.

# New environment setting added by MetaWare Development Toolkit on Thu Feb 13 10:56:51 CST 2025 3.
# The unmodified version of this file is saved in /autohome/AI/user/aiallen/.cshrc357192276.
# Do NOT modify these lines; they are used to uninstall.
if ( ! $?LD_LIBRARY_PATH ) then
	setenv LD_LIBRARY_PATH ""	
endif
setenv LD_LIBRARY_PATH "/autohome/AI/tools/eda/snps/MW_ARC_2024.09/license/bin:${LD_LIBRARY_PATH}"
# End comments by InstallAnywhere on Thu Feb 13 10:56:51 CST 2025 3.

# New environment setting added by MetaWare Development Toolkit on Wed Dec 09 16:35:37 CST 2020 8.
# The unmodified version of this file is saved in /autohome/AI/user/aiallen/.cshrc1993157003.
# Do NOT modify these lines; they are used to uninstall.
if ( ! $?PATH ) then
	setenv PATH ""	
endif
setenv PATH "/autohome/AI/tools/eda/snps/mw/nSIM/nSIM/bin:${PATH}"

#setenv NDS_TOOLCHAIN /autohome/AI/tools/Andestech/AndeSight_STD_v511/toolchains/nds64le-elf-mculib-v5/bin
#setenv NDS_TOOLCHAIN /autohome/AI/tools/Andestech/AndeSight_STD_v511/toolchains/nds64le-elf-mculib-v5f/bin
#setenv NDS_TOOLCHAIN /autohome/AI/tools/Andestech/AndeSight_STD_v511/toolchains/nds64le-elf-mculib-v5d/bin
#------- Andes Env. 2024/06 add
setenv NDS_TOOLCHAIN /autohome/AI/user/aicwchen/Andestech/AndeSight_STD_v521/toolchains/nds64le-elf-mculib-v5/bin
setenv NDS_COPILOT   /autohome/AI/user/aicwchen/Andestech/AndeSight_STD_v521/COPILOT

#source /runtmph1/user/airandy/vivado_source/2021_2/settings64.csh

# End comments by InstallAnywhere on Wed Dec 09 16:35:37 CST 2020 8.
source ~/myaplab13/cshrc_www_prompt
