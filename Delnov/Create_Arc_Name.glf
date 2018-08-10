#===============================================================================
proc Delnov_Create_Arc_Name { pnt1 pnt2 x y z name } {
#-------------------------------------------------------------------------------

  set create [pw::Application begin Create]

    set pnts [pw::SegmentCircle create]

    # Define points for the circle
    $pnts addPoint [list 0 0 [pw::DatabaseEntity getByName $pnt1]]
    $pnts addPoint [list 0 0 [pw::DatabaseEntity getByName $pnt2]]
    $pnts setCenterPoint [list $x $y $z]

    # Define curve for this connection
    set curve [pw::Connector create]
    $curve addSegment $pnts
    $curve calculateDimension
    $curve setName $name

  $create end
  unset create
}

