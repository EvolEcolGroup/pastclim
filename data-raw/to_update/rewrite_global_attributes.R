rewrite_global_attributes <-
  function(old_filename,
           new_filename,
           version,
           description) {
    new_filename <- paste0(new_filename, "_v", version, ".nc")
    ncatted_string <- "-a created_by,global,c,c,'Andrea Manica'"
    ncatted_string <-
      paste0(ncatted_string,
             " -a pastclim_version,global,c,c,'",
             version,
             "'")
    ncatted_string <-
      paste0(
        ncatted_string,
        " -a link,global,c,c,'https://github.com/EvolEcolGroup/pastclim'"
      )
    ncatted_string <-
      paste0(ncatted_string,
             " -a description,global,a,c,'",
             description,
             "'")
    ncatted_string <-
      paste0(ncatted_string,
             " -a history,global,d,, -a history_of_appended_files,global,d,,")
    ncatted_string <-
      paste0(ncatted_string, " -h ", old_filename, " ", new_filename)
    ret <- system2("ncatted", ncatted_string)
    return(ret)
  }
