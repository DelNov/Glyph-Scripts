#===============================================================================
proc Delnov_Get_Entities_By_Name_Pattern { pattern_list } {
#-------------------------------------------------------------------------------
# Returns entities from inital "pool" whose name starts with "pattern"
#-------------------------------------------------------------------------------

  set pool [pw::Grid getAll]

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

