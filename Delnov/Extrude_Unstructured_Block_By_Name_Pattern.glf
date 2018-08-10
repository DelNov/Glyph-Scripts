#===============================================================================
proc Delnov_Extrude_Unstructured_Block_By_Name_Pattern { name_pat dir dist n } {
#-------------------------------------------------------------------------------
# Extrudes unstructured block from domains given by name pattern
#
# Calls sister function: Delnov_Extrude_Unstructured_Block
#-------------------------------------------------------------------------------

  # Extract grid entites by the name pattern ...
  set all_dom [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] $name_pat]

  # ... and call the sister function
  Delnov_Extrude_Unstructured_Block $all_dom $dir $dist $n

  unset all_dom
}

