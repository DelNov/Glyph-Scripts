#===============================================================================
proc Delnov_Get_Length_By_Name { con_name } {
#-------------------------------------------------------------------------------
# Get physical length of a connection specified by its name.
#-------------------------------------------------------------------------------

  # Fetch the connection from its name ...
  set con [pw::GridEntity getByName $con_name]

  # ... and retreive its length from database
  set len [$con getTotalLength -constrained onDB]

  unset con

  return $len
}

