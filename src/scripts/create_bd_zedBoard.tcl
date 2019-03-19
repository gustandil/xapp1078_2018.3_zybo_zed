
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART em.avnet.com:zed:part0:1.0 [current_project]


# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}


# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} ne "" && ${cur_design} eq ${design_name} } {

   # Checks if design is empty or not
   if { $list_cells ne "" } {
      set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
      set nRet 1
   } else {
      puts "INFO: Constructing design in IPI design <$design_name>..."
   }
} elseif { ${cur_design} ne "" && ${cur_design} ne ${design_name} } {

   if { $list_cells eq "" } {
      puts "INFO: You have an empty design <${cur_design}>. Will go ahead and create design..."
   } else {
      set errMsg "ERROR: Design <${cur_design}> is not empty! Please do not source this script on non-empty designs."
      set nRet 1
   }
} else {

   if { [get_files -quiet ${design_name}.bd] eq "" } {
      puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

      create_bd_design $design_name

      puts "INFO: Making design <$design_name> as current_bd_design."
      current_bd_design $design_name

   } else {
      set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
      set nRet 3
   }

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports

  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0 ]
  set_property -dict [ list CONFIG.C_MONITOR_TYPE {Native} CONFIG.C_NUM_OF_PROBES {4}  ] $ila_0

  # Create instance: irq_gen_0, and set properties
  set irq_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:irq_gen:1.1 irq_gen_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {142.857132} CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {50.000000} CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {50.000000} CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {50.000000} CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {50.000000} CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666667} CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_CLK0_FREQ {100000000} CONFIG.PCW_CLK1_FREQ {142857132} CONFIG.PCW_CORE1_IRQ_INTR {1} CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} CONFIG.PCW_ENET0_RESET_ENABLE {0} CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} CONFIG.PCW_ENET1_RESET_ENABLE {0} CONFIG.PCW_ENET1_RESET_IO {<Select>} CONFIG.PCW_ENET_RESET_POLARITY {Active Low} CONFIG.PCW_EN_4K_TIMER {0} CONFIG.PCW_EN_EMIO_TTC0 {1} CONFIG.PCW_EN_ENET0 {1} CONFIG.PCW_EN_QSPI {1} CONFIG.PCW_EN_SDIO0 {1} CONFIG.PCW_EN_TTC0 {1} CONFIG.PCW_EN_UART1 {1} CONFIG.PCW_EN_USB0 {1} CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.000000} CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {150.000000} CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {50.000000} CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {0} CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} CONFIG.PCW_I2C1_RESET_ENABLE {0} CONFIG.PCW_I2C1_RESET_IO {<Select>} CONFIG.PCW_I2C_RESET_POLARITY {Active Low} CONFIG.PCW_MIO_0_DIRECTION {inout} CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_0_PULLUP {disabled} CONFIG.PCW_MIO_0_SLEW {slow} CONFIG.PCW_MIO_10_DIRECTION {inout} CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_10_PULLUP {disabled} CONFIG.PCW_MIO_10_SLEW {slow} CONFIG.PCW_MIO_11_DIRECTION {inout} CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_11_PULLUP {disabled} CONFIG.PCW_MIO_11_SLEW {slow} CONFIG.PCW_MIO_12_DIRECTION {inout} CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_12_PULLUP {disabled} CONFIG.PCW_MIO_12_SLEW {slow} CONFIG.PCW_MIO_13_DIRECTION {inout} CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_13_PULLUP {disabled} CONFIG.PCW_MIO_13_SLEW {slow} CONFIG.PCW_MIO_14_DIRECTION {inout} CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_14_PULLUP {disabled} CONFIG.PCW_MIO_14_SLEW {slow} CONFIG.PCW_MIO_15_DIRECTION {inout} CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_15_PULLUP {disabled} CONFIG.PCW_MIO_15_SLEW {slow} CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_16_PULLUP {disabled} CONFIG.PCW_MIO_16_SLEW {fast} CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_17_PULLUP {disabled} CONFIG.PCW_MIO_17_SLEW {fast} CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_18_PULLUP {disabled} CONFIG.PCW_MIO_18_SLEW {fast} CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_19_PULLUP {disabled} CONFIG.PCW_MIO_19_SLEW {fast} CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_1_PULLUP {disabled} CONFIG.PCW_MIO_1_SLEW {fast} CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_20_PULLUP {disabled} CONFIG.PCW_MIO_20_SLEW {fast} CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_21_PULLUP {disabled} CONFIG.PCW_MIO_21_SLEW {fast} CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_22_PULLUP {disabled} CONFIG.PCW_MIO_22_SLEW {fast} CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_23_PULLUP {disabled} CONFIG.PCW_MIO_23_SLEW {fast} CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_24_PULLUP {disabled} CONFIG.PCW_MIO_24_SLEW {fast} CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_25_PULLUP {disabled} CONFIG.PCW_MIO_25_SLEW {fast} CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_26_PULLUP {disabled} CONFIG.PCW_MIO_26_SLEW {fast} CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_27_PULLUP {disabled} CONFIG.PCW_MIO_27_SLEW {fast} CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_28_PULLUP {disabled} CONFIG.PCW_MIO_28_SLEW {fast} CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_29_PULLUP {disabled} CONFIG.PCW_MIO_29_SLEW {fast} CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_2_SLEW {fast} CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_30_PULLUP {disabled} CONFIG.PCW_MIO_30_SLEW {fast} CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_31_PULLUP {disabled} CONFIG.PCW_MIO_31_SLEW {fast} CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_32_PULLUP {disabled} CONFIG.PCW_MIO_32_SLEW {fast} CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_33_PULLUP {disabled} CONFIG.PCW_MIO_33_SLEW {fast} CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_34_PULLUP {disabled} CONFIG.PCW_MIO_34_SLEW {fast} CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_35_PULLUP {disabled} CONFIG.PCW_MIO_35_SLEW {fast} CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_36_PULLUP {disabled} CONFIG.PCW_MIO_36_SLEW {fast} CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_37_PULLUP {disabled} CONFIG.PCW_MIO_37_SLEW {fast} CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_38_PULLUP {disabled} CONFIG.PCW_MIO_38_SLEW {fast} CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_39_PULLUP {disabled} CONFIG.PCW_MIO_39_SLEW {fast} CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_3_SLEW {fast} CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_40_PULLUP {disabled} CONFIG.PCW_MIO_40_SLEW {fast} CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_41_PULLUP {disabled} CONFIG.PCW_MIO_41_SLEW {fast} CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_42_PULLUP {disabled} CONFIG.PCW_MIO_42_SLEW {fast} CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_43_PULLUP {disabled} CONFIG.PCW_MIO_43_SLEW {fast} CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_44_PULLUP {disabled} CONFIG.PCW_MIO_44_SLEW {fast} CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_45_PULLUP {disabled} CONFIG.PCW_MIO_45_SLEW {fast} CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_46_PULLUP {disabled} CONFIG.PCW_MIO_46_SLEW {slow} CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_47_PULLUP {disabled} CONFIG.PCW_MIO_47_SLEW {slow} CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_48_PULLUP {disabled} CONFIG.PCW_MIO_48_SLEW {slow} CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_49_PULLUP {disabled} CONFIG.PCW_MIO_49_SLEW {slow} CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_4_SLEW {fast} CONFIG.PCW_MIO_50_DIRECTION {inout} CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_50_PULLUP {disabled} CONFIG.PCW_MIO_50_SLEW {slow} CONFIG.PCW_MIO_51_DIRECTION {inout} CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_51_PULLUP {disabled} CONFIG.PCW_MIO_51_SLEW {slow} CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_52_PULLUP {disabled} CONFIG.PCW_MIO_52_SLEW {slow} CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} CONFIG.PCW_MIO_53_PULLUP {disabled} CONFIG.PCW_MIO_53_SLEW {slow} CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_5_SLEW {fast} CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_6_SLEW {fast} CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_7_SLEW {slow} CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_8_SLEW {fast} CONFIG.PCW_MIO_9_DIRECTION {inout} CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_9_PULLUP {disabled} CONFIG.PCW_MIO_9_SLEW {slow} CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#Quad SPI Flash#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#UART 1#UART 1#GPIO#GPIO#Enet 0#Enet 0} CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]#qspi0_sclk#gpio[7]#qspi_fbclk#gpio[9]#gpio[10]#gpio[11]#gpio[12]#gpio[13]#gpio[14]#gpio[15]#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#wp#cd#tx#rx#gpio[50]#gpio[51]#mdc#mdio} CONFIG.PCW_M_AXI_GP0_FREQMHZ {100} CONFIG.PCW_NAND_CYCLES_T_AR {0} CONFIG.PCW_NAND_CYCLES_T_CLR {0} CONFIG.PCW_NAND_CYCLES_T_RC {2} CONFIG.PCW_NAND_CYCLES_T_REA {1} CONFIG.PCW_NAND_CYCLES_T_RR {0} CONFIG.PCW_NAND_CYCLES_T_WC {2} CONFIG.PCW_NAND_CYCLES_T_WP {1} CONFIG.PCW_NOR_CS0_T_CEOE {1} CONFIG.PCW_NOR_CS0_T_PC {1} CONFIG.PCW_NOR_CS0_T_RC {2} CONFIG.PCW_NOR_CS0_T_TR {1} CONFIG.PCW_NOR_CS0_T_WC {2} CONFIG.PCW_NOR_CS0_T_WP {1} CONFIG.PCW_NOR_CS0_WE_TIME {2} CONFIG.PCW_NOR_CS1_T_CEOE {1} CONFIG.PCW_NOR_CS1_T_PC {1} CONFIG.PCW_NOR_CS1_T_RC {2} CONFIG.PCW_NOR_CS1_T_TR {1} CONFIG.PCW_NOR_CS1_T_WC {2} CONFIG.PCW_NOR_CS1_T_WP {1} CONFIG.PCW_NOR_CS1_WE_TIME {2} CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} CONFIG.PCW_NOR_SRAM_CS0_T_RC {2} CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} CONFIG.PCW_NOR_SRAM_CS0_T_WC {2} CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {2} CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} CONFIG.PCW_NOR_SRAM_CS1_T_RC {2} CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} CONFIG.PCW_NOR_SRAM_CS1_T_WC {2} CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {2} CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.010} CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.010} CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.010} CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.013} CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.001} CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {-0.002} CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.001} CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.008} CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200.000000} CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} CONFIG.PCW_SD0_GRP_CD_ENABLE {1} CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} CONFIG.PCW_SD0_GRP_POW_ENABLE {0} CONFIG.PCW_SD0_GRP_WP_ENABLE {1} CONFIG.PCW_SD0_GRP_WP_IO {MIO 46} CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {0} CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0} CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} CONFIG.PCW_TTC0_TTC0_IO {EMIO} CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} CONFIG.PCW_UART1_BAUD_RATE {115200} CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} CONFIG.PCW_UIPARAM_DDR_AL {0} CONFIG.PCW_UIPARAM_DDR_BL {8} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.41} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.411} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.341} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.358} CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {61.0905} CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {61.0905} CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {61.0905} CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {61.0905} CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {68.4725} CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {71.086} CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {66.794} CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {108.7385} CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.025} CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.028} CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {-0.009} CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {-0.061} CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {64.1705} CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {63.686} CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {68.46} CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {105.4895} CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_ENABLE {1} CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333313} CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J128M16 HA-15E} CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} CONFIG.PCW_USB0_RESET_ENABLE {0} CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} CONFIG.PCW_USB1_RESET_ENABLE {0} CONFIG.PCW_USB1_RESET_IO {<Select>} CONFIG.PCW_USB_RESET_POLARITY {Active Low} CONFIG.PCW_USE_CROSS_TRIGGER {0} CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} CONFIG.preset {ZedBoard*}  ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list CONFIG.NUM_MI {1}  ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]
  set_property -dict [ list CONFIG.C_AUX_RESET_HIGH {0}  ] $rst_processing_system7_0_100M

  # Create instance: vio_0, and set properties
  set vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0 ]
  set_property -dict [ list CONFIG.C_NUM_PROBE_IN {0}  ] $vio_0

  # Create interface connections
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins irq_gen_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]

  # Create port connections
  connect_bd_net -net irq_gen_0_IRQ [get_bd_pins ila_0/probe2] [get_bd_pins irq_gen_0/IRQ] [get_bd_pins processing_system7_0/Core1_nIRQ]
  connect_bd_net -net irq_gen_0_slv_reg [get_bd_pins ila_0/probe1] [get_bd_pins irq_gen_0/slv_reg]
  connect_bd_net -net irq_gen_0_vio_rise_edge [get_bd_pins ila_0/probe0] [get_bd_pins irq_gen_0/vio_rise_edge]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins ila_0/clk] [get_bd_pins irq_gen_0/S_AXI_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk] [get_bd_pins vio_0/clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins irq_gen_0/S_AXI_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
  connect_bd_net -net vio_0_probe_out0 [get_bd_pins ila_0/probe3] [get_bd_pins irq_gen_0/VIO_IRQ_TICK] [get_bd_pins vio_0/probe_out0]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x78600000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs irq_gen_0/S_AXI/reg0] SEG_irq_gen_0_reg0
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


