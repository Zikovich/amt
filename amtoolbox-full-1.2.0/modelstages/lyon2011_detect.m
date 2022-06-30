function conductance = lyon2011_detect(x_in)
%LYON2011_DETECT calculates conductance using a sigmoidal detection nonlinearity
%
%   Usage: conductance = lyon2011_detect(x_in)
%
%   Input parameters:
%     x_in : input signal
%
%   Output parameters:
%     conductance : conductance
%
%   An IHC-like sigmoidal detection nonlinearity for the CARFAC.
%   Resulting conductance is in about [0...1.3405]
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/lyon2011_detect.php

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

%   #Author: Amin Saremi (2016) adaptations for the AMT (based on <https://github.com/google/carfac>, Richard F. Lyon)
%   #Author: Clara Hollomey (2021) adaptation for the AMT 1.0
%   #License: gpl3



a = 0.175;   % offset of low-end tail into neg x territory
% this parameter is adjusted for the book, to make the 20% DC
% response threshold at 0.1

set = x_in > -a;
z = x_in(set) + a;

% zero is the final answer for many points:
conductance = zeros(size(x_in));
conductance(set) = z.^3 ./ (z.^3 + z.^2 + 0.1);


%% other things I tried:
%
% % zero is the final answer for many points:
% conductance = zeros(size(x_in));
%
% order = 4;  % 3 is a little cheaper; 4 has continuous second deriv.
%
% % thresholds and terms involving just a, b, s are scalar ops; x are vectors
%
% switch order
%   case 3
%     a = 0.15;  % offset of low-end tail into neg x territory
%     b = 1; % 0.44;   % width of poly segment
%     slope = 0.7;
%
%     threshold1 = -a;
%     threshold2 = b - a;
%
%     set2 = x_in > threshold2;
%     set1 = x_in > threshold1 & ~set2;
%
%     s = slope/(2*b - 3/2*b^2);  % factor to make slope at breakpoint
%     t = s * (b^2 - (b^3) / 2);
%
%     x = x_in(set1) - threshold1;
%     conductance(set1) = s * x .* (x - x .* x / 2);  % x.^2 - 0.5x.^3
%
%     x = x_in(set2) - threshold2;
%     conductance(set2) = t + slope * x ./ (1 + x);
%
%
%   case 4
%     a = 0.24;  % offset of low-end tail into neg x territory
%     b = 0.57;   % width of poly segment; 0.5 to end at zero curvature,
%     a = 0.18;  % offset of low-end tail into neg x territory
%     b = 0.57;   % width of poly segment; 0.5 to end at zero curvature,
%     % 0.57 to approx. match curvature of the upper segment.
%     threshold1 = -a;
%     threshold2 = b - a;
%
%
%     set2 = x_in > threshold2;
%     set1 = x_in > threshold1 & ~set2;
%
%     s = 1/(3*b^2 - 4*b^3);  % factor to make slope 1 at breakpoint
%     t = s * (b^3 - b^4);
%
%     x = x_in(set1) - threshold1;
%     conductance(set1) = s * x .* x .* (x - x .* x);  % x.^3 - x.^4
%
%     x = x_in(set2) - threshold2;
%     conductance(set2) = t + x ./ (1 + x);
%
% end
%

