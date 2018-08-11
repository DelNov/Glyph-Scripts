#===============================================================================
proc Delnov_Create_Line_From_Points_Name { pnt1_name pnt2_name line_name } {
#-------------------------------------------------------------------------------
# Creates line from two points specified by name, and names it
#
# Doesn't call sister function Delnov_Create_Line_From_Points
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

