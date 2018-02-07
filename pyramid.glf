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
set SQRT2         1.41421356237

set W             1.0   

# Concerning resolution
set N            10

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

Delnov_Create_Point [expr $X_0 + $W/2.0]           \
                    [expr $Y_0 + $W/2.0]           \
                    [expr $Z_0 + $W/2.0 * $SQRT2]

puts "Defined all the points"

#-----------------
# Define segments 
#-----------------
Delnov_Create_Line "point-1" "point-2" 
Delnov_Create_Line "point-2" "point-3" 
Delnov_Create_Line "point-3" "point-4" 
Delnov_Create_Line "point-4" "point-1" 

Delnov_Create_Line "point-1" "point-5" 
Delnov_Create_Line "point-2" "point-5" 
Delnov_Create_Line "point-3" "point-5" 
Delnov_Create_Line "point-4" "point-5" 

#--------------------------------------
# Define resolution on all connections
#--------------------------------------
set all_con [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] "con"]
Delnov_Modify_Dimension $all_con $N
unset all_con

#------------------
# Creating domains
#------------------
Delnov_Create_Domain "con-1"  "con-2"  "con-3"  "con-4"
Delnov_Create_Unstructured_Domain "con-1"  "con-6"  "con-5" 
Delnov_Create_Unstructured_Domain "con-2"  "con-7"  "con-6" 
Delnov_Create_Unstructured_Domain "con-3"  "con-8"  "con-7" 
Delnov_Create_Unstructured_Domain "con-4"  "con-8"  "con-5" 

puts "Defined domains"

#----------------
# Create a block
#----------------
Delnov_Create_Unstructured_Block [list "dom-1" "dom-2" "dom-3" "dom-4" "dom-5"]

puts "Defined a block"

#-----------------------------
# Specify boundary conditions 
#-----------------------------
Delnov_Introduce_Bnd_Conds [list "bottom" "west" "east" "south" "north"]

set bc [pw::BoundaryCondition getByName "bottom"]
$bc apply [list [pw::GridEntity getByName "blk-1"]  \
                [pw::GridEntity getByName "dom-1"]  ]

set bc [pw::BoundaryCondition getByName "west"]
$bc apply [list [pw::GridEntity getByName "blk-1"]  \
                [pw::GridEntity getByName "dom-2"]  ]

set bc [pw::BoundaryCondition getByName "east"]
$bc apply [list [pw::GridEntity getByName "blk-1"]  \
                [pw::GridEntity getByName "dom-3"]  ]

set bc [pw::BoundaryCondition getByName "south"]
$bc apply [list [pw::GridEntity getByName "blk-1"]  \
                [pw::GridEntity getByName "dom-4"]  ]

set bc [pw::BoundaryCondition getByName "north"]
$bc apply [list [pw::GridEntity getByName "blk-1"]  \
                [pw::GridEntity getByName "dom-5"]  ]

#------------------------
# Save data for analysis
#------------------------

# Select all the blocks ...
set blocks_only [Delnov_Get_Entities_By_Name_Pattern [pw::Grid getAll] "blk"]

# ... and export them
set export [pw::Application begin CaeExport [pw::Entity sort $blocks_only]]
  $export initialize -type CAE {pyramid.cgns}
  $export setAttribute FilePrecision Double
  $export setAttribute ExportParentElements true
  if {![$export verify]} {
    error "Data verification failed."
  }
  $export write
$export end
unset export
