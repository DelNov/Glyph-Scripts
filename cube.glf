#------------------
# Initial settings
#------------------
package require PWI_Glyph 2.17.0
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
set W             1.0   

# Concerning resolution
set N            11

# Coordinates origin
set X_0  0.0    ; # [expr -$W * 0.5]
set Y_0  $X_0
set Z_0  0.0

source "delnov.glf"

#---------------
# Define points 
#---------------
Delnov_Create_Point $X_0             $Y_0             $Z_0 
Delnov_Create_Point [expr $X_0 + $W] $Y_0             $Z_0 
Delnov_Create_Point [expr $X_0 + $W] [expr $Y_0 + $W] $Z_0 
Delnov_Create_Point $X_0             [expr $Y_0 + $W] $Z_0 
Delnov_Create_Point $X_0             $Y_0             [expr $Z_0 + $W]
Delnov_Create_Point [expr $X_0 + $W] $Y_0             [expr $Z_0 + $W]
Delnov_Create_Point [expr $X_0 + $W] [expr $Y_0 + $W] [expr $Z_0 + $W]
Delnov_Create_Point $X_0             [expr $Y_0 + $W] [expr $Z_0 + $W]

puts "Defined all the points"

#-----------------
# Define segments 
#-----------------
Delnov_Create_Line "point-1" "point-2" 
Delnov_Create_Line "point-2" "point-3" 
Delnov_Create_Line "point-3" "point-4" 
Delnov_Create_Line "point-4" "point-1" 

Delnov_Create_Line "point-5" "point-6" 
Delnov_Create_Line "point-6" "point-7" 
Delnov_Create_Line "point-7" "point-8" 
Delnov_Create_Line "point-8" "point-5" 

Delnov_Create_Line "point-1" "point-5" 
Delnov_Create_Line "point-2" "point-6" 
Delnov_Create_Line "point-3" "point-7" 
Delnov_Create_Line "point-4" "point-8" 

#------------------
# Creating domains
#------------------
Delnov_Create_Structured_Domain "con-1"  "con-2"  "con-3"  "con-4"   ; # bottom
Delnov_Create_Structured_Domain "con-5"  "con-6"  "con-7"  "con-8"   ; # top
Delnov_Create_Structured_Domain "con-4"  "con-12" "con-8"  "con-9"   ; # west
Delnov_Create_Structured_Domain "con-2"  "con-11" "con-6"  "con-10"  ; # east
Delnov_Create_Structured_Domain "con-1"  "con-10" "con-5"  "con-9"   ; # south
Delnov_Create_Structured_Domain "con-3"  "con-11" "con-7"  "con-12"  ; # north

puts "Defined domains"

#--------------------------------------
# Define resolution on all connections
#--------------------------------------
Delnov_Modify_Dimension_By_Name_Pattern "con" $N

#----------------
# Create a block
#----------------
set all_dom [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] "dom"]
set all_faces [list]
foreach dom $all_dom {
  lappend all_faces [pw::FaceStructured createFromDomains $dom]
}

set create [pw::Application begin Create]
  set block [pw::BlockStructured create]
  foreach face $all_faces {
    $block addFace $face
  }
$create end

puts "Defined a block"

#-----------------------------
# Specify boundary conditions 
#-----------------------------
Delnov_Introduce_Bnd_Conds [list "bottom" "top" "west" "east" "south" "north"]

set bc [pw::BoundaryCondition getByName "bottom"]
$bc apply [list [pw::GridEntity getByName "blk-1"]  \
                [pw::GridEntity getByName "dom-1"]  ]

set bc [pw::BoundaryCondition getByName "top"]
$bc apply [list [pw::GridEntity getByName "blk-1"]  \
                [pw::GridEntity getByName "dom-2"]  ]

set bc [pw::BoundaryCondition getByName "west"]
$bc apply [list [pw::GridEntity getByName "blk-1"]  \
                [pw::GridEntity getByName "dom-3"]  ]

set bc [pw::BoundaryCondition getByName "east"]
$bc apply [list [pw::GridEntity getByName "blk-1"]  \
                [pw::GridEntity getByName "dom-4"]  ]

set bc [pw::BoundaryCondition getByName "south"]
$bc apply [list [pw::GridEntity getByName "blk-1"]  \
                [pw::GridEntity getByName "dom-5"]  ]

set bc [pw::BoundaryCondition getByName "north"]
$bc apply [list [pw::GridEntity getByName "blk-1"]  \
                [pw::GridEntity getByName "dom-6"]  ]

#------------------------
# Save data for analysis
#------------------------

# Select all the blocks ...
set blocks_only [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] "blk"]

# ... and export them
set export [pw::Application begin CaeExport [pw::Entity sort $blocks_only]]
  $export initialize -type CAE {cube.cgns}
  $export setAttribute FilePrecision Double
  $export setAttribute GridStructuredAsUnstructured true
  $export setAttribute ExportParentElements true
  if {![$export verify]} {
    error "Data verification failed."
  }
  $export write
$export end
unset export
