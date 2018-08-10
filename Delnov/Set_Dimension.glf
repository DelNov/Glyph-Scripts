#===============================================================================
proc Delnov_Set_Dimension { con_list n } {
#-------------------------------------------------------------------------------
# Sets dimension for connectors specified by a list
#-------------------------------------------------------------------------------

  set con_coll [pw::Collection create]
  $con_coll set $con_list
  $con_coll do resetGeneralDistributions
  $con_coll do setDimension $n
}

