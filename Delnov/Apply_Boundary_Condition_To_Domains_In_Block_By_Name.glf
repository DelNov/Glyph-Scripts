#===============================================================================
proc Delnov_Apply_Boundary_Condition_To_Domains_In_Block_By_Name \
  { bc blk domains_in_block_list } {
#-------------------------------------------------------------------------------
# bc_name" "blk_name" [list "dom_name_1" "dom_name_2" .. "dom_name_last"]
#-------------------------------------------------------------------------------

  set local_bc_list [list]

  # Get b.c. pw object by name
  set pw_bc [pw::BoundaryCondition getByName $bc]

  # Get blk pw object by name
  set pw_blk [pw::GridEntity getByName $blk]

  foreach dom $domains_in_block_list {
    # Get dom pw object by name
    set pw_dom [pw::GridEntity getByName $dom]

    # Construct local_bc_list; "Same" mean it belongs to current block
    lappend local_bc_list [list $pw_blk $pw_dom Same]

    # Apply b.c.
    $pw_bc apply [list $pw_blk $pw_dom]
  }

  # deallocate
  unset pw_bc
  unset pw_blk
  unset pw_dom
  unset local_bc_list
  unset dom
}

