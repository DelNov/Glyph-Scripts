#===============================================================================
proc Delnov_Split_Structured_Domain { domain_name direction coord } {
#-------------------------------------------------------------------------------
# Splits a structured domain in specified direction ("I" or "J") and
# logical node coordinate
#-------------------------------------------------------------------------------

  # Get domain by its name
  set dom [pw::GridEntity getByName $domain_name]

  # Specify split parameters
  set split_params [list]
  lappend split_params $coord

  # Split domain in specified direction
  set split [$dom split -$direction $split_params]

  unset split
  unset split_params

  # I am not sure if this line is needed
  pw::Application markUndoLevel {Split}
}
