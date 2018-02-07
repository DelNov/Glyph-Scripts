#------------------
# Initial settings
#------------------
package require PWI_Glyph 2.18.0
pw::Application setUndoMaximumLevels 5
pw::Application reset
pw::Application markUndoLevel {Journal Reset}
pw::Application clearModified

#--------------------
# Set solver to CGNS
#--------------------
pw::Application setCAESolver {CGNS} 3

#----------------------------------------
# Constants (parameters) for this script
#----------------------------------------
set PI            3.14159265359
set W             0.034
set H             0.01
set R             0.0125
set BL            [expr $R * 0.1]
set Y_FIRST_ROD   0.0001
set Y_FIRST_WALL  0.0002

# Concerning resolution
set N_SUB            4
set N_BND_LAY        9    
set N_CORE          11    
set N_TANG_12_TENT  15   ; # It has 12 because it covers one twelvth of the rod 
set N_TANG_12_FINE  17   ; # It has 12 because it covers one twelvth of the rod 
set N_H              5

# Coordinates origin
set X_0  0.0    ; # [expr -$W * 0.5]
set Y_0  $X_0
set Z_0  0.0

# Some helping variables which (most likely) don't need adjustment
set ANGLE_DEG  30
set ANGLE_RAD  [expr $ANGLE_DEG * $PI / 180.0]
set RBL        [expr $R + $BL]
set W_HALF     [expr $W * 0.5]
set A          [expr $W_HALF / (sqrt(2.0)+1)]
set B_MIN      [expr $R * 0.5]
set B_MAX      [expr ($W * $N_SUB) - $R * 0.5]
set W_MIN      [expr $BL * 0.5]
set W_MAX      [expr ($W * $N_SUB) - $BL * 0.5]

source "delnov.glf"

#------------------------
# Four points on the rod
#------------------------
[pw::Point create]  setPoint [list [expr $X_0 + $R]  \
                                   $Y_0              \
                                   $Z_0]
[pw::Point create]  setPoint [list [expr $X_0 + $R * cos($ANGLE_RAD)]  \
                                   [expr $Y_0 + $R * sin($ANGLE_RAD)]  \
                                   $Z_0]
[pw::Point create]  setPoint [list [expr $X_0 + $R * sin($ANGLE_RAD)]  \
                                   [expr $Y_0 + $R * cos($ANGLE_RAD)]  \
                                   $Z_0]
[pw::Point create]  setPoint [list $X_0              \
                                   [expr $Y_0 + $R]  \
                                   $Z_0]

#----------------------------------------------
# Four points on the rod on the boundary layer
#----------------------------------------------
[pw::Point create]  setPoint [list [expr $X_0 + $RBL]  \
                                   $Y_0              \
                                   $Z_0]
[pw::Point create]  setPoint [list [expr $X_0 + $RBL * cos($ANGLE_RAD)]  \
                                   [expr $Y_0 + $RBL * sin($ANGLE_RAD)]  \
                                   $Z_0]
[pw::Point create]  setPoint [list [expr $X_0 + $RBL * sin($ANGLE_RAD)]  \
                                   [expr $Y_0 + $RBL * cos($ANGLE_RAD)]  \
                                   $Z_0]
[pw::Point create]  setPoint [list $X_0              \
                                   [expr $Y_0 + $RBL]  \
                                   $Z_0]

#-------------------------------
# Four points in the subchannel
#-------------------------------
[pw::Point create]  setPoint [list [expr $X_0 + $W_HALF]       \
                                   $Y_0                        \
                                   $Z_0]
[pw::Point create]  setPoint [list [expr $X_0 + $W_HALF]       \
                                   [expr $Y_0 + $W_HALF - $A]  \
                                   $Z_0]
[pw::Point create]  setPoint [list [expr $X_0 + $W_HALF - $A]  \
                                   [expr $Y_0 + $W_HALF]       \
                                   $Z_0]
[pw::Point create]  setPoint [list [expr $X_0]                 \
                                   [expr $Y_0 + $W_HALF]       \
                                   $Z_0]

puts "Defined all the points"

