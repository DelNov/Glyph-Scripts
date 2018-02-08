#===============================================================================
proc Delnov_Create_Point { x y z } {
#-------------------------------------------------------------------------------
  [pw::Point create] setPoint [list $x $y $z]
}

#===============================================================================
proc Delnov_Create_Structured_Domain { con1 con2 con3 con4 } {
#-------------------------------------------------------------------------------
  set create [pw::Application begin Create]

    # Create edges
    set edge1 [pw::Edge create]
    set edge2 [pw::Edge create]
    set edge3 [pw::Edge create]
    set edge4 [pw::Edge create]

    foreach con $con1 {$edge1 addConnector [pw::GridEntity getByName $con]}
    foreach con $con2 {$edge2 addConnector [pw::GridEntity getByName $con]}
    foreach con $con3 {$edge3 addConnector [pw::GridEntity getByName $con]}
    foreach con $con4 {$edge4 addConnector [pw::GridEntity getByName $con]}

    # Create domain
    set domain [pw::DomainStructured create]
    $domain addEdge $edge1
    $domain addEdge $edge2
    $domain addEdge $edge3
    $domain addEdge $edge4

  $create end
  unset create
}

#===============================================================================
proc Delnov_Create_Unstructured_Domain { con1 con2 con3 } {
#-------------------------------------------------------------------------------
  set create [pw::Application begin Create]

    # Create edge
    set edge [pw::Edge create]

    foreach con $con1 {$edge addConnector [pw::GridEntity getByName $con]}
    foreach con $con2 {$edge addConnector [pw::GridEntity getByName $con]}
    foreach con $con3 {$edge addConnector [pw::GridEntity getByName $con]}

    # Create domain
    set domain [pw::DomainUnstructured create]
    $domain addEdge $edge

  $create end
  unset create
}

#===============================================================================
proc Delnov_Create_Arc { pnt1 pnt2 x y z } {
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

  $create end
  unset create
}

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

#===============================================================================
proc Delnov_Create_Line { pnt1 pnt2 } {
#-------------------------------------------------------------------------------
  set create [pw::Application begin Create]

    set pnts [pw::SegmentSpline create]

    # Define points for the circle
    $pnts addPoint [list 0 0 [pw::DatabaseEntity getByName $pnt1]]
    $pnts addPoint [list 0 0 [pw::DatabaseEntity getByName $pnt2]]

    # Define curve for this connection
    set curve [pw::Connector create]
    $curve addSegment $pnts
    $curve calculateDimension

  $create end
  unset create
}  

#===============================================================================
proc Delnov_Create_Line_Name { pnt1 pnt2 name } {
#-------------------------------------------------------------------------------
  set create [pw::Application begin Create]

    set pnts [pw::SegmentSpline create]

    # Define points for the circle
    $pnts addPoint [list 0 0 [pw::DatabaseEntity getByName $pnt1]]
    $pnts addPoint [list 0 0 [pw::DatabaseEntity getByName $pnt2]]

    # Define curve for this connection
    set curve [pw::Connector create]
    $curve addSegment $pnts
    $curve calculateDimension
    $curve setName $name

  $create end
  unset create
}  

#===============================================================================
proc Delnov_Set_Begin_Spacing { con_list delta } {
#-------------------------------------------------------------------------------
  foreach con $con_list {
    set mod [pw::Application begin Modify [list $con]]
      [[$con getDistribution 1] getBeginSpacing] setValue $delta
    $mod end
  }  
}

#===============================================================================
proc Delnov_Set_Begin_Spacing_By_Name_List { con_name_list delta } {
#-------------------------------------------------------------------------------

  # Create a list of segments by provided name list ...
  set con_list [list]
  foreach name $con_name_list {
    lappend con_list [pw::GridEntity getByName $name]
  }

  # ... and call the sister function
  Delnov_Set_Begin_Spacing $con_list $delta
}

#===============================================================================
proc Delnov_Set_End_Spacing { con_list delta } {
#-------------------------------------------------------------------------------
  foreach con $con_list {
    set mod [pw::Application begin Modify [list $con]]
      [[$con getDistribution 1] getEndSpacing] setValue $delta
    $mod end
  }  
}

#===============================================================================
proc Delnov_Set_End_Spacing_By_Name_List { con_name_list delta } {
#-------------------------------------------------------------------------------

  # Create a list of segments by provided name list ...
  set con_list [list]
  foreach name $con_name_list {
    lappend con_list [pw::GridEntity getByName $name]
  }

  # ... and call the sister function
  Delnov_Set_End_Spacing $con_list $delta
}


