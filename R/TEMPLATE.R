ui <- '

# Sompob Saralamba <saralamba@gmail.com>

renderInputs <- function(){


  fluidRow(
    column(6,
      CONTROLS
    )
  )


}



fluidPage(
# using css theme;
# theme="simplex.min.css",
#   tags$style(type="text/css",
#   "label {font-size: 12px;}",
#   ".recalculating {opacity: 1.0;}"
#   ),

  # title
<<<<<<< HEAD
  tags$h2("Everything should be made as simple as possible, but no simpler"),
=======
  tags$h2("Mahidol Oxford Tropical Medicine Research Unit"),
>>>>>>> 9b6dc5c0b3be2c8af8fa0110dd3cffb9849c68a8
  hr(),

  fluidRow(
    column(6, tags$h3("System Parameters"))
  ),
  # add the controls
  fluidRow(
    column(6, renderInputs())
  ),

  #
  fluidRow(
    column(1,NULL),
    column(10,plotOutput("graphs")),
    column(1,NULL)
  )

)
'


sv <- '

# Sompob Saralamba <saralamba@gmail.com>

library(deSolve)

ODEFUNC

RunOde <- function(parms){

  PARAMETERS

  ODECMD

return(out)
}


shinyServer(

function(input, output, session) {


  parms <- reactive(c(

    INPUTCONTROLS

  ))


  outode <- reactive(RunOde(parms()))


  #plotting function
  plotX <- function(){

    out <- outode()

    POSTPROCESS

    PLOTCODES

  }


  output$graphs <- renderPlot({
    plotX()
  })

})





'
