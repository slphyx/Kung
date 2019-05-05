
# generate the ui.R file from the model code
# txt <- ReadInputString("file.R")
GenShinyFiles <- function(txt,path){

  starttxt <- ExtractInputFromKey(txt,'!Start') %>% RemoveRN
  odetxt <- ExtractInputFromKey(txt,'!ODECMD') %>% RemoveRN
  partxt <- ExtractInputFromKey(txt, '!Parameters') %>% RemoveRN
  posttxt <- ExtractInputFromKey(txt, '!PostProcess') %>% RemoveRN
  ctrltxt <- ExtractInputFromKey(txt, '!Controls') %>% RemoveRN
  plottxt <- ExtractInputFromKey(txt, '!Plots') %>% RemoveRN

  # list of control parameters
  ctrlpars <- ctrltxt %>% GetParFromControls

  # new parameters after removing the control parameters
  newpars <- partxt
  for(i in 1:length(ctrlpars))
    newpars <- newpars %>% RemovePar(par=ctrlpars[i]) %>% RemoveLastComma

  newpars <- newpars %>% RemoveLastComma %>% AddParVar(parvar='parms') %>% is.par.alone(parvar='parms')


  # add CONTROLS
  ui_txt <- ui %>% gsub(pattern = 'CONTROLS', replacement = ctrltxt)

  # add ode function
  sv_txt <- sv %>% gsub(pattern = 'ODEFUNC', replacement = starttxt)

  # add PARAMETERS
  sv_txt <- sv_txt %>% gsub(pattern = 'PARAMETERS', replacement = newpars)

  # add ode cmd
  sv_txt <- sv_txt %>% gsub(pattern = 'ODECMD', replacement= odetxt)

  # add server input controls
  sv_txt <- sv_txt %>% gsub(pattern = 'INPUTCONTROLS', replacement = GenServerControls(ctrltxt))

  # add postprocecss
  sv_txt <- sv_txt %>% gsub(pattern = 'POSTPROCESS' , replacement = posttxt)

  # add Plot
  sv_txt <- sv_txt %>% gsub(pattern = 'PLOTCODES', replacement = plottxt)

  tmpdir <- path
  #message(paste0("tempory directory has been created...",tmpdir))

  #write ui/server files
  uifile <- paste0(tmpdir,"/ui.R")
  svfile <- paste0(tmpdir,"/server.R")

  WriteTxt(txt = ui_txt, filename=uifile)
  message(paste0(uifile," has been written."))
  WriteTxt(txt = sv_txt, filename=svfile)
  message(paste0(svfile," has been written."))

}
