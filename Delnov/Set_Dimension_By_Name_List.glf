#===============================================================================
proc Delnov_Set_Dimension_By_Name_List { con_name_list n } {
#-------------------------------------------------------------------------------
# Sets dimension for connectors specified by a list of names
#
# Calls sister function: Delnov_Set_Dimension
#-------------------------------------------------------------------------------

  # Create a list of segments by provided name list ...
  set seg_list [list]
  foreach name $con_name_list {
    lappend seg_list [pw::GridEntity getByName $name]
  }

  # ... and call the sister function
  Delnov_Set_Dimension $seg_list $n

  unset seg_list
}

