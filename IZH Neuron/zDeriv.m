function derivs = zDeriv(v, z, params)

    %[tau_rec tau_m V_a V_plus V_minus z_slope R_m ExtI] = params;
    
    % theta and z variables must be the same size.
    tau_rec = params(1);
    z_slope = params(6);
    
    derivs = (1/tau_rec)*(z_slope.*v - z);
    
    
return