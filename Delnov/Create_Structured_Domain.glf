#===============================================================================
proc Delnov_Create_Structured_Domain { con1_name  \
                                       con2_name  \
                                       con3_name  \
                                       con4_name } {
#-------------------------------------------------------------------------------
# Creates structured domain from three connections defined by name.
# Note that each connection can be defined as a list itself.
#-------------------------------------------------------------------------------

  set create [pw::Application begin Create]

    # Create edges
    set edge1 [pw::Edge create]
    set edge2 [pw::Edge create]
    set edge3 [pw::Edge create]
    set edge4 [pw::Edge create]

    foreach con $con1_name {$edge1 addConnector [pw::GridEntity getByName $con]}
    foreach con $con2_name {$edge2 addConnector [pw::GridEntity getByName $con]}
    foreach con $con3_name {$edge3 addConnector [pw::GridEntity getByName $con]}
    foreach con $con4_name {$edge4 addConnector [pw::GridEntity getByName $con]}

    # Create domain
    set domain [pw::DomainStructured create]
    $domain addEdge $edge1
    $domain addEdge $edge2
    $domain addEdge $edge3
    $domain addEdge $edge4

  $create end
  unset create
}

