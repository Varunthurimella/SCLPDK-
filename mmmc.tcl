############################################################
# Library Sets
############################################################

create_library_set -name wc_slow -timing {
    ../scl180/stdcell/fs120/6M1L/liberty/lib_flow_ss/tsl18fs120_scl_ss.lib}

create_library_set -name wc_fast -timing {
    ../scl180/stdcell/fs120/6M1L/liberty/lib_flow_ff/tsl18fs120_scl_ff.lib}


############################################################
# Operating Conditions
############################################################

create_opcond -name op_cond_wc_slow \
    -process 1.2 \
    -voltage 1.62 \
    -temperature 125

create_opcond -name op_cond_wc_fast \
    -process 0.8 \
    -voltage 1.98 \
    -temperature -40

############################################################
# Timing Conditions
############################################################

create_timing_condition -name timing_cond_wc_slow \
    -opcond op_cond_wc_slow \
    -library_sets {wc_slow}

create_timing_condition -name timing_cond_wc_fast \
    -opcond op_cond_wc_fast \
    -library_sets {wc_fast}

############################################################
# RC Corner
############################################################

create_rc_corner -name rc_corner_slow -temperature 125
create_rc_corner -name rc_corner_fast -temperature -40



############################################################
# Delay Corners
############################################################

create_delay_corner -name delay_corner_wc_slow \
    -timing_condition timing_cond_wc_slow \
    -rc_corner rc_corner_slow

create_delay_corner -name delay_corner_wc_fast \
    -timing_condition timing_cond_wc_fast \
    -rc_corner rc_corner_fast

############################################################
# Constraint Modes
############################################################

create_constraint_mode -name functional \
    -sdc_files { ../constraints/constraints.sdc }

############################################################
# Analysis Views
############################################################

create_analysis_view -name setup_view \
    -constraint_mode functional \
    -delay_corner delay_corner_wc_slow

create_analysis_view -name hold_view \
    -constraint_mode functional \
    -delay_corner delay_corner_wc_fast

############################################################
# Set Analysis Views
############################################################

set_analysis_view \
    -setup {setup_view} \
    -hold {hold_view}
