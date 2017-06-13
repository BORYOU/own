function [H, W, N, H200, W200] = nmf_ASCG_proximal_simple2(V,Winit,Hinit,tol,maxiter)
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
N.V_fval_H=[]; 
init = cputime;
N.time = [];
V_fval=(norm(V-W*H,'fro'))^2;
N.V_fval(1) = V_fval;

gradW = W*(H*H') - V*H'; gradH = (W'*W)*H - W'*V;
initgrad = norm([gradW; gradH'],'fro');
tolH = max(1e-8,tol)*initgrad;
tolW = tolH;
tauW = 1e-8;
tauH = 1e-8;

for iter=1:maxiter,
    
    [W, HT] = NormalizeUV(W, H', 0, 2);
    H = HT';
    
 %     Stopping condition
     if iter>=30 
         if fvalcri < 1e-4 && fvalcri>0
             break
         end
     end
    % ===================== update H ========================
    [H,iterH] = nlssubprob_ASCG_proximal_simple(V,W,H,tolH,200,tauH);
    if iterH<=10, 
        tolH = 0.1 * tolH;
    end
    fval=(norm(V-W*H,'fro'))^2;
    N.V_fval_H=[N.V_fval_H;fval];
    
    [W, HT] = NormalizeUV(W, H', 0, 2);
    H = HT';
    % ===================== update W ========================
    [W,iterW] = nlssubprob_ASCG_proximal_simple(V',H',W',tolW,200,tauW);
    W = W'; 
    if iterW<=1,
        tolW = 0.1 * tolW;
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

function [U, V] = NormalizeUV(U, V, NormV, Norm)
    % X = UV' default using: NormV = 0; Norm = 2;
    K = size(U,2);
    if Norm == 2
        if NormV
            norms = max(1e-15,sqrt(sum(V.^2,1)))';
            V = V*spdiags(norms.^-1,0,K,K);
            U = U*spdiags(norms,0,K,K);
        else
            norms = max(1e-15,sqrt(sum(U.^2,1)))';
            U = U*spdiags(norms.^-1,0,K,K);
            V = V*spdiags(norms,0,K,K);
        end
    else
        if NormV
            norms = max(1e-15,sum(abs(V),1))';
            V = V*spdiags(norms.^-1,0,K,K);
            U = U*spdiags(norms,0,K,K);
        else
            norms = max(1e-15,sum(abs(U),1))';
            U = U*spdiags(norms.^-1,0,K,K);
            V = V*spdiags(norms,0,K,K);
        end
    end