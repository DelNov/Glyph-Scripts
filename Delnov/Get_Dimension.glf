#===============================================================================
proc Delnov_Get_Dimension { con } {
#-------------------------------------------------------------------------------

  set dim [$con getDimension]

  return $dim
}
