#===============================================================================
proc Delnov_Create_Structured_Block { domain_name_list } {
#-------------------------------------------------------------------------------
# Creates a structured block from a list of domains
#-------------------------------------------------------------------------------

  # Fetch all domains by their names in one list
  set dom_list [list]
  foreach dom $domain_name_list {
    lappend dom_list [pw::GridEntity getByName $dom]
  }

  # Create block from the list of domains
  set create_block [pw::BlockStructured createFromDomains  \
                    -poleDomains  pole_doms                \
                    -reject       unused_doms              \
                     $dom_list]
  unset unused_doms
  unset pole_doms
  unset create_block
}

