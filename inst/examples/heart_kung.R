!Start
library(deSolve)

init <- c(Y1=0,Y2=0)
timegrid <- seq(0,20*pi,0.1)

heart <- function(t, state, parms){
  with(as.list(c(state,parms,t)),{

    dY1<-Y2
    dY2<-k*sin(Y1)+sin(t)

    list(c(dY1,dY2))
  })
}

!Parameters
parameters <- c(
  k = -1.0
  )

!ODECMD

out <- ode(y = init, times = timegrid, func = heart, parms = parameters)

!PostProcess



!Plots
plot(out[,c(2,3)],col="red", type='l')


!Controls
sliderInput("k","k", min = -10,max = 10,step = 0.001, value = -1.0)

!End