#===============================================================================
proc Delnov_Set_Dimension { con_list n } {
#-------------------------------------------------------------------------------
  set con_coll [pw::Collection create]
  $con_coll set $con_list
  $con_coll do resetGeneralDistributions
  $con_coll do setDimension $n
}

#===============================================================================
proc Delnov_Set_Dimension_By_Name_List { con_name_list n } {
#-------------------------------------------------------------------------------

  # Create a list of segments by provided name list ...
  set seg_list [list]
  foreach name $con_name_list {
    lappend seg_list [pw::GridEntity getByName $name]
  }

  # ... and call the sister function
  Delnov_Set_Dimension $seg_list $n

  unset seg_list
}

#===============================================================================
proc Delnov_Get_Actual_Spacing { con loc } {
#-------------------------------------------------------------------------------
  if { $loc == 1 } {
    set node [$con getNode $loc]
  } else {   ; # $loc >1
    set node [$con getNode 2]
  }

  set xyz2 [$node getXYZ]

  # Set it to the second point on the con if we are interested in the beg.
  if { $loc==1 } {
    set xyz [$con getXYZ 2]

  # Set it to 2nd to last point on the con if we are interested in the end
  } else {   ; # $loc > 1
    set xyz [$con getXYZ [expr $loc -1]]

  }

  set spc [pwu::Vector3 length [pwu::Vector3 subtract $xyz $xyz2]]
  return $spc
}

#===============================================================================
proc Delnov_Get_End_Spacing { con } {
#-------------------------------------------------------------------------------

  # Fetch the dimension (resolution) of the domain ..
  set dim [$con getDimension]

  # ... to be able to fetch last actual spacing
  set spc [Delnov_Get_Actual_Spacing $con $dim]

  unset dim

  return $spc
}

#===============================================================================
proc Delnov_Get_End_Spacing_By_Name { con_name } {
#-------------------------------------------------------------------------------

  # Fetch the entity from its name ...
  set con [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] $con_name]

  # ... and call sister function to get spacing
  set dim [$con getDimension]
  set spc [Delnov_Get_Actual_Spacing $con $dim]

  unset dim
  unset con

  return $spc
}


#===============================================================================
proc Delnov_Get_Begin_Spacing { con } {
#-------------------------------------------------------------------------------
  set spc [Delnov_Get_Actual_Spacing $con 1]
  return $spc
}

#===============================================================================
proc Delnov_Modify_Dimension { con_list n } {
#-------------------------------------------------------------------------------
#   Change the resolition for a connectors in list "con_list" to "n"
#-------------------------------------------------------------------------------
  set modify [pw::Application begin Dimension]
    set con_coll [pw::Collection create]
    $con_coll set $con_list
    $con_coll do resetGeneralDistributions
    $con_coll do setDimension $n
    $con_coll delete
    unset con_coll
    $modify balance -resetGeneralDistributions
  $modify end
  unset modify
}

#===============================================================================
proc Delnov_Modify_Dimension_By_Name_Pattern { pat n } {
#-------------------------------------------------------------------------------

  # Extract grid entites by the name pattern ...
  set all_con [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] $pat]

  # ... and call the sister function
  Delnov_Modify_Dimension $all_con $n

  unset all_con
}

#===============================================================================
proc Delnov_Modify_Dimension_By_Name_List { con_names n } {
#-------------------------------------------------------------------------------
#   con_names - list of connection names
#   n         - new dimension
#-------------------------------------------------------------------------------

  # Extract grid entites by the name pattern ...
  set all_con [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] $con_names]

  # ... and call the sister function
  Delnov_Modify_Dimension $all_con $n

  unset all_con
}

#===============================================================================
proc Delnov_Get_Entities_By_Name_Pattern { pool pattern_list } {
#-------------------------------------------------------------------------------
#   Returns entities from inital "pool" whose name starts with "pattern"
#-------------------------------------------------------------------------------

  # Initialize list which will hold selected entities
  set sel_ent [list]

  # Browse through list of patterns
  foreach pattern $pattern_list {

    # Store the pattern length
    set pl [string length $pattern]

    # Browse through all grid entities
    foreach ge $pool {

      # Fetch its name
      set name [$ge getName]

      # Select it if it matches the pattern
      if { [string match $pattern [string range $name 0 [expr $pl-1]]] == 1 } { 
        lappend sel_ent $ge
      }
    }
  }

  # return selected entities
  return $sel_ent
}

