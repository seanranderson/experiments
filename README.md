# experiments
Code to replicate auditory experiments in MATLAB

## Overview

The goal of this repository is to make code available from experiments that 
I have conducted for researchers (or readers) who may want to replicate 
those experiments. They were conducted using custom MATLAB software. When 
papers are published that used this code, they will be mentioned within each 
sub-folder. Please forgive minimally annotated code (e.g., missing function 
descriptions) as this software is still being migrated from my devices to GitHub. 

This repository stores updated code from experiments I conducted in MATLAB 
during graduate school and my postdoctoral fellowship. They are fully automated,
including familiarization with behavioral tasks. The `bilateral-speech` 
experiment was conducted remotely and relies on the `remote-experiments` 
toolbox folder (so be sure to download both if you would like to test this). 
The `remote-experiments` toolbox includes code to measure the audiogram, but 
this can only be completed if stimuli are calibrated with the user's system.
Therefore, audiogram measurement will be skipped if the calibration values 
are empty. 

If you have any questions, and especially if you are new to programming, 
please feel free to reach out to me! 
