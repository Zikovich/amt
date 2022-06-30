function rate = f2erbrate(f)
%F2ERBRATE calculates the frequency for a given erb rate
%   Usage: rate = f2erbrate(f)
%
%   erbrate2f accepts a frequency value in Hertz as an input
%   and calculates its erb rate. It corresponds to
%   the equation of Moore and Glasberg (1983) Eq. 3, with the
%   frequency being accepted in Hertz (not kHz).
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/common/f2erbrate.php

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

%   #Author: John Culling
f = f / 1000;
rate = 11.17 * log((f+0.312)/(f+14.675)) + 43;

