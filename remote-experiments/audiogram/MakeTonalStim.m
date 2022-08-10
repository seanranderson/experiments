function [out,cf] = MakeTonalStim(fs,PipDur,ISI,RampDur,FreqIdx,Ear,RMS,nBeeps)

    Freq = [250 500 1000 2000 4000 8000]; % Frequency in Hz
    cf = Freq(FreqIdx);

    totalDur = round(PipDur * 3 * fs + ISI * 2 * fs);
    t = 1/fs : 1/fs : PipDur;

    singleStim = AddTemporalRamps(sin(2 * pi * Freq(FreqIdx) * t),RampDur,fs,2);
    singleStim = (singleStim ./ rms(singleStim)) * RMS; % Moved to before train b/c won't account for 0s otherwise

    if nBeeps == 1
        trainStim = singleStim;
    elseif nBeeps == 2
        trainStim = [singleStim; zeros(ISI * fs,1); singleStim];
    elseif nBeeps == 3
        trainStim = [singleStim; zeros(ISI * fs,1); singleStim; ...
            zeros(ISI * fs,1); singleStim];
    end
    padLength = totalDur - length(trainStim);
    paddedStim = [trainStim; zeros(padLength,1)];
    
    if Ear == 1
        out = [paddedStim zeros(totalDur,1)];
    elseif Ear == 2
        out = [zeros(totalDur,1) paddedStim];
    end

end