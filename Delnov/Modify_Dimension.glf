#===============================================================================
proc Delnov_Modify_Dimension { con_list n } {
#-------------------------------------------------------------------------------
# Modifies dimension of connections specified by a list
#-------------------------------------------------------------------------------

  set modify [pw::Application begin Dimension]
    set con_coll [pw::Collection create]
    $con_coll set $con_list
    $con_coll do resetGeneralDistributions
    $con_coll do setDimension $n
    $con_coll delete
    unset con_coll
    $modify balance -resetGeneralDistributions
  $modify end
  unset modify
}

