function deriv = vDeriv(v, z, params)
    
% variables theta and z are required to be the same size
    
    
    %[tau_rec tau_m V_a V_minus V_plus z_slope R_m ExtI] = params;
    tau_m   = params(2);
    V_a     = params(3);
    V_minus = params(4);
    V_plus  = params(5);
    R_m     = params(7);
    ExtI    = params(8);
    
    OnesVec = ones(size(v));
    
    FirstTerm = (1/tau_m)*(1/(V_plus - V_minus))*((v - V_plus*OnesVec).*(v - V_minus*OnesVec));
    SecondTerm = - V_a*z/tau_m;
    
    deriv = FirstTerm + SecondTerm + (R_m*ExtI/tau_m)*OnesVec;
    

return