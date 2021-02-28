function derivs = IZHModel(state, t, tau, params, FnHandleList)

% state and t are required to be the same size.
% no explicit dependence on t and tau in this model.
% v and z are each column vectors in the state matrix.

    % untangle state variables
    v = state(:,1);
    z = state(:,2);
    
    % untangle function handles
    %[vDerivHandle, zDerivHandle] = FnHandleList;
    
    % untangle parameters
    %[tau_rec tau_m V_a V_plus V_minus z_slope R_m ExtI] = params;
    
    derivs(:,1) = feval(FnHandleList{1,1}, v, z, params);
    derivs(:,2) = feval(FnHandleList{1,2}, v, z, params);

return