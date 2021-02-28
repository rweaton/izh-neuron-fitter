
SequenceStart = 31;
SequenceStop = 60;
PulseAmplitude = 300;
FixedParams = [-73 325 -32 65 1];
SpikeParams = [30, -35, 10];
NullClineShapeParams = [.2275 -76.9622 8.53666 .2275];
R_m = .0605;

StwaveDir = '/Users/thug/Documents/BinderRotation/CorticalRecordings/stwaves';
IZH_NeuronDir = '/Users/thug/Documents/BinderRotation/IZH Neuron';
UnitStep = [zeros(1,20000), ones(1,380000), zeros(1,20000)];
i = 1;

for FileNum = SequenceStart:SequenceStop
    
    cd(StwaveDir);
    filename = ['stwave',num2str(FileNum),'.mat'];
    load(filename);
    stimulus = stimulus';
    StimI = PulseAmplitude*(UnitStep+stimulus);
    
    cd(IZH_NeuronDir);
    Output = IZHNeuronRunScript_WN_func(StimI, PulseAmplitude, FixedParams, SpikeParams, NullClineShapeParams, R_m);
    IZH_WN(i).FileNum = FileNum;
    IZH_WN(i).Output = Output;
    i = i + 1;
    
end