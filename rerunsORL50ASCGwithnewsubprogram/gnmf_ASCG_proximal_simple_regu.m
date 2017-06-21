%function [W,H,V_c_H,V_c_W,V_iterW,V_iterH,V_iterW1,V_iterH1,V_tW,V_tH,V_fval,V_iterPG,V_iterCG] = nmf_ASCG_new_proximal_revised(V,Winit,Hinit,tol,timelimit,maxiter)

function [GdASCG] = gnmf_ASCG_proximal_simple_regu(V,Winit,Hinit,L,lambda,tol,timelimit,maxiter)

% W,H: output solution
% Winit,Hinit: initial solution
% tol: tolerance for a relative stopping condition
% timelimit, maxiter: limit of time and iterations
% L : L * gamma

%global alpha  beta eta rho n_1 n_2  eps0 r 
% alpha = 1; beta = 0.1;
% eta = 0.1; rho = 0.5;
% n_1 = 2; n_2 = 1;
% eps0 = 1; r = 2;
% tau = 1e-8;   % for proximal term
W = Winit; H = Hinit; initt = cputime;
T_execution=[];
V_fval=[];
GdASCG.Hhis = {};
L = lambda * L;

gradW = W*(H*H') - V*H'; gradH = (W'*W)*H - W'*V  +  H * L;
initgrad = norm([gradW; gradH'],'fro');

tolW = max(0.0001,tol)*initgrad;
tolH = tolW;


for iter=1:maxiter,
    % stopping condition  
    if cputime-initt > timelimit
        break;
    end
    
    [W,iterW] = nlssubprob_ASCG_proximal_simple(V',H',W',tolW,200); W = W'; %gradW = gradW';
    
    if iterW<=1,
        tolW = 0.1 * tolW;
    end
    
    [H,iterH] = nlssubprob_ASCG_proximal_simple_H(V,W,H,L,tolH,200);
    
    if iterH<=1,
        tolH = 0.1 * tolH;
    end
    
    execution = cputime - initt;
    fval=0.5*(norm(V-W*H,'fro'))^2 + 0.5*trace(H*L*H');
    T_execution=[T_execution;execution];
    V_fval=[V_fval;fval];
    
    GdASCG.Hhis{iter} = H;
    
end
GdASCG.V_fval=V_fval;
GdASCG.T_execution=T_execution;
GdASCG.H = H;


