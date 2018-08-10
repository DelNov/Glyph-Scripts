#===============================================================================
proc Delnov_Introduce_Bnd_Conds { bnd_cond_name_list } {
#-------------------------------------------------------------------------------
# Creates a list of boundary conditions.
#-------------------------------------------------------------------------------

  set bc_list [list]
  set cnt 2
  foreach bc $bnd_cond_name_list {
    set bc_name [format bc-%d $cnt]

    set create_bnd_cond [pw::BoundaryCondition create]
      set bnd_cond_name [pw::BoundaryCondition getByName $bc_name]
      $bnd_cond_name setName $bc
      lappend $bc_list [pw::BoundaryCondition getByName $bc]
    unset create_bnd_cond

    # Increase counter by one
    set cnt [expr $cnt + 1]
  }

  return $bc_list
}

