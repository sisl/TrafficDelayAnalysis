# TrafficDelayAnalysis
This repository contains 
1) the event-driven simulation code for traffic delay analysis at unmanaged intersections
2) the code to solve the analytical distribution of delay at unmanaged intersections (only support a 2-lane scenario currently)

Refer to the following two papers for more details:
[1] C. Liu, and M. Kochenderfer, "Analytically Modeling Unmanaged Intersections with Microscopic Vehicle Interactions"
[2] C. Liu, and M. Kochenderfer, "Analyzing Traffic Delay at Unmanaged Intersections"

--------------
eventDrivenSimulation.m
	This is the main file for event-driven simulation (EDS).


--------------
plotAnalyticalDelay.m
	This function plots probability of zero-delay or expected delay from analytical result. The figures generated in this file correspond to Fig. 7 and Fig. 8 in [2].


--------------
plotAnalyticalDistribution.m
	This file plots the theoretical distributions PT from analytical result. The figures generated in this file correspond to Fig. 9 in [2].


--------------
solvingDDE.m
	This file tries to solve a delay different equation with boundary conditions, which comes from the distribution of traffic delay under FIFO policy. The solution only considers n segments, hence is only an approximation.


--------------
steadyStateDelayFIFO.m
	This file solves the analytical distribution of delay under FIFO. It uses the equations derived in [2] as constraints and solve for the coefficients in the distribution. The distribution is approximated since the DDE is hard to solve. Approximation 1 in [2] is used.


--------------
steadyStateDelayFO.m
	This file solves the analytical distribution of delay under FO. It uses the equations derived in [2] as constraints and solve for the coefficients in the distribution.


--------------
data
	This folder contains the solutions of the analytical distributions, which are used in plotAnalyticalDelay.m and plotAnalyticalDistribution.m


--------------
lib
	This folder contains the functions supporting EDS and analysis.



By Changliu Liu
2018.5