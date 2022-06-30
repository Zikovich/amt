function definput = arg_glasberg2002(definput)

definput.keyvals.fs = 32000;
definput.keyvals.flow = 20;
definput.keyvals.fhigh = 16000;

% filter order as in glasberg2002
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/defaults/arg_glasberg2002.php

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
definput.keyvals.order = 4096;
definput.keyvals.fftLen = 2048; % according to glasberg2002
definput.keyvals.vLimitingIndices = [ 4050, 2540, 1250, 500, 80];%f-boundary vector
% compute windows
definput.keyvals.hannLenMs = [2,4,8,16,32,64]; % hanning window size (glasberg2002) in ms
definput.keyvals.timeStep = 0.001; % 1ms steps as in glasberg2002
definput.flags.compensationtype = {'tfOuterMiddle1997','tfOuterMiddle2007','specLoud'};
