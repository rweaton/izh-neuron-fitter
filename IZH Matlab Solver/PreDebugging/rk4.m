function xout = rk4(x, t, tau, derivsRK, param)

%	Runge-Kutta integrator (Fourth order)
%	Input Arguments:
%	x = current value of dependent variable. Either scalar or vector
%	t = independent variable (usually time)
%	tau = step size (usually time step)
%	I = external stimulus current at the current time step.
%	derivsRK = right hand side of ODE; derivsRK is the name of the 
%			function which returns dx/dt Calling format
%			derivsRK(x, t, tau, param). Either scalar or vector.
%	param = extra parameters passed to derivsRK
%	Output Arguments:
%	xout = new value of x after a step of size tau.  Either scalar or vector.

half_tau = 0.5*tau;
F1 = feval(derivsRK, x, t, tau, param);
t_half = t + half_tau;
xtemp = x + half_tau*F1;
F2 = feval(derivsRK, xtemp, t_half, tau, param);
xtemp = x + half_tau*F2;
F3 = feval(derivsRK, xtemp, t_half, tau, param);
t_full = t + tau;
xtemp = x + tau*F3;
F4 = feval(derivsRK, xtemp, t_full, tau, param);

xout = x + tau/6.*(F1 + F4 + 2.*(F2+F3));
return;
