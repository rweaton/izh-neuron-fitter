% Izh_Neuron - program to compute the membrane voltage response of a neuron


% define the time span (in ms) of integration
tSpan = 500;	% Best to keep this value an integer

% compute the step size of integration from "sampling rate" (# of points/ms)
SamplingRate = 40;
tStep = 1/SamplingRate;	 % units are ms/point

% compute the total number of iterations this routine will perform
iStop = ceil(tSpan*SamplingRate);

% define the holding potential of the system prior to current pulse (in mV)
HoldingPotential = -65;

% specify the membrane capacitance (in uF)
MemCap = 0.2;

% define parameter vector - this shapes the null clines of the system
% [a b c d e f g]
param = [0.02 0.4 -65 ];

% define inital state vector - initial conditions of the system [u v]
state = [ HoldingPotential];
t = 0;


% generate the stimulus pulse
PulseAmplitude = 5; 			% Units here are (nA)
PulseStartIndex = floor(iStop/3);
PulseEndIndex = floor(2*iStop/3);
StimI = [ HoldingPotential];

for j = 1:iStop
	if(i >= PulseStartIndex && i <= PulseEndIndex)
		StimValue = HoldingPotential + (PulseAmplitude/MemCap);
	else
		StimValue = HoldingPotential;
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
	state = rk4(state, t, tStep, 'IZH_MODEL', param);
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
plot(output(:,5),output(:,4));		% Phase plot 
hold on;
									% Plot null clines as dotted lines