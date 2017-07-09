# R script to solve and plot kinetics

# Alex Archibald, ata27@cam.ac.uk

# this is the library that does the clever stuff!
# you need to install it using install.packages("deSolve") and then use it 
# by the following
require(deSolve)

# set times for the main loop
times <- seq(0,(5*86400), 600)

# generate a data frame of irradiance data
# at a lower time interval to the main loop
times2 <- seq(0, (5*86400), 3600)
sunlight <- c(0,0,0,0,0,0.5,1,1.5,2,2.5,3,4,5,4,3,2.5,2,1.5,1,0.5,0,0,0,0)
irradiance  <- data.frame(day=times2, light=c(0,rep(sunlight, 5)) )

# now generate a function to interpolate the irradiance data
light.dat <- approxfun(irradiance)

# define the value for M to fold into rate constants
M = 2.5e19; O2 = 0.2*M; H2O = 0.015*M


# set the parameters of the rate constants
parameters <- c(J1a=1e-30, k2=6e-34*M*O2, k3=1e-11, J4a=1e-30, k5=1e-11, k6=1e-10, 
                k7=1e-13, k8=8.5e-12, k9=1.4e-11, k10=6e-14, k11=2e-15, k12=7e-14,
                k13=1.1e-13, k14=2.8e-12)

# set state variables
state <- c(NO2=1e11, NO=1e9, O3=1e12, O=1e3, OH=1e3, HO2=1e5, CO=1e13, O1D=100, HONO2=0)


# define function for the rate equations
kinetics <- function(t, state, parameters){
  with(as.list(c(state, parameters)), {
    
    # define photons as a time dependent function 
    # and set photolysis rates
    photons <- light.dat(t)
    J1 <- J1a + 5e-3*photons
    J4 <- J4a + 1e-6*photons
    emis.no <- 1e7*photons
    emis.co <- 1e9*photons
    # rate of change
    # and set photolysis rates
    dNO2 = -J1*NO2   + k3*NO*O3      + k8*HO2*NO - k9*OH*NO2 +  k13*OH*HONO2
    dNO  =  J1*NO2   - k3*O3*NO      - k8*HO2*NO # + emisno*photons(t/3600)
    dO3  =  k2*O     - k3*NO*O3      - J4*O3
    dO   =  J1*NO2   - k2*O          + k5*O1D*M
    dOH  =  2.*k6*O1D*H2O - k7*OH*CO + k8*HO2*NO + k11*HO2*O3 - k12*OH*O3 - k9*OH*NO2  
    dHO2 =                  k7*OH*CO - k8*HO2*NO - k11*HO2*O3 + k12*OH*O3 - k14*HO2*HO2 # + emisho2*photons
    dCO  = -k7*OH*CO # + emisco*photons
    dO1D =  J4*O3    - k5*O1D*M     - k6*O1D*H2O
    dHONO2 = k9*OH*NO2 - k13*OH*HONO2
    
    # return list of output
    list(c(dNO2, dNO, dO3, dO, dOH, dHO2, dCO, dO1D, dHONO2), photons=photons, J1=J1, J4=J4)
  })
}

# solve!
out <- ode(y=state, times=times, func=kinetics, parms=parameters, 
           method= "radau")

plot(out, type="l")
#plot(out, type="l", lwd=2, 
#     xlab="Time (s)")
#grid()


