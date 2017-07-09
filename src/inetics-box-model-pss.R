# R script to solve and plot kinetics

# Alex Archibald, ata27@cam.ac.uk

# this is the library that does the clever stuff!
# you need to install it using install.packages("deSolve") and then use it 
# by the following
require(deSolve)

# What we are going to do is solve some simple, but stiff, ODE's. 
# J1 NO2 + hv -> NO + O
# k2 O + O2 + M -> O3 + M
# k3 NO + O3 -> NO2 + O2


# we need to set up these reactions as basic equations
# Ideally we will write a script that does this for us, but it's
# good practice to do this by hand first!
# Let's write d[X]/dt as dX
# dNO2 = -J1*NO2 +k3*NO*O3 
# dNO = J1*NO2 - k3*O3*NO 
# dO = J1*NO2 - k2*O*O2*M
# dO3 = k2*O*O2*M - k3*NO*O3 - J4*O3

# set times for the main loop
times <- seq(0,(1), 0.01)

# define the value for M to fold into rate constants
M = 2.5e19; O2 = 0.2*M; H2O = 1e17

# set the parameters of the rate constants
parameters <- c(J1a=1e-30, 
                k2=6e-34*M*O2, 
                k3=1e-11
                )

# set state variables
state <- c(NO2=5e11, NO=0, O3=1e12, O=1e3)

# define function for the rate equations
kinetics <- function(t, state, parameters){
  with(as.list(c(state, parameters)), {
    
    # define photons as a time dependent function 
    # and set photolysis rates
    J1 <- 1e-3
    # rate of change
    dNO2 = -J1*NO2 +k3*NO*O3 
    dNO = J1*NO2 - k3*O3*NO 
    dO3 = k2*O - k3*NO*O3 
    dO = J1*NO2 - k2*O
    # return list of output
    list(c(dNO2, dNO, dO3, dO))
  })
}

# solve!
out <- ode(y=state, times=times, func=kinetics, parms=parameters, 
           method= "radau")

plot(out, type="l", xlab = 'Time / s', ylab = 'Concentration / cm-3')

# results = data.frame(cbind(times,out[,2],out[,3],out[,4],out[,5]))
# colnames(results) <- c('time','NO2','NO','O3','O')

