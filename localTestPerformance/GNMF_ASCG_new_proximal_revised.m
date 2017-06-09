function [H, W, ASCG] = GNMF_ASCG_new_proximal_revised(V,Winit,Hinit,L,lambda,tol,maxiter)

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
W = Winit; H = Hinit;
initt = cputime;
ASCG.V_fval=[];
ASCG.T = [];
L = lambda * L;

gradW = W*(H*H') - V*H'; gradH = (W'*W)*H - W'*V  +  H * L;
initgrad = norm([gradW; gradH'],'fro');

tolW = max(0.0001,tol)*initgrad;
tolH = tolW;

ASCG.V_fval = 0.5*(norm(V-W*H,'fro'))^2 + 0.5*trace(H*sparse(L)*H');

for iter=1:maxiter,
    % stopping condition  
    if iter >= 30
        if fvalcri < 1e-4 && fvalcri > 0
            break
        end
    end
    
    [W,iterW] = nlssubprob_ASCG_proximal_simple(V',H',W',tolW,200); W = W'; %gradW = gradW';
    
    if iterW<=1,
        tolW = 0.1 * tolW;
    end
    
    [H,iterH] = nlssubprob_ASCG_proximal_simple_H(V,W,H,L,tolH,200);
    
    if iterH<=1,
        tolH = 0.1 * tolH;
    end
    
    fval=0.5*(norm(V-W*H,'fro'))^2 + 0.5*trace(H*sparse(L)*H');
    ASCG.V_fval=[ASCG.V_fval;fval];
    ASCG.T = [ASCG.T, cputime-init];
    fvalcri = abs(ASCG.V_fval(iter)-ASCG.V_fval(iter+1))/ASCG.V_fval(iter);
    
end



