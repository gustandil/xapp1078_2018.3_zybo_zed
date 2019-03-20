# Instructions for Vivado/Petalinux 2018.3 #

This information is based on 'Xapp1078 Instructions for Vivado 2014.4'[complete ref here].
Original explanation and material comes from Xilinx Xapp1078 
"Simple AMP Running Linux and Bare-Metal System on Both Zynq SoC Processors (feb2013)"

NOTE: These flow was verfied in ZedBoard and Zybo Z-20. Porting to Zybo and Zybo Z-10 is trivial

NOTE: This project requires using a Linux host to compile the embedded Linux kernel. 
The instructions have been setup such that all implementation work will be done in a directory 
called "xapp1078_2018.3/" and all linux work will be done in a directory called xapp1078_2018.3/plnx-project. 
The instructions will require files to be copied between xapp1078_2018.3 and xapp1078_2018.3/plnx-project 
so if the Vivado and SDK tools are ran on a Windows machine, the files will need to be copied from the Windows 
xapp1078_2018.3/design to the Linux machine's xapp1078_2018.3/plnx-project.
This project was tested using Vivado 2018.3/ Petalinx 2018.3 and Vivado 2018.3/ Petalinux 2017.3
 
Extract xapp1078_2018.3.zip into <xapp1078_2018.3> (or clone Git repository and chage the name to <xapp1078_2018.3>
Create a new work directory, <xapp1078_2018.3>/work
Copy the directory <xapp1078_2018.3>/design/src/bootgen to <xapp1078_2018.3>/design/work/bootgen
Open Vivado 2018.3
In the Tcl command window, 'cd <xapp1078_2018.3>/work'
Create, build, and export the hdwr design to SDK by running the included script using tcl:
  For the ZedBoard design, run the tcl command 'source ../src/scripts/create_proj_zedBoard.tcl'
  For the Zybo Z20 design, run the tcl command 'source ../src/scripts/create_proj_zyboZ20.tcl'

NOTE: You will need the board files from Digilent (Zybo Z-20) or Avnet (MicroZed). This file are NOT included in this project
    
## Review the create_proj_zyboZ20.tcl file. ## 
This script does the following:
  - Create a new project
  - Set the properties of the project such as part used and board used
  - Set Vivado to use the included I.P. repository in <xapp1078_2018.3>/src/pcores. This repository includes
    the custom IP that can create interrupts towards the PS using either a register or chipscope VIO
  - Create the IPI design using the tcl script <xapp1078_2018.3>/src/scripts/create_bd_zyboZ20.tcl. This script
    was originally created after creating the IPI design manually, and then issuing the command
    'write_bd_tcl ../src/scripts/create_bd_zyboZ20.tcl'.
  - validate and save the IPI design
  - Create the top level HDL wrapper and add it to the project. (Same as navigating to 'Project Manager',
    right clicking on design_1.bd, and selecting 'Create HDL Wrapper')
  - Create bitstream. This command will recognize that the design hasn't been implemented yet and will
    run 'generate files' on design_1.bd, synthesis, implementation, and bitstream generation.
  - Exports the hdf file to SDK and launch SDK. The hdf file contains system information, PS startup
    information, and bitfile information

When the script finishes running it will open SDK. In the SDK workspace a hardware platform project is
created automatically.

## Create the BSP for CPU1 (Bare Metal) ##

  Note: In the Vivado 2014.4 instructions, authors modifies the "standalone v4.2 BSP".
        The modifications affect functions that uses stdout and the boot.S. We do not use this features

  Select File->New->Board_Support_Package
  Enter the project name 'app_cpu1_bsp'
  Change CPU to ps7_cortexa9_1.
  Select Finish
  In the 'Board Support Package Settings' Select Overview->standalone and change stdin and stdout to None
  Select Overview->drivers->ps7_cortexa9_1 and change the extra_compiler_flags value to contain '-DUSE_AMP=1 -DSTDOUT_BASEADDRESS=1'
  Select OK
  
## Create the Application that will run on CPU1 ##
  Select File->New->Application_Project
  Enter the project name 'app_cpu1'
  Change Processor to ps7_cortexa9_1
  Change 'Board Support Package' to 'Use existing' 'app_cpu1_bsp' and select Next
  Select the template 'Empty Application' then select Finish.
  Import the C and linkerscript file for app_cpu1 by navigating to SDK Project Explorer and right clicking on app_cpu1/src and select 'Import'
  Select General->File_System then select Next
  In the 'From directory', browse to and select <xapp1078_2014.4>/design/src/apps/app_cpu1
  In the right window, select all .c, .h and lscript.ld then select Finish. Answer Yes to overwrite lscript.ld
  Note: instead of using Import, the files could be dragged from MS Windows File Explorer to the SDK Project Explorer app_cpu1/src
    directory. Select 'Copy files' when prompted and 'Yes' to overwrite lscript.ld
	
  For Zedboard. Since we have only 512 MB, change CPU1 address init from 0x30000000 to 0x18000000 !!!
  768 MB to 384 MB. We need also to change the size from 256MB to 128MB (0x10000000 to 0x08000000)

## Create, configure & build Petalinux Project ## 
  On a linux host machine that includes the Petalinux 2018.3 build environment, 
  create and move to the directory where you want to create the petalinux project
  mkdir <xapp1078_2018.3>
  cd <xapp1078_2018.3>
  source </opt/petalinux-install-dir>/settings64.sh
    This command will setup the Petalinux environment. 

  petalinux-create -t project -n plnx-project --template zynq
    This command creates a new petalinux project named plnx-project in the current directory
  cd plnx-project
  mkdir ../hwdef
    Create a directory that will contain the Vivado exported hdf file
  cp <xapp1078_2018.3>/work/project_1/project_1.sdk/design_1_wrapper.hdf ../hwdef
    This command copies the Vivado exported hdf file
  petalinux-config --get-hw-description=../hwdef
    This command configures petalinux to point to the directory that contains the hdf file
    A dts file is created in subsystems/linux/configs/device-tree. This dts file can be modified
  
  When the Linux System Configuration window appears:
    select Kernel Bootargs (in DTG settings --->)
    Deselect 'generate boot args automatically' by pressing 'n' 
    Select 'user set kernel bootargs' and press enter
    Enter the following: 
      console=ttyPS0,115200 earlyprintk maxcpus=1 mem=768M
	For ZedBoard (we only have 512 MB). Leave 128 MB for ARM1. This setup is also valid for old Zybo
      console=ttyPS0,115200 earlyprintk maxcpus=1 mem=384M
    Select Ok
		
	(optional) Assign fixed IP address 
	
    Saves the new configuration


  petalinux-create -t apps --template c --name softuart
    Create a new application template for the linux softuart function
  cp <xapp1078_2018.3>/src/apps/softUart/softuart.c   \
				[dir]/plnx-project/project-spec/meta-user/recipes-apps/softuart/files/softuart.c
    Replace the petalinux project's templated softuart.c with the src that was included in the xapp
  petalinux-config -c rootfs
    Configure the petalinux project to include softuart on the rootfs and optionally enable Dropbear
    for ssh access to the board. Once the Linux/rootfs configuration window appears:
      //Add softuart app to filesystem
        Select apps
        Select softuart and press 'y'
		Select peekpoke and press 'y'
        Select Exit
      //*OPTIONAL* Enable Dropbear for ssh
        Select Filesystem Packages
        Select console/network
        Select dropbear
        Select dropbear and press 'y'
        Select Exit
        Select Exit
        Select Exit
    Select Exit
    Select Yes
      Saves the new configuration
      
    Add one of the following sections to the end of 
	[plnx-project]/project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi
	
    This action will add peripherals that are external to the FPGA and it will disable the driver for the PL330 dma
    controller. Currently, there is a problem in the PL330 driver that causes cpu1 to randomly run code
    when maxcpu=1.

/* *********************************
 * microZed Board peripherals
 * *********************************
 */
&dmac_s {
			status = "disabled";
};

&gem0 {
	phy-handle = <&phy0>;
  phy-mode = "rgmii-id";
	ps7_ethernet_0_mdio: mdio {
		#address-cells = <1>;
		#size-cells = <0>;
		phy0: phy@0 {
			compatible = "marvell,88e1510";
			device_type = "ethernet-phy";
			reg = <0>;
      marvell,reg-init = <3 16 0xff00 0x1e 3 17 0xfff0 0x00>;
		} ;
	} ;
};

&flash0 {
	compatible = "spansion,s25fl128s1";
};


/* *********************************
 * zedBoard Board peripherals
 * *********************************
 */
&dmac_s {
			status = "disabled";
};

&gem0 {
	phy-handle = <&phy0>;
	ps7_ethernet_0_mdio: mdio {
		#address-cells = <1>;
		#size-cells = <0>;
		phy0: phy@0 {
			compatible = "marvell,88e1510";
			device_type = "ethernet-phy";
			reg = <0>;
		} ;
	} ;
};

&flash0 {
	compatible = "spansion,s25fl256s1";
};

&usb0 {
	dr_mode = "otg";
} ;

/* *********************************
 * zybo Z-20 Board peripherals
 * *********************************
 */ 
 works with no modification
 
 
  petalinux-build
    Builds the petalinux project.
    Log is at build/build.log
    Generated output files are in images/linux
    Compiled softuart app is found in build/linux/rootfs/apps/softuart
    The built image.ub is a FIT format and contains: linux kernel, ramdisk, and device tree 

Create the bootable file for the SD card.
  cp images/linux/zynq_fsbl.elf <xapp1078_2018.3>/work/bootgen
  cp images/linux/u-boot.elf <xapp1078_2018.3>/work/bootgen
  In Windows:
  Within SDK, select Xilinx_tools->launch_shell
    A new command shell is started with an environment pointing to the SDK and Vivado tools
  cd ..\..\bootgen
  createBoot.bat
    This batch file runs bootgen and uses bootimage.bif for input. The bif is used to package
    the fsbl, u-boot, cpu1 app, and fpga bit file into boot.bin
	
  In Linux	
  cd <xapp1078_2018.3>/work/bootgen
  bootgen -image bootimage.bif -o i BOOT.BIN -w on 
    This command (bootgen) and uses bootimage.bif for input.The bif is used to package
    the fsbl, u-boot, cpu1 app, and fpga bit file into boot.bin 

Copy the boot and embedded Linux files to the SD card
  cp <xapp1078_2014.4>/work/bootgen/BOOT.BIN <SD card>
  cp <xapp1078_2014.4>/plnx-project/images/linux/image.ub <SD card>

///////////////////////////////////////////////////////////////////
// Optional
///////////////////////////////////////////////////////////////////
The petalinux build creates a FIT formated file image.ub. This file contains the kernel, root filesystem, and
the devicetree. The following optional commands seperates the devicetree and creates a uImage file that contains the
kernel and root filesystem. This flow can be handy when working with multiple devicetrees.

The following command will remove the devicetree and create uImage

./build/linux/u-boot/u-boot-plnx/tools/mkimage \
  -A arm -O linux -T kernel -C none \
  -a 0x8000 -e 0x8000 \
  -n 'PetaLinux' \
  -d images/linux/zImage \
  images/linux/uImage

Convert the binary devicetree.dtb that was created by petalinux-build to a human readable dts file:

dtc -I dtb -O dts -o images/linux/system.dts images/linux/system.dtb

cp images/linux/system.dts images/linux/system1.dts

Edit images/linux/system1.dts and make customizations, then save:

Recompile the new system1.dts to system1.dtb
dtc -I dts -O dtb -o images/linux/system1.dtb images/linux/system1.dts

Copy uImage and the devicetree to the SD card. (image.ub could be removed from the SD)
  cp <xapp1078_2014.4>/plnx-project/images/linux/system1.dtb <SD card>
  cp <xapp1078_2014.4>/plnx-project/images/linux/uImage <SD card>

In order to boot using the uImage and system1.dtb files, the uboot environment needs to be changed 
to use uImage and system1.dtb instead of the original FIT image.ub file. This change only needs to be done
once since the uboot environment is saved in QSPI flash.

Configure the board to boot from SD, apply power, and start a terminal emulator (115200 baud).
Hit any key to stop autoboot.

Issue the following uboot commands to configure the uboot environment:
U-Boot-PetaLinux> env default -a	  # resets environment
U-Boot-PetaLinux> setenv sdboot_devtree "echo boot Petalinux; mmcinfo && fatload mmc 0 0x01000000 uImage && fatload mmc 0 0x03800000 system1.dtb && bootm 0x01000000 - 0x03800000"
U-Boot-PetaLinux> setenv default_bootcmd run sdboot_devtree
U-Boot-PetaLinux> saveenv    #save env to qspi
U-Boot-PetaLinux> run sdboot_devtree   #boot from sd card

The next time u-boot runs, it will automatically boot using the devicetree on the SD card.

///////////////////////////////////////////////////////////////////
// End Optional
///////////////////////////////////////////////////////////////////

***************************************
*OPTIONAL*
***************************************
If already booted in linux, new boot files can be copied to the SD card using tftp if a tftp daemon on a host machine
is available.

#on the running embedded system, mount sd card
mount /dev/mmcblk0p1 /media
cd /media
tftp <hostIP> -g -r uImage

***************************************
*END OPTIONAL*
***************************************


Working with the design
  Boot the board from the SD card and open a terminal emulator configured for 115200 baud.
    U-boot will automatically run sdboot and start the kernel. 
    If old uboot environment settings have been stored, it may be necessary to enter uboot and run the
    following command which will set the environment to the defaults that were defined during the petalinux
    build:
      env default -a
      saveenv
 
  The kernel will boot. Login as user 'root' and passwd 'root'

  Enter the linux commands:
  'peek 0xffff8000'             Checks the heartbeat. It should be 0 because cpu1 hasn't started
  'poke 0xfffffff0 0x30000000'  Start cpu1 by writing a start address to the wfe loop
  'poke 0xfffffff0 0x18000000'  In zedboard use this address (512MB-128MB)
  'peek 0xffff8000'             Checks the heartbeat. cpu1 is now started so the read value should increment every second
  'softuart&'                   Start the softuart application and run it in the background
  'poke 0x78600000 0x00000001'  Using Linux on cpu0, create an interrupt towards cpu1 by writing to
                                the control register within the irq_gen_0 core.
                                Cpu1 will received an interrupt then service it. Upon servicing the irq,
                                cpu1 uses OCM to communicate to the Linux softuart app. Cpu1 will cause the app to display:
                                'CPU1: IRQ clr <incrementing value>'

  Another way to generate an interrupt towards cpu1 is by using the chipscope VIO:
    In vivado's flow navigator, select select program_and_debug->open_hardware_manager
      Select 'Open target' -> 'auto connect'
      In the hardware manager, debug probes window, select all probes under 'hw_ila_1', then right-click, Add probes to basic trigger setup
      Focus will change to the ILA-hw_ila_1 tab. Change the compare value of design_1_i/vio_o_probe_out_1 to 'R'. Ok
      Change the 'ILA properties', 'trigger position in window' to 100
      Select Run trigger. The is now waiting for a trigger
      In the hardware manager, debug probes window, right click on the only hw_vio_1 signal and select 'add probes to VIO window'
      Focus will change to the VIO-hw_vio_1 tab. Right click on the signal and select 'Active-high button'
      When you press the VIO button, an interrupt is generated and cpu1 will acknowledge it by printing to the linux softuart:
        'CPU1: IRQ clr <incrementing value>'
        The ILA will also trigger capturing the assertion and deassertion of the IRQ
