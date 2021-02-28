% IZH Neuron Run Script
% uses a fourth order Runge-Kutta numerical algorithm to
% approximate the time dependent solution to system of ODEs

% define the time span (in ms) of integration
tSpan = 750;	% Best to keep this value an integer

% compute the step size of integration from "sampling rate" (# of points/ms)
SamplingRate = 10;
tStep = 1/SamplingRate;	 % units are ms/point

% compute the total number of iterations this routine will perform
iStop = ceil(tSpan*SamplingRate);

% set initial time
t = 0;

    % generate the stimulus pulse
    %PulseAmplitude = 10;      			% Units here are (nA)
    PulseAmplitude = input('Enter current step amplitude in nA > ');
    PulseStartIndex = floor(iStop/5);   % Time of current step up
    PulseEndIndex = floor(4*iStop/5);   % Time of current step down
    StimI = [];

    for j = 1:iStop
        if(j >= PulseStartIndex && j <= PulseEndIndex)
            %StimValue = HoldingPotential + (PulseAmplitude/MemCap); % + 15*rand(1);
            StimValue = PulseAmplitude;    
        else
            %StimValue = HoldingPotential;
            StimValue = 0;
        end;
        StimI = [StimI StimValue];
    end;

FixedParams = input('Specify Cell Properties [V_rest I_thr V_thr tau_rec tau_m] > ');
R_m = (FixedParams(1,3) - FixedParams(1,1))/FixedParams(1,2)

SpikeParams = input('Specify Spiking Parameters [V_UpperLimit V_Reset z_Bump] > ');

V_UpperLimit    = SpikeParams(1,1);
V_Reset         = SpikeParams(1,2);
z_Bump          = SpikeParams(1,3);

% Fit null clines to match dynamic behavior specified by FixedParams
VoltageVec = -150:.05:50;

% Keeping V_a fixed for now
V_a              = 50;

ReDo = 'y';
while (ReDo == 'y')
    x0 = input('Specify inital param values for Null Cline Optimization procedure: [V_a, V_minus, V_plus, z_slope] > ');
    [FittedOutput, MSE] = fminsearch(@ShapeNullClines2, x0)
    FittedOutput(1,1) = V_a;                                     % Be sure to comment out this line if fitting V_a 
    PlotVoltageNullClines(VoltageVec, FittedOutput, PulseAmplitude, FixedParams(1,2), R_m);
    ReDo = input('Retry a new set of initial parameters? (y) > ', 's');
end;

%V_a              = FittedOutput(1,1);
V_minus          = FittedOutput(1,2);
V_plus           = FittedOutput(1,3);
z_slope          = FittedOutput(1,4);

%[tau_rec tau_m V_a V_minus V_plus z_slope R_m ExtI] = params;
V_mParams = [FixedParams(1,4) FixedParams(1,5) V_a V_minus V_plus z_slope R_m StimI(1)];

% Parameter Units listed below
% tau_rec (ms)  (recovery variable time constant)
% tau_m (ms)    (membrane time constant)
% V_a (mV)      (Strength of adaptation)    *(fitted by ShapeNullClines routine)
% V_minus (mV)  (root 1 of quadratic term)  *(fitted by ShapeNullClines routine)
% V_plus (mV)   (root 2 of quadratic term)  *(fitted by ShapeNullClines routine)
% z_slope       (negative slope of recovery
%                   null cline)             *(fitted by ShapeNullClines routine)
% R_m           (Membrane resistance derived 
%                   from chord)
% ExtI (nA)     (external stimulus current) 


% Specify Initial Conditions
V_m0 = FixedParams(1,1);
z_0 = z1_Generator(V_m0, V_mParams(1,3), V_mParams(1,4), V_mParams(1,5));

State = [V_m0, z_0];
    
% Define function handles to be passed into IZHNeuron Model
FnHandleList = {@vDeriv @zDeriv};



% Define initial output element
Derivs = feval(@IZHModel, State, t, tStep, V_mParams, FnHandleList);
Output = [t StimI(1) State Derivs];

    % Perform Numerical Integration of Theta Neuron model by iterating over 
    % each time step in time window
    for iStep = 1:(iStop - 1)
	
        % Update time t for current iteration
        t = t + tStep;
	
        % Update param vector with current StimI value for that time step 
        V_mParams(8) = StimI(iStep);
	
        % Calculate the state and derivative values for this iteration
        State = rk4_IZH(State, t, tStep, @IZHModel, V_mParams, FnHandleList);
        Derivs = feval(@IZHModel, State, t, tStep, V_mParams, FnHandleList);
	
        % Append row to theta output matrix
        NewOutputEntry = [ t StimI(iStep) State Derivs];
        Output = [Output; NewOutputEntry];
        
        % Reset Voltage if value is out of upper limit
        if State(1,1) >= V_UpperLimit
           State(1,1) =  V_Reset;
           State(1,2) =  State(1,2) + z_Bump;
        end
        
    end;
    
figure(1);
subplot(2,1,1); plot(Output(:,1), Output(:,3)); 	% Voltage over time plot
ylim([-100 50]);
hold on;
subplot(2,1,2); plot(Output(:,1), Output(:,2));		% Stim voltage over time plot
ylim([0, PulseAmplitude + .1*PulseAmplitude]);
hold on;

figure(2);
hold on;
% Generate Phase plot on top of pre-existing null clines
plot(Output(:,3), Output(:,4));
xlim([-100 50]);
%ylim([0 1]);
% hold on;

    