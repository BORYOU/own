function [H,siter] = nlssubprob_ASCG_proximal_simple(V,W,Hinit,tol,maxiter)

% H, grad: output solution and gradient
% iter: #iterations used
% V, W: constant matrices
% Hinit: initial solution
% tol: stopping tolerance
% maxiter: limit of iterations
%global  alpha beta eta rho eps0 n_1 n_2  r
alpha = 1; beta = 0.1;
eta = 0.1; rho = 0.5;
n_1 = 2; n_2 = 1;
eps0 = 1; r = 2;
tau = 1e-8;
% t=cputime;

[nr,nc] = size(Hinit);
H = Hinit;

%%%
WtV = W'*V;
WtW = W'*W;

% iterPG=0;
% iterCG=0;
% b=[];

AtA = WtW+tau*eye(nr);
% AtB = WtV+tau*Hinit;

grad = WtW*H -WtV+tau*(H-Hinit);
% initgrad = norm(grad,'fro');
projnorm  = norm(grad(grad < 0 | H >0));
siter = 0;
while  siter <  maxiter
    
    if projnorm <  tol
        break
    end
    %%% PG loop
    inner_iter_PG = 0;
    while projnorm >= tol & siter < maxiter
        
        inner_iter_PG = inner_iter_PG + 1;
        
        siter = siter+1;
        for inner_iter = 1:20,
            
            Hn = max(H - alpha*grad, 0); d = Hn-H;
            gradd = sum(sum(grad.*d)); dQd = sum(sum((AtA*d).*d));
            suff_decr = 0.99*gradd + 0.5*dQd < 0;
            if inner_iter==1,
                decr_alpha = ~suff_decr; Hp = H;
            end
            if decr_alpha,
                if suff_decr,
                    H = Hn; break;
                else
                    alpha = alpha * beta;
                end
            else
                if ~suff_decr | Hp == Hn,
                    H = Hp; break;
                else
                    alpha = alpha/beta; Hp = Hn;
                end
            end
        end
        
        grad = WtW*H -WtV + tau*(H-Hinit);
        projnorm = norm(grad(grad < 0 | H >0));
        
        IA = find(H > 0);
        Z = H(IA);
        g_red = grad(IA);
        ng_I = norm(g_red);
        
        if ng_I < eta*projnorm
            eta=rho*eta;
        else
            if inner_iter_PG >=  n_1
                break;
            end
        end
    end
    %%%
    %%% CG loop
    d_CG = -g_red;

    while projnorm >= tol & siter < maxiter

        siter = siter + 1;

        d_ex = zeros(nr,nc);
        
        %  for inner_iter = 1:5
        for inner_iter = 1:5
            Zn = max(Z + alpha*d_CG, 0); s0 = Zn-Z;
            gradd = g_red'*s0;
            % d_ex = zeros(nr,nc);
            d_ex(IA) = s0;
            y0_ex = AtA*d_ex;
            y0 = y0_ex(IA);
            dQd = y0'*s0;
            suff_decr = 0.9*gradd + 0.5*dQd < 0;
            if inner_iter == 1,
                decr_alpha = ~suff_decr; Zp = Z;
            end
            if decr_alpha,
                if suff_decr,
                    Z = Zn; break;
                else
                    alpha = alpha * 0.4;
                end
            else
                if ~suff_decr | Zp == Zn,
                    Z = Zp; break;
                else
                    alpha = alpha/0.4;
                    Zp = Zn;
                end
            end
        end
        H(IA) = Z;
        grad = WtW*H - WtV + tau*(H-Hinit);
        %%
        g_red = grad(IA);
        %%
        projnorm = norm(g_red(g_red < 0 | Z >0));
        
        ng_I = norm(g_red);
        
        if ng_I < eta * projnorm
            break
        else
            a1 = length(find(Z == 0));
            
            if a1 > n_2

               IA = find(H>0);
               g_red = grad(IA);
               d_CG = -g_red;
               Z = H(IA);
            else
                if a1 <= n_2 && a1 > 0 && ~ isempty( find( abs(g_red) >= projnorm^(1/2) & Z >= projnorm^(3/2) ,1))
                    break
                else
                    d0 = d_CG;
                    t1 = eps0 * ng_I^r ;
                    z0 = y0 + t1 * s0;
                    d0z0 = d0'*z0;
                    g1d0 = g_red'*d0;
                    if d0z0 < 1.0e-8
                    beta_1 = 0;
                    theta_1 = 0;
                    else
                    beta_1 = (g_red'*z0)/d0z0 - 2 * (z0'*z0 * g1d0)/(d0z0^2);
                    theta_1 = g1d0/d0z0;
                    end
                    d_CG = -g_red + beta_1 * d0 + theta_1 * z0;  
                end
            end
        end
    end
end

%%%
% H = D\H;
%%%
%iterPG;
%iterCG;
%projnorm;
%siter;
% siter1=iterPG+iterCG;

%fprintf('............')
% if siter==maxiter,
%     fprintf('Max iter in nlssubprob\n');
% end
% t=cputime-t;
