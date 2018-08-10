#===============================================================================
proc Delnov_Set_Begin_Spacing { con_list delta } {
#-------------------------------------------------------------------------------
# Sets begin spacing for connectors specified by a list
#-------------------------------------------------------------------------------

  foreach con $con_list {
    set mod [pw::Application begin Modify [list $con]]
      [[$con getDistribution 1] getBeginSpacing] setValue $delta
    $mod end
  }

}

