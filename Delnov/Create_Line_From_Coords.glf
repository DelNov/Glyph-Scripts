#===============================================================================
proc Delnov_Create_Line_From_Coords { coor_pnt1 coor_pnt2 } {
#-------------------------------------------------------------------------------
# Creates line from specified by coordinates
#-------------------------------------------------------------------------------

  set create [pw::Application begin Create]

    set pnts [pw::SegmentSpline create]

    # Define points for the circle
    $pnts addPoint $coor_pnt1
    $pnts addPoint $coor_pnt2 ;# e.g.: coor_pnt1 = [list $x $y $z]

    # Define curve for this connection
    set curve [pw::Connector create]
    $curve addSegment $pnts
    $curve calculateDimension

  $create end
  unset create
}

