function output = z1_Generator(V, V_a, V_minus, V_plus)

    OnesVec = ones(size(V));
    output = (1/V_a)*(1/(V_plus - V_minus))*(V - V_plus*OnesVec).*(V - V_minus*OnesVec);
    
return;