#-----------------------------------------
# Define segment of the rod, one to three
#-----------------------------------------
Delnov_Create_Arc_Name "point-1" "point-2" $X_0 $Y_0 $Z_0 "seg-1"
Delnov_Create_Arc_Name "point-2" "point-3" $X_0 $Y_0 $Z_0 "mid-1"     
Delnov_Create_Arc_Name "point-4" "point-3" $X_0 $Y_0 $Z_0 "seg-2" 

#-----------------------------------------
# Define segment of the rod, one to three
#-----------------------------------------
Delnov_Create_Arc_Name "point-5" "point-6" $X_0 $Y_0 $Z_0 "seg-3"
Delnov_Create_Arc_Name "point-6" "point-7" $X_0 $Y_0 $Z_0 "mid-2"
Delnov_Create_Arc_Name "point-8" "point-7" $X_0 $Y_0 $Z_0 "seg-4"

#----------------------------------------------------------
# Segments inside the boundary layer stemming from the rod
#----------------------------------------------------------
Delnov_Create_Line_Name "point-1" "point-5" "lay-1"
Delnov_Create_Line_Name "point-4" "point-8" "lay-2"

#------------------------------------------------------------
# Segments stemming from the boundary layer towards the core
#------------------------------------------------------------
Delnov_Create_Line_Name "point-5" "point-9"  "cor-1"
Delnov_Create_Line_Name "point-6" "point-10" "cor-2"
Delnov_Create_Line_Name "point-7" "point-11" "cor-3"
Delnov_Create_Line_Name "point-8" "point-12" "cor-4"      

#--------------------------------
# Segments inside the subchannel
#--------------------------------
Delnov_Create_Line_Name "point-9"  "point-10"                "seg-5"
Delnov_Create_Arc_Name  "point-10" "point-11" $X_0 $Y_0 $Z_0 "mid-3"  
Delnov_Create_Line_Name "point-12" "point-11"                "seg-6"

# At this point you have connections called "cor", "lay", "mid", "seg" 

puts "Defined all the segments"

# Group the connections in the core, and set their resolution
set con_cor_list [list]
for {set i 1} {$i <= 4} {incr i} {
  lappend con_cor_list [pw::GridEntity getByName [format cor-%1d $i]]
}
Delnov_Set_Dimension $con_cor_list $N_CORE

# Set dimensions in the segments in tangential direction
set con_seg_list [list]
for {set i 1} {$i <= 6} {incr i} {
  lappend con_seg_list [pw::GridEntity getByName [format seg-%1d $i]]
}
Delnov_Set_Dimension $con_seg_list $N_TANG_12_FINE

# Set dimensions in the segments in the middle
set con_mid_list [list]
for {set i 1} {$i <= 3} {incr i} {
  lappend con_mid_list [pw::GridEntity getByName [format mid-%1d $i]]
}
Delnov_Set_Dimension $con_mid_list $N_TANG_12_TENT

# Set dimensions in the boundary layer
set con_blay_list [list [pw::GridEntity getByName "lay-1"]    \
                        [pw::GridEntity getByName "lay-2"]]
Delnov_Set_Dimension $con_blay_list $N_BND_LAY

#------------------
# Creating domains
#------------------
Delnov_Create_Domain "cor-1" "seg-5" "cor-2" "seg-3"
Delnov_Create_Domain "cor-2" "mid-3" "cor-3" "mid-2"
Delnov_Create_Domain "cor-3" "seg-6" "cor-4" "seg-4"
Delnov_Create_Domain [list "seg-3" "mid-2" "seg-4"]   \
                           "lay-2"                    \
                     [list "seg-2" "mid-1" "seg-1" ]  \
                           "lay-1"

puts "Defined domains"

#---------------------------------------
# Set first cell size on the wall
#---------------------------------------
Delnov_Set_Begin_Spacing $con_blay_list $Y_FIRST_ROD

# Get the first and last cell size in boundary layer

#---------------------------------------
# Set spacing of edges in the core, 
# this here is on top of boundary layer
#---------------------------------------
set con [lindex $con_blay_list 0]
set spc [Delnov_Get_End_Spacing $con]
Delnov_Set_Begin_Spacing $con_cor_list $spc

