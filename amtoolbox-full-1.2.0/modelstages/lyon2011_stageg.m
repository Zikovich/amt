function g = lyon2011_stageg(CAR_coeffs, relative_undamping)
% LYON2011_STAGEG obtain unity gain
%
%   Usage:
%     g = lyon2011_stageg(CAR_coeffs, relative_undamping)
%
%   Input parameters:
%     CAR_coeffs         : struct containing the CARFAC coefficients
%     relative_undamping : relative undamping
%
%   Output parameters:
%     g                  : gain
%
%   Returns the stage gain g needed to get unity gain at DC
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/lyon2011_stageg.php

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



r1 = CAR_coeffs.r1_coeffs;  % at max damping
a0 = CAR_coeffs.a0_coeffs;
c0 = CAR_coeffs.c0_coeffs;
h  = CAR_coeffs.h_coeffs;
zr = CAR_coeffs.zr_coeffs;
r  = r1 + zr .* relative_undamping;
g  = (1 - 2*r.*a0 + r.^2) ./ (1 - 2*r.*a0 + h.*r.*c0 + r.^2);

