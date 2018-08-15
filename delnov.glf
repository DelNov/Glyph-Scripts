# General (non-Pointwise specific) functions
source "Delnov/Avg_Points.glf"

# Commands for creation of points
source "Delnov/Create_Point.glf"

# Commands for creating arcs and lines
source "Delnov/Create_Arc.glf" 
source "Delnov/Create_Arc_Name.glf" 
source "Delnov/Create_Line_From_Points.glf" 
source "Delnov/Create_Line_From_Points_Name.glf" 
source "Delnov/Create_Line_From_Coords.glf" 
source "Delnov/Create_Line_From_Coords_Name.glf" 

# Commands for creating and manipulating connectors
source "Delnov/Get_Begin_Spacing.glf"
source "Delnov/Get_Begin_Spacing_By_Name.glf"
source "Delnov/Set_Begin_Spacing.glf"
source "Delnov/Set_Begin_Spacing_By_Name_List.glf"

source "Delnov/Get_End_Spacing.glf"
source "Delnov/Get_End_Spacing_By_Name.glf"
source "Delnov/Set_End_Spacing.glf"
source "Delnov/Set_End_Spacing_By_Name_List.glf"
source "Delnov/Get_Actual_Spacing.glf"

source "Delnov/Get_Dimension.glf" 
source "Delnov/Get_Dimension_By_Name.glf"
source "Delnov/Set_Dimension.glf" 
source "Delnov/Set_Dimension_By_Name_List.glf"
source "Delnov/Modify_Dimension.glf" 
source "Delnov/Modify_Dimension_By_Name_Pattern.glf"
source "Delnov/Modify_Dimension_By_Name_List.glf"

source "Delnov/Get_Length_By_Name.glf"

# Commands for creating domains (and one for splitting)
source "Delnov/Create_Structured_Domain.glf"
source "Delnov/Create_Structured_Domain_Name.glf"
source "Delnov/Create_Unstructured_Domain.glf"
source "Delnov/Create_Unstructured_Domain_Name.glf"
source "Delnov/Split_Structured_Domain.glf"

# Commands for creation of blocks
source "Delnov/Create_Structured_Block.glf"
source "Delnov/Create_Unstructured_Block.glf"
source "Delnov/Extrude_Structured_Block.glf"
source "Delnov/Extrude_Structured_Block_By_Name_Pattern.glf"
source "Delnov/Extrude_Unstructured_Block.glf"
source "Delnov/Extrude_Unstructured_Block_By_Name_Pattern.glf"

# Manipulate objects
source "Delnov/Get_Entities_By_Name_Pattern.glf"
source "Delnov/Get_Entities_In_Bounding_Box.glf"
source "Delnov/Copy_Objects_By_Name_Into_Clipboard.glf"
source "Delnov/Translate_Objects_From_Clipboard_Along_Vector.glf"
source "Delnov/Rotate_Objects_From_Clipboard_Around_Line.glf"

# Commands for boundary conditions
source "Delnov/Introduce_Bnd_Conds.glf"
source "Delnov/Apply_Boundary_Condition_To_Domains_In_Block_By_Name.glf"