#------------------------------------
# Set spacing towards the flat walls
#------------------------------------
Delnov_Set_Begin_Spacing $con_seg_list $Y_FIRST_WALL

#-----------------------------------------
# Re-adjust spacing in the middle segment
#-----------------------------------------

# Get last cell size in the first segment
set con [lindex $con_seg_list 0]
set dim [$con getDimension]
set last_spc [Delnov_Get_End_Spacing $con]

# Get the length of the middle segment
set con [lindex $con_mid_list 0]
set tot_len [$con getTotalLength -constrained onDB]
set new_dim [expr int(floor($tot_len / $last_spc))]

# Finaly adjust dimension
Delnov_Modify_Dimension $con_mid_list $new_dim

puts "Fixed all resolutions and spacings"

#-----------------------------------
# Copy all you have to make a cross
#-----------------------------------

set all_ents [pw::Grid getAll]
pw::Application clearClipboard
pw::Application setClipboard $all_ents
set paste [pw::Application begin Paste]
  set new_ent [$paste getEntities]
  set modify [pw::Application begin Modify $new_ent]
    pw::Entity transform [pwu::Transform mirroring  {1 0 0} $W_HALF] [$modify getEntities]
  $modify end
  unset modify
$paste end
unset paste
unset new_ent

set all_ents [pw::Grid getAll]
pw::Application clearClipboard
pw::Application setClipboard $all_ents
set paste [pw::Application begin Paste]
  set new_ent [$paste getEntities]
  set modify [pw::Application begin Modify $new_ent]
    pw::Entity transform [pwu::Transform mirroring  {0 1 0} $W_HALF] [$modify getEntities]
  $modify end
  unset modify
$paste end
unset paste
unset new_ent

# Create the central domain which was missing
Delnov_Create_Domain "mid-3" "mid-6" "mid-12" "mid-9"

puts "Created basic segment of the geometry (cross)"

#----------------------
# Make the full matrix
#----------------------
set all_ents [pw::Grid getAll]
pw::Application clearClipboard
pw::Application setClipboard $all_ents

for {set i 0} {$i < $N_SUB} {incr i} {
  for {set j 0} {$j < $N_SUB} {incr j} {
    if { [expr $i + $j >= 1] } {
      set paste [pw::Application begin Paste]
        set new_ent [$paste getEntities]
          set modify [pw::Application begin Modify $new_ent]
            pw::Entity transform                                                \
              [pwu::Transform translation [list [expr $W*$i] [expr $W*$j] 0]]   \
              [$modify getEntities]
          $modify end
          unset modify
        unset new_ent
      $paste end
      unset paste
    }
  }
}

#-----------------------------------------
# Coarsen all segments far from the walls
#-----------------------------------------
set box [list [list $B_MIN $B_MIN -1.0e+6]  \
              [list $B_MAX $B_MAX  1.0e+6]]

# Fetch all entities starting with "seg"
set seg_only     [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] "seg"]
set box_seg_only [Delnov_Get_Entities_In_Bounding_Box $seg_only $box]

set con [lindex $con_mid_list 0]
set dim [$con getDimension]
Delnov_Modify_Dimension $box_seg_only $dim

puts "Created the matrix"


# At this point you have connections called:
# "cor", "lay", "mid", "rod", "seg" 
  
#------------------------------------------------------------------
# Give all connections, except "wal" and "rod" a more generic name
#------------------------------------------------------------------
set n_con 0  ; # set counter to zero
foreach ge [pw::Grid getAll] {
  set name [$ge getName]
  if { [string match "cor" [string range $name 0 2]] == 1 ||  \
       [string match "lay" [string range $name 0 2]] == 1 ||  \
       [string match "mid" [string range $name 0 2]] == 1 ||  \
       [string match "seg" [string range $name 0 2]] == 1 } {

    incr n_con
    [pw::GridEntity getByName $name] setName [format con-%d $n_con]
  }
}

# At this point you have connections called:
# "con", "rod", "wal"

#---------------------------------------------
# Agglomerate domains in blocks more suitable 
# for subsequent creation of faces and blocks
#---------------------------------------------

# Browse through all rods and rename the rods around them to "domrod.."

