function [B,A] = carney2015_getalphanorm(tau, fs, t)
%CARNEY2015_GETALPHANORM  Returns filter coefficients for a normalized alpha function
%
%   Returns z-transform coefficients for the function:
%
%       y(t) = t*e^(-t/tau);
%
%   The resulting coefficents can then be used in filter().  This version
%   normalizes the alpha function so that the area from 0 to t is equal
%   to 1.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/carney2015_getalphanorm.php

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

%   #Author: Mike Anzalone 3/2004

a = exp(-1/(fs*tau));
% norm = zeros(length(t));
norm = 1 ./(tau^2 .* (exp(-t/tau) .* (-t/tau-1) + 1));

B = [0 a];
A = [1 -2*a a^2] * fs * 1 ./norm;


