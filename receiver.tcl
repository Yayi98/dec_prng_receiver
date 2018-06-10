# transmitter.tcl
#	MicroZed simple build script
#	Version 1.0
#
# Copyright (C) 2018 Mahesh Chandra Yayi

set ODIR .
set_param messaging.defaultLimit 10000

# STEP#1: setup design sources and constraints

read_vhdl ../dec_8b10.vhd
read_vhdl ../prng32.vhd
read_vhdl ../deserializer.vhd
read_vhdl ../top_receiver.vhd
read_vhdl ../count_ones.vhd

# STEP#2: run synthesis, write checkpoint design

synth_design -top top -flatten rebuilt
write_checkpoint -force $ODIR/post_synth

# STEP#3: run placement and logic optimzation, write checkpoint design

opt_design -propconst -sweep -retarget -remap

place_design -directive Quick
phys_opt_design -critical_cell_opt -critical_pin_opt -placement_opt -hold_fix -rewire -retime
power_opt_design
write_checkpoint -force $ODIR/post_place

# STEP#4: run router, write checkpoint design

route_design -directive Quick
write_checkpoint -force $ODIR/post_route


report_timing -no_header -path_type summary -max_paths 1000 -slack_lesser_than 0 -setup
report_timing -no_header -path_type summary -max_paths 1000 -slack_lesser_than 0 -hold

# STEP#5: generate a bitstream

set_property BITSTREAM.GENERAL.COMPRESS True [current_design]
set_property BITSTREAM.CONFIG.USERID "DEADC0DE" [current_design]
set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]
set_property BITSTREAM.READBACK.ACTIVERECONFIG Yes [current_design]

write_bitstream -bin_file -force $ODIR/blink.bit

# STEP#6: generate reports

report_clocks

report_utilization -hierarchical -file utilization.rpt
report_clock_utilization -file utilization.rpt -append
report_datasheet -file datasheet.rpt
report_timing_summary -file timing.rpt