# Stage 1: go through quartants
set dom_only [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] "dom"]
for {set i 0} {$i < [expr $N_SUB*2] } {incr i} {
  for {set j 0} {$j < [expr $N_SUB*2]} {incr j} {

    # Calculate quadrant box
    set x_r_min [expr $W_HALF * $i - $BL*0.5]
    set y_r_min [expr $W_HALF * $j - $BL*0.5]
    set x_r_max [expr $W_HALF * $i + $W_HALF + $BL*0.5]
    set y_r_max [expr $W_HALF * $j + $W_HALF + $BL*0.5]

    set quad_box [list [list $x_r_min  $y_r_min  -1.0e+6 ]  \
                       [list $x_r_max  $y_r_max   1.0e+6 ]]

    set dom_in_quad [Delnov_Get_Entities_In_Bounding_Box $dom_only $quad_box]

    # join them in quadrant
    set joining [pw::DomainStructured join -reject _TMP(ignored) $dom_in_quad]
    unset _TMP(ignored)
    unset joining
  }
}
unset dom_only

# Stage 2: go through rods        
set dom_only [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] "dom"]
for {set i 0} {$i <= $N_SUB} {incr i} {
  for {set j 0} {$j <= $N_SUB} {incr j} {

    # Calculate rod box
    set x_r_min [expr $W * $i - $W_HALF       - $BL*0.5]
    set y_r_min [expr $W * $j - $W_HALF       - $BL*0.5]
    set x_r_max [expr $W * $i + $W_HALF       + $BL*0.5]
    set y_r_max [expr $W * $j + $W_HALF * 0.5 + $BL*0.5]

    set rod_box [list [list $x_r_min  $y_r_min  -1.0e+6 ]  \
                      [list $x_r_max  $y_r_max   1.0e+6 ]]

    set dom_around_rod [Delnov_Get_Entities_In_Bounding_Box $dom_only $rod_box]

    # join around rod
    set joining [pw::DomainStructured join -reject _TMP(ignored) $dom_around_rod]
    unset _TMP(ignored)
    unset joining


    # Calculate rod box
    set x_r_min [expr $W * $i - $W_HALF       - $BL*0.5]
    set y_r_min [expr $W * $j - $W_HALF * 0.5 - $BL*0.5]
    set x_r_max [expr $W * $i + $W_HALF       + $BL*0.5]
    set y_r_max [expr $W * $j + $W_HALF       + $BL*0.5]

    set rod_box [list [list $x_r_min  $y_r_min  -1.0e+6 ]  \
                      [list $x_r_max  $y_r_max   1.0e+6 ]]

    set dom_around_rod [Delnov_Get_Entities_In_Bounding_Box $dom_only $rod_box]

    # join around rod
    set joining [pw::DomainStructured join -reject _TMP(ignored) $dom_around_rod]
    unset _TMP(ignored)
    unset joining

  }
}    
unset dom_only

#-----------------
# Join connectors
#-----------------
set con_only [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] "con"]
set joining [pw::Connector join -reject _TMP(ignored) -keepDistribution $con_only]
unset _TMP(ignored)
unset joining
unset con_only

puts "Extending to 3D"

#-------------------
# Create new blocks 
#-------------------
set creation [pw::Application begin Create]

  # Create a list of structured faces from groups of domains
  # (These groups have been defined above) 
  set all_faces [list]
  set all_dom [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] "dom"]
  foreach dom $all_dom {
    lappend all_faces [pw::FaceStructured createFromDomains $dom]
  }

  # Create a list of new blocks to be created
  set new_blocks [list]
  foreach fac $all_faces {
    set bs [pw::BlockStructured create]
    $bs addFace $fac
    lappend new_blocks $bs
  }
  unset all_faces

$creation end
unset creation

puts "Expanding new blocks to 3D"

#-------------------------
# Define extrusion solver
#-------------------------
set extrusion_solver [pw::Application begin ExtrusionSolver $new_blocks]
  $extrusion_solver setKeepFailingStep true

  # For each block define the mode of translation and the translate direction
  foreach b $new_blocks {
    $b setExtrusionSolverAttribute Mode Translate
    $b setExtrusionSolverAttribute TranslateDirection {0 0 1}
    $b setExtrusionSolverAttribute TranslateDistance  $H
  }

  # Run the solver for desired number of steps
  $extrusion_solver run $N_H

