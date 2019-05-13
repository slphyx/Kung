!Start

library(deSolve)

init <- c(S = 1-1e-6, I = 1e-6, R= 0.0)
times <- seq(0, 70, by = 1)

sir <-function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    dS <- -beta*S*I
    dI <- beta*S*I - gamma*I
    dR <- gamma*I

    return(list(c(dS, dI, dR)))
  })
}

!Parameters
parameters <- c(
  gamma = 0.14286,
  beta = 0.6
)

!ODECMD
out <- as.data.frame(ode(y = init, times = times, func = sir, parms = parameters))

!PostProcess


!Plots
matplot(times, out[,c("S","I","R")], type = "l", xlab = "Time", ylab = "Susceptibles and Recovereds", main = "SIR Model", lwd = 1, lty = 1, bty = "l", col = 2:4)
legend(40, 0.7, c("Susceptibles", "Infecteds", "Recovereds"), pch = 1, col = 2:4)

!Controls
sliderInput("beta","beta", min = 0,max = 10,step = 0.001,value = 1.4)

!End


