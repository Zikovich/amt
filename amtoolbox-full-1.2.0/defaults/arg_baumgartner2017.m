function definput = arg_baumgartner2017(definput)

definput.keyvals.tempWin = 1;%0.02; % temporal integration window in sec
definput.keyvals.reflectionOnsetTime = [];
definput.flags.normalize = {'regular','normalize'};
definput.flags.cueProcessing = {'misc','intraaural','interaural'};
definput.flags.lateralInconsistency = {'noLateralInconsistency','lateralInconsistency'};
definput.flags.middleEarFilter = {'','middleEarFilter'};
definput.flags.spectralCueEchoSuppression = {'','spectralCueEchoSuppression'};
definput.keyvals.ILD_JND = 1; % ILD JND from reference
definput.keyvals.ITD_JND = 20e-6; % ITD JND from reference
definput.keyvals.range = 1; % scaling of externalization score
definput.keyvals.offset = 0; % offset of externalization score
definput.keyvals.cueWeights = [1,0,0,0,0];
definput.flags.decisionStatistics = {'','dprime'};
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/defaults/arg_baumgartner2017.php

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
definput.flags.decisionStatistics = {'','dprime'};
