transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {mips.vo}

vcom -93 -work work {D:/Quartus/Max10/demo_mips/src/tb/board_tb.vhd}

vsim -t 1ps -L altera_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L gate_work -L work -voptargs="+acc"  board_tb

add wave *
view structure
view signals
run -all
