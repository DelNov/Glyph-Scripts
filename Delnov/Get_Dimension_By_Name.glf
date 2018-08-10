#===============================================================================
proc Delnov_Get_Dimension_By_Name { con_name } {
#-------------------------------------------------------------------------------
# Get physical length of a connection specified by its name.
#-------------------------------------------------------------------------------

  # Fetch the connection from its name ...
  set con [pw::GridEntity getByName $con_name]

  # ... and retreive its length from database
  set dim [$con getDimension]

  unset con

  return $dim
}
