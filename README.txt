Marques D. B. Adaptations of common MATLAB scripts to calculate spectral mean phase coherence. 2023.

Adapts commonly used MATLAB routines for spectral coherence estimation but adds mean phase coherence (MPC) and mean phase difference (MDP) estimates as possible outputs:

	mscohere (MATLAB built-in) 	>>> 	mpcspectrum
	coherencyc (Chronux)  		>>> 	mtmpcspectrum 
	cohgramc (Chronux) 		>>> 	mtmpcgramc 

Mean phase coherence is equivalent to frequency-wise phase-locking value:

	MPC = abs(mean(exp(1i*angle(Sxy(f,w)))));

Author: Danilo Benette Marques
Date: 2020
Institution: Department of Neuroscience and Behavioral Sciences, Ribeirão Preto Medical School (FMRP), University of São Paulo (USP)
Financial Support: FAPESP, CAPES, CNPq
