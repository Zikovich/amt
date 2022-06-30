function out = interpolation(xx, yy, x, method)
%INTERPOLATION performs cubic, pchip, or linear interpolation
%
%   Usage: out = interpolation(xx, yy, x, method);
%
%
%   INTERPOLATION finds the values of the
%   underlying function yy=F(xx) at x
%   via pchip, cubic, or linear interpolation
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/common/interpolation.php

% Copyright (C) 2009-2022 Piotr Majdak, Clara Hollomey, and the AMT team.
% This file is part of Auditory Modeling Toolbox (AMT) version 1.2.0
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

if nargin < 4
    method = 'pchip';
end

if (length(xx) > 1)
    switch method
        case 'cubic'
          out = interp1(xx, yy, x, method);    
        case 'pchip'
          out = interp1(xx, yy, x, method);
        case 'linear'
          xx = [-10^9 xx 10^9];
          yy = [yy(1) yy yy(end)]; 
          out = interp1(xx, yy, x, method);   
    end 
else
    out = yy * ones(size(x));
end

