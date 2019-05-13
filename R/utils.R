# read from input string

MAEMOD_Keys <-c("!Start", "!ODECMD", "!Parameters", "!PostProcess", "!Controls", "!Plots", "!End")

# number of keys
No_Keys <- length(MAEMOD_Keys)

##  read the input from a text file
ReadInputString <-function(filename){
  readChar(filename,file.size(filename))
}

KeyLength <-function(key){
  if(key %in% MAEMOD_Keys){
    return(nchar(key))
  }
  else
  {
    stop("The input key does not exist. \n
         The required keys are '!Start', '!ODECMD', '!Parameters', '!PostProcess', '!Controls', '!Plots', '!End'.")
  }
}


# give the position of each keyword
KeyWordsPosition<-function(inputstring){
  rawpos<-gregexpr(pattern = '!',inputstring)
  len<-length(rawpos[[1]])

  if(len != No_Keys){
    stop("PLEASE CHECK YOUR INPUT KEYS!")
  }

  keyspos<-1:No_Keys
  #pos<-unlist(rawpos)
  for(i in 1:No_Keys){
    keyspos[i]<-unlist(gregexpr(MAEMOD_Keys[i],inputstring))
  }

  KW<-data.frame(keys=MAEMOD_Keys,positions=keyspos)
  #sorting based on the positions
  return(KW[sort.list(KW$positions),])
}

#extracting the inputs using the keywords
ExtractInputs<-function(keypositions, inputstring){
  keys<-as.vector(keypositions$keys)
  pos<-keypositions$pos
  extractstring<-vector(mode = "character",length = length(pos))
  for(i in 1:(No_Keys-1)){
    extractstring[i]<-substr(inputstring,pos[i]+KeyLength(keys[i]),pos[i+1]-1)
  }
  return(data.frame(keys=keys,inputs=extractstring, stringsAsFactors=FALSE))
}

#extrating from a file
ExtractInputsFromFile<-function(filename){
  if(file.exists(filename)){
    inputstring<-ReadInputString(filename)
    KW<-KeyWordsPosition(inputstring)
    extracted<-ExtractInputs(KW,inputstring)
  }else
  {
    stop("Where is your input file!? It is not in your working directory.")
  }
  return(extracted)
}

#retunrn the input text for each section key
ExtractInputFromKey <- function(intext, key){

  KW<-KeyWordsPosition(inputstring = intext)
  extractedstring<-ExtractInputs(keypositions = KW, inputstring = intext)

  outstr<-as.character(extractedstring[extractedstring$keys==key,2])
  return(outstr)

}


# remove '\n' and ' ' from string input
RemoveSpace <- function(input){
  #remove '\n'
  tmp <- str_replace_all(string = input, pattern = "\n", replacement = "")
  #remove white space ' '
  tmp <- str_replace_all(string = tmp, pattern = " ", replacement = "")
  return(tmp)
}

#for solving the '\r\n' problem
# remove \r
RemoveRN <- function(input){
  stringr::str_replace_all(string = input, pattern = "\r", replacement = "")
}


###
# write txt as a text file
WriteTxt <- function(txt="", filename) {

  con <- file(filename, "w")
  tryCatch({
    cat(iconv(txt, to="UTF-8"), file=con, sep="\n")
  },
  finally = {
    close(con)
  })
}


### taking last n characters of a string x
substrRight <- function(x, n){
  substr(x, nchar(x) -n +1, nchar(x))
}


# find and remove the line of an unwanted parameter
RemovePar <- function(par,txt){
  a <- unlist(strsplit(txt,split='\n'))
  len <- length(a)
  tmp <- vector('integer',length = len)

  print(a)
  #paste(a[!(unlist(gregexpr(par,a)) > 1)], collapse = '\n')
  for(i in 1:len)
    tmp[i] <- gregexpr(par,a)[[i]][1]

  print(tmp)
  paste(a[!(tmp > 1)], collapse = '\n')
}

## remove '\n'
RemoveN <- function(txt){
  w <- unlist(stringr::str_split(txt,'\n'))
  paste(w[w !=""],collapse = '\n')
}


# remove ',' from the last parameter
# txt is the text of the paramers
RemoveLastComma <- function(txt){
  w <- txt %>% RemoveN %>% stringr::str_split(pattern = '\n') %>% unlist
  len <- length(w)
  lastpar <- (w %>% tail(n      =2))[1]

  #check the last par has comma at the end
  if(substrRight(lastpar,1)==","){
    removed <- substr(lastpar,start=1,stop=nchar(lastpar)-1)
    w[len-1] <- removed
  }

  paste(w,collapse = '\n')
}

## add parameters var into !Parameters
AddParVar <- function(txt, parvar){

  #txt must has no comma at the last par
  w <- RemoveN(txt) %>% stringr::str_split(pattern = '\n') %>% unlist
  len <- length(w)

  append(w, values = paste(',',parvar,'\n'), after = len - 1) %>% paste(collapse = '\n')

}


# get the list of  the model parameter names from !Controls
GetParFromControls <- function(txt){
  #clean by remove RN and N
  w <- txt %>% RemoveRN %>% RemoveN

  #break txt as a vector of strings and find the postions of 'sliderInput'
  vec <- unlist(strsplit(w,','))
  pos <- vec %>% gregexpr(pattern = 'sliderInput') %>% unlist

  #remove \"
  tmp <- vec[pos > -1] %>% gsub(pattern = 'sliderInput', replacement="") %>% gsub(pattern = '\"', replacement ="")
  #remove '\n'
  tmp <- tmp %>% gsub(pattern = '\n',replacement ="")
  #remove '('
  tmp <- tmp %>% gsub(pattern = "(", replacement ="",fixed=T)

  tmp
}

#generate the reactive parameters for the server side
#using txt from !Controls
GenServerControls <- function(txt){
  pars <- GetParFromControls(txt)
  len <- length(pars)
  tmp <- pars
  for(i in 1:len)
    tmp[i] <- paste0(pars[i],"= input$",pars[i])

  paste(tmp,collapse = ',\n')
}


GetParametersLength <- function(partxt){
  eval(parse(text = partxt))
  length(parameters)
}


# check if there is only on parameter variable (for server.R) in parameter
# haha if yes them remove the infront comma
is.par.alone <- function(parstxt){

  # looking for = symbol
  tmp <- gregexpr(pattern = '=',parstxt) %>% unlist

  newpars <- parstxt

  if(tmp[1] < 1)
    newpars <- parstxt %>% RemoveN %>% strsplit(split=',') %>% unlist %>% paste(collapse="")

  newpars
}


