#===============================================================================
proc Delnov_Get_Begin_Spacing_By_Name { con_name } {
#-------------------------------------------------------------------------------

  # Fetch the entity from its name ...
  set con [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] $con_name]

  # ... and call sister function to get spacing
  set spc [Delnov_Get_Actual_Spacing $con 1]

  unset con

  return $spc
}

