#===============================================================================
proc Delnov_Extrude_Structured_Block { dom_list dir dist n } {
#-------------------------------------------------------------------------------
# Extrudes structured block from domains given in list dom_list
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

