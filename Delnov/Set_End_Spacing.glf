#===============================================================================
proc Delnov_Set_End_Spacing { con_list delta } {
#-------------------------------------------------------------------------------
# Sets end spacing for connectors specified by a list
#-------------------------------------------------------------------------------

  foreach con $con_list {
    set mod [pw::Application begin Modify [list $con]]
      [[$con getDistribution 1] getEndSpacing] setValue $delta
    $mod end
  }

}

