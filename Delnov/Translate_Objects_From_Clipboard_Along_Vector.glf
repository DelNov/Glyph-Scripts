#===============================================================================
proc Delnov_Translate_Objects_From_Clipboard_Along_Vector { x y z } {
#-------------------------------------------------------------------------------

  # Paste selected object from clipboard
  set paste [pw::Application begin Paste]

    # Objects created by paste
    set objects [$paste getEntities]

    # Translate selected object
    set translate [pw::Application begin Modify $objects]

      pw::Entity transform [pwu::Transform translation [list $x $y $z]] \
       [$translate getEntities]

    $translate end
  $paste end

  # deallocate
  unset objects
  unset paste
  unset translate
}

