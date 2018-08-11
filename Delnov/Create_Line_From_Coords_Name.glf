#===============================================================================
proc Delnov_Create_Line_From_Coords_Name { coor_pnt1 coor_pnt2 line_name } {
#-------------------------------------------------------------------------------
# Creates line from specified by coordinates and gives it a name
#
# Doesn't call sister function Delnov_Create_Line_From_Coords
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
    $curve setName $line_name

  $create end
  unset create
}

