function map = rdylbu(n)
%RDYLBU  Red-Yellow-Blue diverging colormap (ColorBrewer RdYlBu, 11 classes).
%   MAP = RDYLBU(N) returns an N-by-3 colormap, linearly interpolated in RGB
%   between the 11 ColorBrewer anchor colors. Replaces the third-party
%   function brewermap(N,'RdYlBu') used in the original code. Colors may
%   differ very slightly from brewermap's interpolation; data are unaffected.
%   ColorBrewer colors: Cynthia Brewer, Mark Harrower, Pennsylvania State
%   University (Apache License 2.0).
if nargin < 1, n = size(get(gcf,'Colormap'),1); end
anchors = [165   0  38
           215  48  39
           244 109  67
           253 174  97
           254 224 144
           255 255 191
           224 243 248
           171 217 233
           116 173 209
            69 117 180
            49  54 149] / 255;
x  = linspace(0, 1, size(anchors,1));
xi = linspace(0, 1, n);
map = interp1(x, anchors, xi, 'linear');
end
