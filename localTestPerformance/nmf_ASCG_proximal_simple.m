function [H, W, fval] = nmf_ASCG_proximal_simple(V,Winit,Hinit,tol,maxiter)
% The new active set method where the UA is chosen to be the conjugate
%       gradient method(ASCG)
%
% W,H: output solution
% Winit,Hinit: initial solution
% k: Target low-rank
% tol: tolerance for a relative stopping condition
% timelimit, maxiter: limit of time and iterations
%
% References:
%  Chao Zhang, Liping Jing, Naihua Xiu. "A New Active Set Method for
%  Nonnegative Matrix Factorization", SIAM J. Optim., 11(2014), pp.
%  A2633-A2653.
%
% Written by Chao Zhang (chzhang2 AT bjtu.edu.cn)
% global alpha beta eta rho n_1 n_2 eps0 r tau

W = Winit; H = Hinit; 
N.V_fval=[]; 

V_fval=(norm(V-W*H,'fro'))^2;
N.V_fval(1) = V_fval;

gradW = W*(H*H') - V*H'; gradH = (W'*W)*H - W'*V;
initgrad = norm([gradW; gradH'],'fro');
tolW = max(0.0001,tol)*initgrad;
tolH = tolW;

for iter=1:maxiter,

 %     Stopping condition
     if iter>=30 
         if fvalcri < 1e-4 && fvalcri>0
             break
         end
     end

    % ===================== update W ========================
    [W,iterW] = nlssubprob_ASCG_proximal_simple(V',H',W',tolW,200);
    W = W'; 
    if iterW<=1,
        tolW = 0.1 * tolW;
    end
    
    % ===================== update H ========================
    [H,iterH] = nlssubprob_ASCG_proximal_simple(V,W,H,tolH,200);
    if iterH<=1, 
        tolH = 0.1 * tolH;
    end

    fval=(norm(V-W*H,'fro'))^2;
    N.V_fval=[N.V_fval;fval];
    fvalcri = abs(N.V_fval(iter)-N.V_fval(iter+1))/N.V_fval(iter);
    
    
end