#===============================================================================
proc Delnov_Get_Entities_In_Bounding_Box { pool box } {
#-------------------------------------------------------------------------------
#   Returns entities from inital "pool" in the bounding "box"
#-------------------------------------------------------------------------------

  # Initialize list which will hold selected entities
  set sel_ent [list]

  # Browse through all grid entities
  foreach ge $pool {

    # Fetch coordinates of the entity
    set xb [lindex [lindex [$ge getExtents] 0] 0]
    set yb [lindex [lindex [$ge getExtents] 0] 1]
    set zb [lindex [lindex [$ge getExtents] 0] 2]
    set xe [lindex [lindex [$ge getExtents] 1] 0]
    set ye [lindex [lindex [$ge getExtents] 1] 1]
    set ze [lindex [lindex [$ge getExtents] 1] 2]

    # puts "Entity coordinates:"
    # puts [format "%5.2f %5.2f %5.2f" $xb $yb $zb]
    # puts [format "%5.2f %5.2f %5.2f" $xe $ye $ze]

    # Fetch box' cooridnates
    set x_min [lindex [lindex $box 0] 0]
    set y_min [lindex [lindex $box 0] 1]
    set z_min [lindex [lindex $box 0] 2]
    set x_max [lindex [lindex $box 1] 0]
    set y_max [lindex [lindex $box 1] 1]
    set z_max [lindex [lindex $box 1] 2]

    # puts "Bounding box cooridnates"
    # puts [format "%5.2f %5.2f %5.2f" $x_min $y_min $z_min]
    # puts [format "%5.2f %5.2f %5.2f" $x_max $y_max $z_max]

    if {$xb > $x_min} {if {$xe > $x_min} {
    if {$yb > $y_min} {if {$ye > $y_min} { 
    if {$zb > $z_min} {if {$ze > $z_min} { 
    if {$xb < $x_max} {if {$xe < $x_max} {
    if {$yb < $y_max} {if {$ye < $y_max} { 
    if {$zb < $z_max} {if {$ze < $z_max} { 
      lappend sel_ent $ge
    } } } } } } } } } } } }
  }

  # return selected entities
  return $sel_ent
}

#===============================================================================
proc Delnov_Introduce_Bnd_Conds { bnd_cond_list } {
#-------------------------------------------------------------------------------
#   Creates a list of boundary conditions.                       
#-------------------------------------------------------------------------------

  set bc_list [list]
  set cnt 2
  foreach bc $bnd_cond_list {
    set bc_name [format bc-%d $cnt]

    set create_bnd_cond [pw::BoundaryCondition create]
      set bnd_cond_name [pw::BoundaryCondition getByName $bc_name]
      $bnd_cond_name setName $bc
      lappend $bc_list [pw::BoundaryCondition getByName $bc]
    unset create_bnd_cond

    # Increase counter by one
    set cnt [expr $cnt + 1]
  }

  return $bc_list
}

#===============================================================================
proc Delnov_Extrude_Structured_Block_By_Name_Pattern { pat dir dist n } {
#-------------------------------------------------------------------------------

  # Extract grid entites by the name pattern ...
  set all_dom [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] $pat]

  # ... and call the sister function
  Delnov_Extrude_Structured_Block $all_dom $dir $dist $n

  unset all_dom
}

#===============================================================================
proc Delnov_Extrude_Structured_Block { dom_list dir dist n } {
#-------------------------------------------------------------------------------
set creation [pw::Application begin Create]

  #----------------------------------------------------------
  # Create a list of structured faces from groups of domains
  #----------------------------------------------------------
  set all_faces [list]
  foreach dom $dom_list {
    lappend all_faces [pw::FaceStructured createFromDomains $dom]
  }

  #-------------------------------------------
  # Create a list of new blocks to be created
  #-------------------------------------------
  set new_blocks [list]
  foreach fac $all_faces {
    set bs [pw::BlockStructured create]
    $bs addFace $fac
    lappend new_blocks $bs
  }
  unset all_faces

  $creation end
  unset creation

  #-------------------------
  # Define extrusion solver
  #-------------------------
  set extrusion_solver [pw::Application begin ExtrusionSolver $new_blocks]
    $extrusion_solver setKeepFailingStep true

    # For each block define the mode of translation and the translate direction
    foreach b $new_blocks {
      $b setExtrusionSolverAttribute Mode Translate
      if { $dir == "x" } {
        $b setExtrusionSolverAttribute TranslateDirection {1 0 0}
      } elseif { $dir == "y" } {
        $b setExtrusionSolverAttribute TranslateDirection {0 1 0}
      } elseif { $dir == "z" } {
        $b setExtrusionSolverAttribute TranslateDirection {0 0 1}
      }
      $b setExtrusionSolverAttribute TranslateDistance   $dist
    }

    # Run the solver for desired number of steps
    $extrusion_solver run $n

  $extrusion_solver end
  unset extrusion_solver
}

