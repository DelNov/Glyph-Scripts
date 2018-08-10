#===============================================================================
proc Delnov_Create_Unstructured_Block { domain_name_list } {
#-------------------------------------------------------------------------------
# Creates an unstructured block from a list of domain names
#-------------------------------------------------------------------------------

  set wrapping [pw::FaceUnstructured create]

    set create_block [pw::Application begin Create]
      set block [pw::BlockUnstructured create]
      foreach dom_nam $domain_name_list {
        $wrapping addDomain [pw::GridEntity getByName $dom_nam]
      }
      $block addFace $wrapping
    $create_block end
    unset create_block

  unset wrapping

  set create_block [pw::Application begin UnstructuredSolver [list $block]]
    $create_block run Initialize
  $create_block end
  unset create_block

  set create_block [pw::Application begin UnstructuredSolver [list $block]]
  $create_block abort
  unset create_block
}

