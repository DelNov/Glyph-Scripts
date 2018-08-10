#===============================================================================
proc Delnov_Get_End_Spacing { con } {
#-------------------------------------------------------------------------------
# Calls sister function: Delnov_Get_Actual_Spacing
#-------------------------------------------------------------------------------

  # Fetch the dimension (resolution) of the domain ..
  set dim [$con getDimension]

  # ... to be able to fetch last actual spacing
  set spc [Delnov_Get_Actual_Spacing $con $dim]

  unset dim

  return $spc
}

