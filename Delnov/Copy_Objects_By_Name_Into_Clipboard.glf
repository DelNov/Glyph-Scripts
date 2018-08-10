#===============================================================================
proc Delnov_Copy_Objects_By_Name_Into_Clipboard { object_list } {
#-------------------------------------------------------------------------------

  set local_clipboard_list [list]

  foreach object $object_list {

    # Select object from object_list by name
    set pw_object_in_clipboard [pw::GridEntity getByName $object]

    # Construct local_clipboard_list
    lappend local_clipboard_list $pw_object_in_clipboard
  }

  # Copy to clipboard
  pw::Application setClipboard $local_clipboard_list

  # deallocate
  unset pw_object_in_clipboard
  unset local_clipboard_list
  unset object
}

