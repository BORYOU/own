function [H, W, N, H200, W200] = nmf_ASCG_proximal_simple(V,Winit,Hinit,tol,maxiter)
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
H200 = 0;
W200= 0;
W = Winit; H = Hinit; 
N.V_fval=[]; 
N.V_fval_W=[]; 
init = cputime;
N.time = [];
V_fval=(norm(V-W*H,'fro'))^2;
N.V_fval(1) = V_fval;

gradW = W*(H*H') - V*H'; gradH = (W'*W)*H - W'*V;
initgrad = norm([gradW; gradH'],'fro');
tolW = max(1e-8,tol)*initgrad;
tolH = tolW*1e-6;
tauW = 1e-7;
tauH = 1e-9;

for iter=1:maxiter,

 %     Stopping condition
     if iter>=30 
         if fvalcri < 1e-4 && fvalcri>0
             break
         end
     end

    % ===================== update W ========================
    [W,iterW] = nlssubprob_ASCG_proximal_simple(V',H',W',tolW,200,tauW);
    W = W'; 
    if iterW<=1,
        tolW = 0.1 * tolW;
    end
    fval=(norm(V-W*H,'fro'))^2;
    N.V_fval_W=[N.V_fval_W;fval];
    
    % ===================== update H ========================
<<<<<<< HEAD
    [H,iterH] = nlssubprob_ASCG_proximal_simple(V,W,H,tolH,200);
=======
    [H,iterH] = nlssubprob_ASCG_proximal_simple(V,W,H,tolH,200,tauH);
>>>>>>> 137ea5a4cc2ebfc848caea11626183746f612a00
    if iterH<=10, 
        tolH = 0.1 * tolH;
    end

    fval=(norm(V-W*H,'fro'))^2;
    N.V_fval=[N.V_fval;fval];
    fvalcri = abs(N.V_fval(iter)-N.V_fval(iter+1))/N.V_fval(iter);
    N.time = [N.time,cputime-init];
    fprintf('iter: %d, iterW: %d, iterH: %d\n',iter,iterW,iterH);
    if iter == 200
        H200 = H;
        W200 = W;
    end
end
