
# run the shinyapp
runSystem <- function(systemfile, ...){


  # message(paste0("tempory directory has been created...",tmpdir))
  #
  # #write ui/server files
  # uifile <- paste0(tmpdir,"/ui.R")
  # svfile <- paste0(tmpdir,"/server.R")
  #
  # WriteTxt(txt = ui, filename=uifile)
  # message(paste0(uifile," has been written."))
  # WriteTxt(txt = sv, filename=svfile)
  # message(paste0(svfile," has been written."))
  txt <- ReadInputString(filename = systemfile)
  tmpdir <- tempdir()

  GenShinyFiles(txt = txt, path = tmpdir)

  #launch the app
  message("\nLaunching Shiny interface... ",
          "for a large model, this might take a while.")

  shiny::runApp(tmpdir,...)

}


## export the shiny app files; ui.R and server.R
saveSystem <- function(txt,path){


  #write ui/server files
  uifile <- paste0(path,"/ui.R")
  svfile <- paste0(path,"/server.R")

  WriteTxt(txt = ui, filename=uifile)
  message(paste0(uifile," has been written."))
  WriteTxt(txt = sv, filename=svfile)
  message(paste0(svfile," has been written."))

}

#export shiny files
SaveShinyFiles <- function(systemfile, path){

  ReadInputString(systemfile) %>% GenShinyFiles(path=path)

}

