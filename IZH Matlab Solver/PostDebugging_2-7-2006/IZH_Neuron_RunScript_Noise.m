% Izh_Neuron - program to compute the membrane voltage response of a neuron


% define the time span (in ms) of integration
tSpan = 100;	% Best to keep this value an integer

% compute the step size of integration from "sampling rate" (# of points/ms)
SamplingRate = 40;
tStep = 1/SamplingRate;	 % units are ms/point

% compute the total number of iterations this routine will perform
iStop = ceil(tSpan*SamplingRate);

% define the holding potential of the system prior to current pulse (in mV)
HoldingPotential = -70;

% define the membrane voltage for which the Model undergoes a hard reset
MAX_VOLTAGE = 30;

% calculate the membrane capacitance. 
% Specific Membrane Capacitance (1 uF/cm^2) * CellSurfaceArea (cm^2)
SpecificMemCap = 1;
CellSurfaceArea = 0.2;
MemCap = SpecificMemCap*CellSurfaceArea;

% define parameter vector - this shapes the null clines of the system
% [a b c d e f g]
param = [0.02 0.2 -65 2 0.04 5 140];

% define inital state vector - initial conditions of the system [u v]
state = [param(2)*HoldingPotential HoldingPotential];
t = 0;

% specify maximum amplitude of injected noise signal
NoiseMaxAmplitude = 0;

% generate the stimulus pulse
PulseAmplitude = 1.5; 			% Units here are (nA)
PulseStartIndex = floor(iStop/5);
PulseEndIndex = floor(4*iStop/5);
StimI = [0];

for j = 1:iStop
	if(j >= PulseStartIndex && j <= PulseEndIndex)
	    %StimValue = HoldingPotential + (PulseAmplitude/MemCap) + 40*(rand(1)-.5);
        StimValue =  PulseAmplitude +  (2*NoiseMaxAmplitude)*(rand(1)-.5);
    else
		StimValue = 0;
	end;
	StimI = [StimI StimValue];
end;

% Append dummy StimI value as final element of param vector
param = [param StimI(1)];

% Define initial output element
derivs = feval('IZH_MODEL', state, t, tStep, param);
output = [t StimI(1) state derivs];


% Perform Numerical Integration of IZH Neuron model by iterating over each time step in time window
for iStep = 1:iStop
	
	% Update time t for current iteration
	t = t + tStep;
	
	% Update param vector with current StimI value for that time step 
	param(8) = StimI(iStep);
	
	% Calculate the state and derivative values for this iteration
	if(state(2) >= MAX_VOLTAGE)
        state = [state(1)+param(4) param(3)];
    else
        state = rk4(state, t, tStep, 'IZH_MODEL', param);
    end;
    
	derivs = feval('IZH_MODEL', state, t, tStep, param);
	
	% Append row to output matrix
	output = [output; t StimI(iStep) state derivs];
	
end;

figure(1);
subplot(2,1,1); plot(output(:,1), output(:,4));		% Voltage over time plot
hold on;
subplot(2,1,2); plot(output(:,1), output(:,2));		% Stim voltage over time plot
hold off;

figure(2);
plot(output(:,4),output(:,5));		% Phase plot 
hold on;

% Plot null clines as dotted lines
% NullClineF = NullClineF(output(:,4),param);
% NullClineG = NullClineG(ouptut(:,4),param);
% plot(output(:,4), NullClineF, '.-k');
% plot(output(:,4), NullClineG, '.-k');
% hold off;
