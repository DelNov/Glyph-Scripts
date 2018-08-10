#===============================================================================
proc Delnov_Create_Unstructured_Domain_Name { con1_name  \
                                              con2_name  \
                                              con3_name  \
                                              domain_name } {
#-------------------------------------------------------------------------------
# Creates unstructured domain from three connections defined by name 
# and gives it a specified name!
#
# Doesn't call sister function: Delnov_Create_Unstructured_Domain
#-------------------------------------------------------------------------------

  set create [pw::Application begin Create]

    # Create edge
    set edge [pw::Edge create]

    foreach con $con1_name {$edge addConnector [pw::GridEntity getByName $con]}
    foreach con $con2_name {$edge addConnector [pw::GridEntity getByName $con]}
    foreach con $con3_name {$edge addConnector [pw::GridEntity getByName $con]}

    # Create domain
    set domain [pw::DomainUnstructured create]
    $domain addEdge $edge
    $domain setName $domain_name

  $create end
  unset create
}

