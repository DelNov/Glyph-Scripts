#===============================================================================
proc Delnov_Avg_Points { list_1 list_2 {list_3 ""} } {
#-------------------------------------------------------------------------------
# Computes the average of two or three points.
#-------------------------------------------------------------------------------

  # Define the result list
  set t [list]

  # Browse through elements of the list 
  for {set i 0} {$i < [llength $list_1]} {incr i} {

    # Take values of individual members
    set m_1 [lindex $list_1 $i]
    set m_2 [lindex $list_2 $i]
    set m_3 0.0

    # Assume there are two points ...
    set divisor 2.0

    # ... but if there are three, change divisor and member 3
    if {$list_3 ne ""} {
      set divisor 3.0
      set m_3 [lindex $list_3 $i]
    }

    # Compute the average and add it to resulting list
    set t [linsert $t $i [expr ($m_1 + $m_2 + $m_3)/$divisor]]
  }

  return $t
}

