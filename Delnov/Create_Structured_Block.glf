#===============================================================================
proc Delnov_Create_Structured_Block { domain_name_list } {
#-------------------------------------------------------------------------------
# Creates a structured block from six domains
#-------------------------------------------------------------------------------

  set create_block [pw::Application begin Create]
    set block [pw::BlockStructured create]

    foreach dom_nam $domain_name_list {

      set dom [pw::GridEntity getByName $dom_nam]
      set fac [pw::FaceStructured create]
      $fac addDomain $dom
      $block addFace $fac
    }

  $create_block end
  unset create_block
}

