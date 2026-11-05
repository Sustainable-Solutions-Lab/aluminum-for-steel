function y = smooth5(x)
%SMOOTH5  5-point centered moving average with shrinking end spans.
%   Reproduces the default behavior of smooth(x) from the Curve Fitting
%   Toolbox (method 'moving', span 5): near the ends the span shrinks so
%   the window stays centered, e.g. y(1)=x(1), y(2)=mean(x(1:3)).
x = x(:);
n = numel(x);
y = zeros(n,1);
for i = 1:n
    k = min([2, i-1, n-i]);
    y(i) = mean(x(i-k:i+k));
end
end
