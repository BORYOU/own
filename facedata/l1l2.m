function [L1, L2] = l1l2(m,n)

l1 = speye(n) - spdiags(ones(n,1), 1, n, n);
l1 = l1(1:n-1,:);
%      1 -1 ...
% l1 = . 1 -1 ...
%      . . .  . . .
%               1 -1
L1 = kron(speye(m), l1);
fprintf('l1: %d,%d\n',size(l1))
fprintf('L1: %d,%d\n',size(L1))

l2 = speye(m) - spdiags(ones(m,1), 1, m, m);
l2 = l2(1:m-1, :);
L2 = kron(l2, speye(n));  % D1 * D0
fprintf('l2: %d,%d\n',size(l2))
fprintf('L2: %d,%d\n',size(L2))

