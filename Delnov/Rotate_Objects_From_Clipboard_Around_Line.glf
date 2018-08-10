#===============================================================================
proc Delnov_Rotate_Objects_From_Clipboard_Around_Line { x0 y0 z0  \
                                                        x1 y1 z1  \
                                                        angle } {
#-------------------------------------------------------------------------------

  # Paste selected object from clipboard
  set paste [pw::Application begin Paste]

    # Objects created by paste
    set objects [$paste getEntities]

    # Translate selected object
    set rotate [pw::Application begin Modify $objects]

      pw::Entity transform [pwu::Transform rotation -anchor \
      [list $x0 $y0 $z0] [list $x1 $y1 $z1] $angle] [$rotate getEntities]

    $rotate end
  $paste end

  # deallocate
  unset objects
  unset paste
  unset rotate
}

