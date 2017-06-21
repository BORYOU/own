function [W,H] = GNMF_multi_revised(V,W,H,S,lambda,maxiter)
% Solving GNMF using multi 
% V: m*n 
% W: m*k
% H: k*n
% S: similar matrix
% lambda: parameter before gagularize term

[~,N] = size(V);
[~,K] = size(W);

S = lambda*S;
DCol = full(sum(S,2));
D = spdiags(DCol,0,N,N);
L = D - S;

fvalold=0.5*(norm(V-W*H,'fro'))^2 + 0.5*trace(H*sparse(L)*H');

for iter=1:maxiter,

    if iter >= 30
        if fvalcri < 1e-4 && fvalcri > 0
            break
        end
    end
    
  % ===================== update H' ========================
    VtW = V'*W; % mnk or pk (p<<mn)
    WtW = W'*W; % mk^2
    HtWtW = H'*WtW; % nk^2
    
    if lambda >0
        SHt = S * H';
        DHt = D*H';
        
        VtW = VtW + SHt;
        HtWtW = HtWtW + DHt;
    end
    
    Ht = H' .* (VtW./max(HtWtW,1e-10));
    H = Ht';
        
 % ===================== update W ========================
    VHt = V*H'; % mnk or pk (p<<mn) 
    HHt = H*H'; % nk^2
    WHHt = W*HHt; % mk^2
    
    W = W.* (VHt./max(WHHt,1e-10));  % 3mk
    
    fval=0.5*(norm(V-W*H,'fro'))^2 + 0.5*trace(H*sparse(L)*H');
    fvalcri = abs(fvalold-fval)/fvalold;
    fvalold = fval;
    
end

%norms = max(1e-15,sqrt(sum(W.^2,1)))';
%Wnorm = W*spdiags(norms.^-1,0,K,K);
%HnormT = H'*spdiags(norms,0,K,K);
%Hnorm = HnormT';

fprintf('iter: %d\n', iter);
