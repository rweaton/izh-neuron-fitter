%Conv2DatastrucFormat

[junk, nEntries] = size(IZH_WN)

for i = 1:nEntries
    
    datastruc(i).EpochNum = EpochNum(i);
    Trace = IZH_WN(i).Output(:,3)';
    datastruc(i).Data = Trace;
    datastruc(i).Stim = [];
    datastruc(i).SampInt = 100;
    datastruc(i).AmpGain = 2;
    datastruc(i).AmpMode = 6;
    datastruc(i).EpochTime = 0;
    
end