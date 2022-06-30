function f = erbrate2f(erb)
%ERBRATE2F calculates the erb rate for a given frequency
%   Usage: f = erbrate2f(erb)
%
%   ERBRATE2F accepts an erb rate value as an input
%   and calculates its frequency in Hertz. It corresponds to
%   the inverse equation of Moore and Glasberg (1983) Eq. 3
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/common/erbrate2f.php

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

f = (0.312 - (exp((erb - 43)/11.17)) * 14.675) / (exp((erb - 43)/11.17) - 1);
f = f * 1000; %convert f to Hz not kHz

