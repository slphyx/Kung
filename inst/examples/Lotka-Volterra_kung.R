!Start
yini  <- c(Prey = 1, Predator = 2)
times <- seq(0, 200, by = 1)

LVmod <- function(Time, State, Pars) {
  with(as.list(c(State, Pars)), {
    Ingestion    <- rIng  * Prey * Predator
    GrowthPrey   <- rGrow * Prey * (1 - Prey/K)
    MortPredator <- rMort * Predator

    dPrey        <- GrowthPrey - Ingestion
    dPredator    <- Ingestion * assEff - MortPredator

    return(list(c(dPrey, dPredator)))
  })
}

!Parameters
parameters  <- c(
  rIng   = 0.2,
  rGrow  = 1.0,
  rMort  = 0.2 ,
  assEff = 0.5,
  K = 10
)

!ODECMD
out   <- ode(yini, times, LVmod, parms=parameters)


!PostProcess

!Plots
## User specified plotting
matplot(out[ , 1], out[ , 2:3], type = "l", xlab = "time", ylab = "Conc",
        main = "Lotka-Volterra", lwd = 2)
legend("topright", c("prey", "predator"), col = 1:2, lty = 1:2)

!Controls
sliderInput("rIng","rate of ingestion", min = 0,max = 2,step = 0.01, value = 0.2),
sliderInput("rGrow","growth rate of prey", min = 0,max = 10,step = 0.01, value = 1.0),
sliderInput("rMort","mortality rate of predator", min = 0,max = 10,step = 0.01, value = 0.2),
sliderInput("assEff","assimilation efficiency", min = 0,max = 10,step = 0.01, value = 0.5),
sliderInput("K","carrying capacity", min = 0,max = 30,step = 0.1, value = 10)


!End
