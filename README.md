The codebase will be further cleaned up in the coming weeks.

the folder fig3 is to reproduce the numerical simulations of the reduced order model in fig 3.
Basically, load the mat file and run the script.

the folder fig5_6 is to simulate the modified ring atrractor model that can recalibrate its integration gain.
The following are the instructions for this simulation:
System requirements: Any MATLAB installed machine should work.
			    The MATLAB installation should include Signal Processing toolbox and Statistics, Machine 			    Learning Toolbox. The system must have a c++ compiler recognized by Matlab (see https://www.mathworks.com/support/requirements/
			    supported-compilers.html for the list of compilers.)                                    
                                    We tested the code on a MacBook Air with a MATLAB R2024a that has these 			    toolboxes and the compiler Xcode with Clang.

Installation guide: After installing the MATLAB (~ 1hr on a typical computer), change the MATLAB’s current path to the path of the repo.
                             Run addpath(genpath(pwd)) followed by findfirst_install.m
		        
                             
Demo and instructions: main_errortheorypaper.m is the main demo file. Inside it, example codes for recalibration and error-correction are provided. Simulating a recalibration process takes about 10-30 mins, depending on the final time of the simulation and other parameters.
