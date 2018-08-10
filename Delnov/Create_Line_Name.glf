#===============================================================================
proc Delnov_Create_Line_Name { pnt1_name pnt2_name line_name } {
#-------------------------------------------------------------------------------

  set create [pw::Application begin Create]

    set pnts [pw::SegmentSpline create]

    # Define points for the circle
    $pnts addPoint [list 0 0 [pw::DatabaseEntity getByName $pnt1_name]]
    $pnts addPoint [list 0 0 [pw::DatabaseEntity getByName $pnt2_name]]

    # Define curve for this connection
    set curve [pw::Connector create]
    $curve addSegment $pnts
    $curve calculateDimension
    $curve setName $line_name

  $create end
  unset create
}