#===============================================================================
proc Delnov_Extrude_Unstructured_Block_By_Name_Pattern { pat dir dist n } {
#-------------------------------------------------------------------------------

  # Extract grid entites by the name pattern ...
  set all_dom [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] $pat]

  # ... and call the sister function
  Delnov_Extrude_Unstructured_Block $all_dom $dir $dist $n

  unset all_dom
}

#===============================================================================
proc Delnov_Extrude_Unstructured_Block { dom_list dir dist n } {
#-------------------------------------------------------------------------------

  set creation [pw::Application begin Create]

  #----------------------------------------------------------
  # Create a list of structured faces from groups of domains
  #----------------------------------------------------------
  set all_faces [list]
  foreach dom $dom_list {
    lappend all_faces [pw::FaceUnstructured createFromDomains $dom]
  }

  #-------------------------------------------
  # Create a list of new blocks to be created
  #-------------------------------------------
  set new_blocks [list]
  foreach fac $all_faces {
    set bs [pw::BlockExtruded create]
    $bs addFace $fac
    lappend new_blocks $bs
  }
  unset all_faces

  $creation end
  unset creation

  #-------------------------
  # Define extrusion solver
  #-------------------------
  set extrusion_solver [pw::Application begin ExtrusionSolver $new_blocks]
    $extrusion_solver setKeepFailingStep true

    # For each block define the mode of translation and the translate direction
    foreach b $new_blocks {
      $b setExtrusionSolverAttribute Mode Translate
      if { $dir == "x" } {
        $b setExtrusionSolverAttribute TranslateDirection {1 0 0}
      } elseif { $dir == "y" } {
        $b setExtrusionSolverAttribute TranslateDirection {0 1 0}
      } elseif { $dir == "z" } {
        $b setExtrusionSolverAttribute TranslateDirection {0 0 1}
      }
      $b setExtrusionSolverAttribute TranslateDistance   $dist
    }

    # Run the solver for desired number of steps
    $extrusion_solver run $n

  $extrusion_solver end
  unset extrusion_solver
}

#===============================================================================
proc Delnov_Create_Unstructured_Block { domain_list } {
#-------------------------------------------------------------------------------

  set wrapping [pw::FaceUnstructured create]
  set create_block [pw::Application begin Create]
    set block [pw::BlockUnstructured create]
    foreach dom $domain_list {
      $wrapping addDomain [pw::GridEntity getByName $dom]
    }
    $block addFace $wrapping
  $create_block end
  unset create_block
  unset wrapping

  set create_block [pw::Application begin UnstructuredSolver [list $block]]
    $create_block run Initialize
  $create_block end
  unset create_block

  set create_block [pw::Application begin UnstructuredSolver [list $block]]
  $create_block abort
  unset create_block
}

#===============================================================================
proc Delnov_Get_Length_By_Name { con_name } {
#-------------------------------------------------------------------------------
# Get physical length of a connection specified by its name.
#-------------------------------------------------------------------------------

  # Fetch the connection from its name ...
  set con [pw::GridEntity getByName $con_name]

  # ... and retreive its length from database
  set len [$con getTotalLength -constrained onDB]

  unset con

  return $len
}

#===============================================================================
proc Delnov_Get_Dimension { con } {
#-------------------------------------------------------------------------------

  set dim [$con getDimension]

  return $dim
}

#===============================================================================
proc Delnov_Get_Dimension_By_Name { con_name } {
#-------------------------------------------------------------------------------
# Get physical length of a connection specified by its name.
#-------------------------------------------------------------------------------

  # Fetch the connection from its name ...
  set con [pw::GridEntity getByName $con_name]

  # ... and retreive its length from database
  set dim [$con getDimension]

  unset con

  return $dim
}

