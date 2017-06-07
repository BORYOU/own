function [W,H,N] = nmf(V,Y,Winit,Hinit,tol,timelimit,maxiter)
% NMF by alternative non-negative least squares using projected gradients
% Author: Chih-Jen Lin, National Taiwan University
% W,H: output solution
% Winit,Hinit: initial solution
% tol: tolerance for a relative stopping condition
% timelimit, maxiter: limit of time and iterations
N.V_fval=[]; N.T_execution=[]; N.iterW=[];
N.iterH=[]; N.projnormW = []; N.projnormH = [];
W = Winit; H = Hinit; initt = cputime;
gradW = W*(H*H') - V*H'; gradH = (W'*W)*H - W'*V;
initgrad = norm([gradW; gradH'],'fro');
fprintf('Init gradient norm %f\n', initgrad);
tolW = max(0.001,tol)*initgrad; tolH = tolW;
normV = sum(sum(V.^2));
fval=0.5*(norm(V-W*H,'fro'))^2;
N.V_fval(1)=fval;
for iter=1:maxiter,
    % stopping condition
     projnorm = norm([gradW(gradW<0 | W>0); gradH(gradH<0 | H>0)]);
    if cputime-initt > timelimit || projnorm < tol,
        break;
    end

WtW = W'*W; HHt = H*H'; WtV = W'*V; VHt=V*H';

%     N.fval(iter) = 0.5*normV+0.5*sum(sum(WtW.*HHt))-sum(sum(WtV.*H));
%     if iter>=2,
%          stopcr = abs(N.fval(iter) - N.fval(iter-1))/N.fval(iter-1);
%           fprintf('iter = %d  stopcr = %f  fval = %f\n',iter,stopcr,N.fval(iter));
%          if stopcr<2e-4 && stopcr>0,
%              break
%          end
%      end
    [W,gradW,iterW,projnormW] = nlssubprob(V',H',W',tolW,1000,initt,timelimit); W = W'; gradW = gradW';
    if iterW==1,
        tolW = 0.1 * tolW;
    end
    [H,gradH,iterH,projnormH] = nlssubprob(V,W,H,tolH,1000,initt,timelimit);
    if iterH==1,
        tolH = 0.1 * tolH;
    end
    NS = Accuracy(5,V,Y,H,' -s 5'); % 3����

    %His
    N.acc(iter)=NS.acc;
    N.max(iter)=NS.max;
    N.min(iter)=NS.min;
    N.var(iter)=NS.var;
    N.iterH=[N.iterH,iterH];
    N.projnormH = [N.projnormH,projnormH];
    N.iterW=[N.iterW,iterW];
    N.projnormW = [N.projnormW,projnormW];
    execution = cputime -initt;
    fval=0.5*(norm(V-W*H,'fro'))^2;
    N.V_fval=[N.V_fval;fval];
    
    fvalcri = abs(N.V_fval(iter)-N.V_fval(iter+1))/N.V_fval(iter);
    N.fvalcri(iter) = fvalcri;
    
    N.T_execution=[N.T_execution;execution];
    
%     if rem(iter,10)==0, fprintf('.'); end
end
% fprintf('\nIter = %d Final proj-grad norm %f\n', iter, projnorm);