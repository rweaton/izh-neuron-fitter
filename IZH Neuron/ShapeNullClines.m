function output = ShapeNullClines(x0)
    
    V_a     = x0(1,1);
    V_minus = x0(1,2);
    V_plus  = x0(1,3);
    z_slope = x0(1,4);
    
    FixedParams         = evalin('base','FixedParams');

    
    function output = Comparator(V_a, V_minus, V_plus, z_slope, FixedParams)

        V_rest  = FixedParams(1,1);
        I_thr   = FixedParams(1,2);
        V_sub   = FixedParams(1,3);
        I_sub   = FixedParams(1,4);
    
        R_m = (V_sub - V_rest)/I_sub;
    
        z1_rest = feval(@z1_Generator, V_rest, V_a, V_minus, V_plus); 
        z2_rest = feval(@z2_Generator, V_rest, z_slope);
    
        z1_min  = feval(@z1_Generator, (V_plus + V_minus)/2, V_a, V_minus, V_plus); 
        z2_min  = feval(@z2_Generator, (V_plus + V_minus)/2, z_slope);
    
        z1_sub  = feval(@z1_Generator, V_sub, V_a, V_minus, V_plus);
        z2_sub  = feval(@z2_Generator, z_slope);
    
        % Minimum Constraint
        %output = (z2_rest - z1_rest).^2 + (z2_min - (z1_min + R_m*I_thr/V_a)).^2;
    
        % Threshold Voltage Constraint
        %output = (z2_rest - z1_rest).^2 + (z2_min - (z1_min + R_m*I_thr/V_a)).^2 + (R_m*I_thr + V_rest - (V_plus + V_minus)/2).^2;
    
        % Sub-Threshold Contraint only
        %output = (z2_rest - z1_rest).^2 + (z2_min - (z1_min + R_m*I_thr/V_a)).^2 + (z2_sub - (z1_sub + (R_m*I_sub/V_a))).^2;
    
        % Sub-Threshold + Threshold Voltage Constraint
        output = (z2_rest - z1_rest).^2 + 5*(z2_min - (z1_min + R_m*I_thr/V_a)).^2 + 0.001*(R_m*I_thr + V_rest - (V_plus + V_minus)/2).^2 + (z2_sub - (z1_sub + (R_m*I_sub/V_a))).^2;
    
        % Optimization Contraints on values to be fitted
        if V_minus >= V_plus
            output = 10*output;
        end;
    
        if V_a >= 500
            output = 10*output;
        end;
        
        if z_slope < 0
            output = 10*output;
        end
    
    end;

    output = Comparator(V_a, V_minus, V_plus, FixedParams, z_slope);


end