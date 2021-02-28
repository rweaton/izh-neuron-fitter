function output = ImprovedNullClineShaper(x0)
    
    % Remember that for this routine, V_a is specified by user      
                      
    V_minus = x0(1,1);
    V_plus  = x0(1,2);
    z_slope = x0(1,3);
    
    FixedParams = evalin('base','FixedParams');

    
    function output = Comparator(V_minus, V_plus, z_slope, FixedParams)

        % FixedParams = [V_rest I_thr V_thr V_a tau_rec tau_m]
        V_rest  = FixedParams(1,1);
        I_thr   = FixedParams(1,2);
        V_thr   = FixedParams(1,3);
        V_a     = FixedParams(1,4);
        tau_rec = FixedParams(1,5);
        tau_m   = FixedParams(1,6);
           
        R_m = (V_thr - V_rest)/I_thr; % Keep in mind that this resistance
                                      % is derived from the chord between
                                      % V_rest(I=0) and V_thr(I_thr)
                                      
        b_term = (1 + V_a*z_slope)*V_plus + (1 - V_a*z_slope)*V_minus;
        
        V_restConstraint = (V_rest - (b_term - sqrt(b_term^2 - 4*V_plus*V_minus))/2)^2;        
        I_thrConstraint = (I_thr - (1/((R_m)*(V_plus - V_minus)))*((1/4)*b_term^2 - V_plus*V_minus))^2;
        V_thrConstraint = (V_thr - (1/2)*b_term)^2;
        
%         if (z_slope < 0)
%             I_thrConstraint = (I_thr - ((R_m)/(V_plus - V_minus))*((1/4)*b_term^2 - V_plus*V_minus))^2;
%             V_thrConstraint = (V_thr - (1/2)*b_term)^2;
%         end;
%         
%         if (z_slope >= 0)
%             I_thrConstraint = (I_thr - (1/(4*R_m*(V_plus - V_minus)))*(b_term^2 - 4*V_plus*V_minus - ((V_plus - V_minus)*V_a*z_slope)^2))^2;
%             V_thrConstraint = (V_thr - (V_plus + V_minus)/2)^2;
%         end;
        
        output = V_restConstraint + V_thrConstraint + I_thrConstraint;
                                      
        UpperLimit = ((tau_m/tau_rec)*(V_plus - V_minus) + (V_plus + V_minus))/2;
        LowerLimit = ((V_a*z_slope)*(V_plus - V_minus) + (V_plus + V_minus))/2;
        
%         v_fixed = ((V_plus + V_minus + V_a*z_slope) - sqrt((V_plus + V_minus + V_a*z_slope)^2 - 4*V_plus*V_minus))/2;
%         
%         if (v_fixed < LowerLimit) || (v_fixed > UpperLimit)
%             output = 10*output;
%         end;
        
        if (V_plus < V_minus)
            output = 10*output;
        end;
        
        if (abs(V_minus - V_plus) < 10)
            output = 10*output;
        end;
        
        if (z_slope < 0)
            output = 10*output;
        end
            
                                                                                                                      
    end;

    output = Comparator(V_minus, V_plus, z_slope, FixedParams);


end