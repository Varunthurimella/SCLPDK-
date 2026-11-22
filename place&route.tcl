set_db init_power_nets VDD
set_db init_ground_nets VSS
read_mmmc ../mmmc/mmmc.tcl
read_physical -lef {/home/IITBBS0125_10416/Downloads/SCLPDK_V3.0_KIT/scl180/stdcell/fs120/6M1L/lef/scl18fs120_tech.lef   /home/IITBBS0125_10416/Downloads/SCLPDK_V3.0_KIT/scl180/stdcell/fs120/6M1L/lef/scl18fs120_std.lef }

read_netlist SynthesisOutput/counter_netlist.v 
init_design

create_floorplan -site CoreSite -core_density_size 1 0.7 100 100 100 100

read_def /home/IITBBS0125_10416/Downloads/SCLPDK_V3.0_KIT/work/floorplan.def


add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top M6 bottom M6 left M5 right M5} -width {top 0.44 bottom 0.44 left 0.44 right 0.44} -spacing {top 0.46 bottom 0.46 left 0.46 right 0.46} -offset {top 0 bottom 0 left 0 right 0} -center 1 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width 0.44 -spacing 0.46 -number_of_sets 10 -start_from left -start_offset 1 -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit M6 -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit M6 -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none


add_stripes -nets {VDD VSS} -layer M5 -direction horizontal -width 0.44 -spacing 0.46 -number_of_sets 10 -start_from left -start_offset 1 -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit M6 -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit M6 -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none


connect_global_net VDD -type pg_pin -pin_base_name VDD -inst_base_name *

connect_global_net VSS -type pg_pin -pin_base_name VSS -inst_base_name *

route_special -connect {core_pin} -layer_change_range { M1(1) M6(6) } -block_pin_target {nearest_target} -core_pin_target {first_after_row_end} -allow_jogging 1 -crossover_via_layer_range { M1(1) M6(6) } -nets { VDD VSS } -allow_layer_change 1 -target_via_layer_range { M1(1) M6(6) }

set_db route_special_via_connect_to_shape { stripe }

place_opt_design 

write_db placeOpt    place_opt_design > rpts/placement.rpt

create_clock_tree_spec 

clock_opt_design 

opt_design -post_cts -hold

write_db postCTSopt    clock_opt_design > rpts/cts.rpt

route_design

check_drc

check_connectivity

 
