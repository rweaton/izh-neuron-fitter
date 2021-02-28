function output = PlotVoltageNullClines(VoltageVec, FittedOutput, PulseAmplitude, I_thr, R_m)
    
    V_a     = FittedOutput(1,1);
    V_minus = FittedOutput(1,2);
    V_plus  = FittedOutput(1,3);
    z_slope = FittedOutput(1,4); 
   
%     ScaleFactor = 680/150;
%     PulseAmplitude = ScaleFactor*PulseAmplitude;
%     I_thr = ScaleFactor*I_thr;
    
    OnesVec = ones(size(VoltageVec));
    
    FVec1 = feval(@z1_Generator, VoltageVec, V_a, V_minus, V_plus);
    FVec2 = feval(@z1_Generator, VoltageVec, V_a, V_minus, V_plus) + (R_m*I_thr/V_a).*OnesVec;
    FVec3 = feval(@z1_Generator, VoltageVec, V_a, V_minus, V_plus) + (R_m*PulseAmplitude/V_a).*OnesVec;
    
    GVec = feval(@z2_Generator, VoltageVec, z_slope);
    
    output = [VoltageVec, FVec1, FVec2, GVec];
    
    figure(2);
    plot(VoltageVec, FVec1, 'k--');
    hold on;
    plot(VoltageVec, FVec2, 'b--');
    hold on;
    plot(VoltageVec, FVec3, 'r--');
    hold on;
    plot(VoltageVec, GVec, 'k--');
    xlim([-150, 50]);
    ylim([-100, 20]);
    
end