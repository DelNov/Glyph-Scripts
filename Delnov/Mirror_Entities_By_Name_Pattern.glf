#===============================================================================
proc Delnov_Mirror_Entities_By_Name_Pattern { pattern dir } {
#-------------------------------------------------------------------------------
# Mirros entities given by name pattern in "x", "y" or "z" direction           !
#
# Calls sister function: Delnov_Mirror_Entities
#-------------------------------------------------------------------------------

  # Extract grid entites by the name pattern ...
  set all_ent [Delnov_Get_Entities_By_Name_Pattern $pattern]

  # ... and call the sister function
  Delnov_Mirror_Entities $all_ent $dir

  unset all_ent
}

