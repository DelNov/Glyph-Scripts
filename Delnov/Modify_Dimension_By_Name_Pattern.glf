#===============================================================================
proc Delnov_Modify_Dimension_By_Name_Pattern { pattern n } {
#-------------------------------------------------------------------------------
# Modifies dimension of connections specified by a name pattern
#
# Calls sister function: Delnov_Modify_Dimension
#-------------------------------------------------------------------------------

  # Extract grid entites by the name pattern ...
  set all_con [Delnov_Get_Entities_By_Name_Pattern $pattern]

  # ... and call the sister function
  Delnov_Modify_Dimension $all_con $n

  unset all_con
}
