% This script is meant to be updated every time a new piece of equipment is
% used for home-delivery or after sufficient time has passed and a new
% calibration is desired. Calibrations must be complete using the
% Calibration Toolbox with the MATLAB scripts for home delivery.
% 
% Sean R. Anderson - sean.hearing@gmail.com - 070721

% Calibration values approximated from ToneLevelCalibrationSheet.xlsx
% Calibrations for Surface Tablet 1, using headphones xx
% Calibrations complete by Sean R. Anderson 072221

function [LevelFac,dBHL] = LevelCalibrations(LevelStep,FreqIdx,Ear)


    switch FreqIdx
        case 1 % 0.25 kHz

            CalibLevels = [6.971E-04	8.848E-04;...   % 20 dB HL
                1.272E-03	1.592E-03;...               % 25 dB HL
                2.322E-03	2.863E-03;...               % 30 dB HL
                4.238E-03	5.150E-03;...               % 35 dB HL
                7.736E-03	9.264E-03;...               % 40 dB HL
                1.412E-02	1.666E-02;...               % 45 dB HL
                2.577E-02	2.998E-02;...               % 50 dB HL
                4.704E-02	5.392E-02;...               % 55 dB HL
                8.585E-02	9.699E-02];                 % 60 dB HL
            
        case 2 % 0.5 kHz
            
            CalibLevels = [1.467E-04	1.521E-04;...   % 20 dB HL
                2.610E-04	2.767E-04;...               % 25 dB HL
                4.645E-04	5.036E-04;...               % 30 dB HL
                8.267E-04	9.164E-04;...               % 35 dB HL
                1.471E-03	1.668E-03;...               % 40 dB HL
                2.618E-03	3.035E-03;...               % 45 dB HL
                4.660E-03	5.522E-03;...               % 50 dB HL
                8.293E-03	1.005E-02;...               % 55 dB HL
                3.451E-02	1.829E-02];                 % 60 dB HL
            
        case 3 % 1 kHz
            
            CalibLevels = [7.740E-05	9.205E-05;...   % 20 dB HL
                1.413E-04	1.637E-04;...               % 25 dB HL
                2.578E-04	2.911E-04;...               % 30 dB HL
                4.706E-04	5.176E-04;...               % 35 dB HL
                8.588E-04	9.204E-04;...               % 40 dB HL
                1.567E-03	1.637E-03;...               % 45 dB HL
                2.861E-03	2.910E-03;...               % 50 dB HL
                5.221E-03	5.175E-03;...               % 55 dB HL
                9.530E-03	9.203E-03];                 % 60 dB HL
            
        case 4 % 2 kHz
            
            CalibLevels = [1.411E-04	1.676E-04;...   % 20 dB HL
                2.636E-04	3.133E-04;...               % 25 dB HL
                4.925E-04	5.854E-04;...               % 30 dB HL
                9.201E-04	1.094E-03;...               % 35 dB HL
                1.719E-03	2.044E-03;...               % 40 dB HL
                3.212E-03	3.820E-03;...               % 45 dB HL
                6.000E-03	7.139E-03;...               % 50 dB HL
                1.121E-02	1.334E-02;...               % 55 dB HL
                2.094E-02	2.493E-02];                 % 60 dB HL
            
        case 5 % 4 kHz
            
            CalibLevels = [1.963E-04	2.256E-04;...   % 20 dB HL
                3.530E-04	4.050E-04;...               % 25 dB HL
                6.350E-04	7.272E-04;...               % 30 dB HL
                1.142E-03	1.306E-03;...               % 35 dB HL
                2.055E-03	2.344E-03;...               % 40 dB HL
                3.696E-03	4.209E-03;...               % 45 dB HL
                6.648E-03	7.557E-03;...               % 50 dB HL
                1.196E-02	1.357E-02;...               % 55 dB HL
                2.151E-02	2.436E-02];                 % 60 dB HL
            
        case 6 % 8 kHz
            
            CalibLevels = [7.277E-05	7.830E-05;...   % 20 dB HL
                1.318E-04	1.407E-04;...               % 25 dB HL
                2.388E-04	2.528E-04;...               % 30 dB HL
                4.327E-04	4.541E-04;...               % 35 dB HL
                7.840E-04	8.159E-04;...               % 40 dB HL
                1.420E-03	1.466E-03;...               % 45 dB HL
                2.573E-03	2.634E-03;...               % 50 dB HL
                4.662E-03	4.732E-03;...               % 55 dB HL
                8.446E-03	8.502E-03];                 % 60 dB HL
            
        otherwise
            error('An incorrect frequency index was sent to LevelCalibrations!');
    end
    StepsHL = [20 25 30 35 40 45 50 55 60];
    
    dBHL = StepsHL(LevelStep);
    LevelFac = CalibLevels(LevelStep,Ear);

end