$extrusion_solver end
unset extrusion_solver

puts "Finished"

#--------------
# Join domains
#---------------
set dom_only [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] "dom"]
set joining [pw::DomainStructured join -reject _TMP(ignored) $dom_only]
unset _TMP(ignored)
unset joining
unset dom_only

#-----------------------------
# Specify boundary conditions 
#-----------------------------

# Introduce boundary condition named "wall"
set create_bnd_cond [pw::BoundaryCondition create]
  set bnd_cond_name [pw::BoundaryCondition getByName "bc-2"]
  $bnd_cond_name setName "wall"
unset create_bnd_cond
set wall_bnd_cond [pw::BoundaryCondition getByName "wall"]

# Introduce boundary condition named "periodic"
set create_bnd_cond [pw::BoundaryCondition create]
  set bnd_cond_name [pw::BoundaryCondition getByName "bc-3"]
  $bnd_cond_name setName "periodic"
unset create_bnd_cond
set periodic_bnd_cond [pw::BoundaryCondition getByName "periodic"]

# Select all faces with boundary conditions
set per_faces [list]
set wall_faces [list]
foreach ge [pw::Grid getAll] {
  set name [$ge getName]
  if { [string match "dom" [string range $name 0 2]] == 1 } {

    # Take domain's extents
    set x_min [lindex [lindex [$ge getExtents] 0] 0]
    set x_max [lindex [lindex [$ge getExtents] 1] 0]
    set y_min [lindex [lindex [$ge getExtents] 0] 1]
    set y_max [lindex [lindex [$ge getExtents] 1] 1]
    set z_min [lindex [lindex [$ge getExtents] 0] 2]
    set z_max [lindex [lindex [$ge getExtents] 1] 2]

    if { $z_min > [expr $H - $BL] } { if { $z_max > [expr $H - $BL] } { 
      set block [pw::Block getBlocksFromDomains $ge]
      lappend per_faces [list $block $ge]
    } }
    if { $z_min < $BL } { if { $z_max < $BL } { 
      set block [pw::Block getBlocksFromDomains $ge]
      lappend per_faces [list $block $ge]
    } }

    # Walls
    if { $x_min > [expr $W*$N_SUB - $BL] } { if { $x_max > [expr $W*$N_SUB - $BL] } { 
      set block [pw::Block getBlocksFromDomains $ge]
      lappend wall_faces [list $block $ge]
    } }
    if { $x_min < $BL } { if { $x_max < $BL } { 
      set block [pw::Block getBlocksFromDomains $ge]
      lappend wall_faces [list $block $ge]
    } }

    # More walls
    if { $y_min > [expr $W*$N_SUB - $BL] } { if { $y_max > [expr $W*$N_SUB - $BL] } { 
      set block [pw::Block getBlocksFromDomains $ge]
      lappend wall_faces [list $block $ge]
    } }
    if { $y_min < $BL } { if { $y_max < $BL } { 
      set block [pw::Block getBlocksFromDomains $ge]
      lappend wall_faces [list $block $ge]
    } }

    # Walls on the rods
    if { $z_min < $BL } { if { $z_max > [expr $H - $BL] } { 
      set block [pw::Block getBlocksFromDomains $ge]
      if { [llength $block] == 1 } {
        lappend wall_faces [list $block $ge]
      }
    } }

  }
}  

$periodic_bnd_cond apply $per_faces
$wall_bnd_cond apply     $wall_faces

#--------------------------
# Export data for analysis
#--------------------------

# Select all the blocks ...
set blocks_only [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] "blk"]

# ... and export them
set export [pw::Application begin CaeExport [pw::Entity sort $blocks_only]]
  $export initialize -type CAE {subflow_001_good.cgns}
  $export setAttribute FilePrecision Double
  $export setAttribute GridStructuredAsUnstructured true
  $export setAttribute ExportParentElements true
  if {![$export verify]} {
    error "Data verification failed."
  }
  $export write
$export end
unset export
