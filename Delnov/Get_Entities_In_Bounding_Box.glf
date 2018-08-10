#===============================================================================
proc Delnov_Get_Entities_In_Bounding_Box { pool box } {
#-------------------------------------------------------------------------------
# Returns entities from inital "pool" in the bounding "box"
#-------------------------------------------------------------------------------

  # Initialize list which will hold selected entities
  set sel_ent [list]

  # Browse through all grid entities
  foreach ge $pool {

    # Fetch coordinates of the entity
    set xb [lindex [lindex [$ge getExtents] 0] 0]
    set yb [lindex [lindex [$ge getExtents] 0] 1]
    set zb [lindex [lindex [$ge getExtents] 0] 2]
    set xe [lindex [lindex [$ge getExtents] 1] 0]
    set ye [lindex [lindex [$ge getExtents] 1] 1]
    set ze [lindex [lindex [$ge getExtents] 1] 2]

    # puts "Entity coordinates:"
    # puts [format "%5.2f %5.2f %5.2f" $xb $yb $zb]
    # puts [format "%5.2f %5.2f %5.2f" $xe $ye $ze]

    # Fetch box' cooridnates
    set x_min [lindex [lindex $box 0] 0]
    set y_min [lindex [lindex $box 0] 1]
    set z_min [lindex [lindex $box 0] 2]
    set x_max [lindex [lindex $box 1] 0]
    set y_max [lindex [lindex $box 1] 1]
    set z_max [lindex [lindex $box 1] 2]

    # puts "Bounding box cooridnates"
    # puts [format "%5.2f %5.2f %5.2f" $x_min $y_min $z_min]
    # puts [format "%5.2f %5.2f %5.2f" $x_max $y_max $z_max]

    if {$xb > $x_min} {if {$xe > $x_min} {
    if {$yb > $y_min} {if {$ye > $y_min} {
    if {$zb > $z_min} {if {$ze > $z_min} {
    if {$xb < $x_max} {if {$xe < $x_max} {
    if {$yb < $y_max} {if {$ye < $y_max} {
    if {$zb < $z_max} {if {$ze < $z_max} {
      lappend sel_ent $ge
    } } } } } } } } } } } }
  }

  # return selected entities
  return $sel_ent
}

