transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Quartus/Max10/demo_mips/src/designs {D:/Quartus/Max10/demo_mips/src/designs/clk_div.v}
vcom -2008 -work work {D:/Quartus/Max10/demo_mips/src/ip/data_mem.vhd}
vcom -2008 -work work {D:/Quartus/Max10/demo_mips/src/designs/imem.vhd}
vcom -2008 -work work {D:/Quartus/Max10/demo_mips/src/designs/regfile.vhd}
vcom -2008 -work work {D:/Quartus/Max10/demo_mips/src/designs/mips.vhd}
vcom -2008 -work work {D:/Quartus/Max10/demo_mips/src/designs/mips_core.vhd}
vcom -2008 -work work {D:/Quartus/Max10/demo_mips/src/designs/control_path_components.vhd}
vcom -2008 -work work {D:/Quartus/Max10/demo_mips/src/designs/data_path_components.vhd}
vcom -2008 -work work {D:/Quartus/Max10/demo_mips/src/designs/board.vhd}

vcom -2008 -work work {D:/Quartus/Max10/demo_mips/src/tb/board_tb.vhd}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  board_tb

add wave *
view structure
view signals
run -all
