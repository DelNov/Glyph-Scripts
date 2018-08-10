#===============================================================================
proc Delnov_Create_Unstructured_Domain { con1_name con2_name con3_name } {
#-------------------------------------------------------------------------------
# Creates unstructured domain from three connections defined by name.
# Note that each connection can be defined as a list.
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

  $create end
  unset create
}

