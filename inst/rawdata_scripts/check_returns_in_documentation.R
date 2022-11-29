# with wd set to the root of the package, source this script
# it will return a list of the map pages missing returns
# note that map pages for datasets don't need returns.

check_returns_in_documentation <-function(){
  # note the additiona \ to run through system 2
  files_with_value <- basename(system2(command = "grep",
                                       args='-Ril "\\\\value" ./man/',
                                       stdout=TRUE)
                               )
  all_files<-dir ("./man")
  return(all_files[!all_files %in% files_with_value])
}
check_returns_in_documentation()
