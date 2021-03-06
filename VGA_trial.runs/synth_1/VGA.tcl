# 
# Synthesis run script generated by Vivado
# 

create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/canbe/Desktop/trial2/VGA_trial/VGA_trial.cache/wt [current_project]
set_property parent.project_path C:/Users/canbe/Desktop/trial2/VGA_trial/VGA_trial.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo c:/Users/canbe/Desktop/trial2/VGA_trial/VGA_trial.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  C:/Users/canbe/Desktop/trial2/VGA_trial/VGA_trial.srcs/sources_1/new/BALL.vhd
  C:/Users/canbe/Desktop/trial2/VGA_trial/VGA_trial.srcs/sources_1/new/MY.vhd
  C:/Users/canbe/Desktop/trial2/VGA_trial/VGA_trial.srcs/sources_1/new/SYNC.vhd
  C:/Users/canbe/Desktop/trial2/VGA_trial/VGA_trial.srcs/sources_1/new/VGA.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/canbe/Desktop/trial2/VGA_trial/VGA_trial.srcs/constrs_1/new/constraints.xdc
set_property used_in_implementation false [get_files C:/Users/canbe/Desktop/trial2/VGA_trial/VGA_trial.srcs/constrs_1/new/constraints.xdc]


synth_design -top VGA -part xc7a35tcpg236-1


write_checkpoint -force -noxdef VGA.dcp

catch { report_utilization -file VGA_utilization_synth.rpt -pb VGA_utilization_synth.pb }
