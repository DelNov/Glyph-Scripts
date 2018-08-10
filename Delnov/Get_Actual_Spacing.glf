#===============================================================================
proc Delnov_Get_Actual_Spacing { con loc } {
#-------------------------------------------------------------------------------
# Get actual spacing of a connection
#-------------------------------------------------------------------------------

  if { $loc == 1 } {
    set node [$con getNode $loc]
  } else {   ; # $loc >1
    set node [$con getNode 2]
  }

  set xyz2 [$node getXYZ]

  # Set it to the second point on the con if we are interested in the beg.
  if { $loc==1 } {
    set xyz [$con getXYZ 2]

  # Set it to 2nd to last point on the con if we are interested in the end
  } else {   ; # $loc > 1
    set xyz [$con getXYZ [expr $loc -1]]

  }

  set spc [pwu::Vector3 length [pwu::Vector3 subtract $xyz $xyz2]]
  return $spc
}

