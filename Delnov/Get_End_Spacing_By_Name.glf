#===============================================================================
proc Delnov_Get_End_Spacing_By_Name { con_name } {
#-------------------------------------------------------------------------------
# Calls sister function: Delnov_Get_Actual_Spacing
#-------------------------------------------------------------------------------

  # Fetch the entity from its name ...
  set con [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] $con_name]

  # ... and call sister function to get spacing
  set dim [$con getDimension]
  set spc [Delnov_Get_Actual_Spacing $con $dim]

  unset dim
  unset con

  return $spc
}

