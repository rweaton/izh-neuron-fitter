function deriv = IZH_MODEL(s, t, tau, param)

% Returns the Right Hand Side of the Izhikevich quadratic integrate and fire neuronal model
% This function is called by rk4 and rka Runge-Kutta numerical solving routines.
%
% Inputs:
%	s	state vector, contains current values of u and v or x and y.  
%		[u v] ([x y] in the non-dimensionalized version)
%		u or x are recovery variables
%		v or y are neuron response (membrane voltage for the case of v)
%	t	time (not-used)
%	tau	time step to next iteration
%	param	row vector of the parameters that define the system of two diff. eqs.
%		[a b c d e f g I]
% Outputs:
%	deriv	Derivatives [du/dt dv/dt];
%		Derivatives of non-dimensionalized version [dx/dtau dy/dtau];

% Define Maximum voltage
MAX_VOLTAGE = 30;
ND_MAX = MAX_VOLTAGE*e/(b*f);

% Unravel param arguement
a = param(1);
b = param(2);
c = param(3);
d = param(4);
e = param(5);
f = param(6);
g = param(7);
I = param(8);

% Define non-dimensionalized parameters
alpha = e*g/(f*a); 
beta = f/a;
rho = b/a;

% Unravel state vector (original version)
u = s(1);
v = s(2);

% Unravel state vector (non-dimensionalized version)
x = s(1);
y = s(2);

if(v >= MAX_VOLTAGE)
	deriv(2) = (c - MAX_VOLTAGE)/tau;
	deriv(1) = u + d;
else
	deriv(2) = e*v^2 + f*v + g - u + I;
	deriv(1) = a*(b*v - u);
end;

% Non-dimensionalized output (code needs to be debugged and parameter values need to be verified)
%if(y >= ND_MAX)
%	deriv(2) = ( c*e/(b*f) - ND_MAX)/tau;
%	deriv(1) = x + d*f/g;
%else
%	deriv(2) = alpha*y^2 + beta*y + beta - (rho*beta/alpha)*x + beta*(I/g);
%	deriv(1) = (alpha/beta)*y - x;
%end;
return;
