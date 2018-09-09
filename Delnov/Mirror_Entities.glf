#===============================================================================
proc Delnov_Mirror_Entities { entities_list dir } {
#-------------------------------------------------------------------------------
# Mirros entities given in the list in "x", "y" or "z" direction               !
#-------------------------------------------------------------------------------

  pw::Application clearClipboard
  pw::Application setClipboard $entities_list
  set paste [pw::Application begin Paste]
    set new_ent [$paste getEntities]
    set modify [pw::Application begin Modify $new_ent]
      if {      $dir ==  "x" } {
        pw::Entity transform [pwu::Transform mirroring  {1 0 0} 0] [$modify getEntities]
      } elseif { $dir == "y" } {
        pw::Entity transform [pwu::Transform mirroring  {0 1 0} 0] [$modify getEntities]
      } elseif { $dir == "z" } {
        pw::Entity transform [pwu::Transform mirroring  {0 0 1} 0] [$modify getEntities]
      }
    $modify end
    unset modify
  $paste end
  unset paste
  unset new_ent

}

