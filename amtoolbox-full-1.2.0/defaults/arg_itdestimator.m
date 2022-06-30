function definput=arg_itdestimator(definput)
  
definput.flags.disp = {'no_debug','debug'};
definput.flags.mode = {'Threshold','Cen_e2','MaxIACCr', 'MaxIACCe',...
    'CenIACCr', 'CenIACCe', 'CenIACC2e', 'PhminXcor','IRGD'};
definput.flags.lp = {'lp','bb'};
definput.flags.peak = {'hp','fp'};
definput.flags.toaguess = {'noguess','guesstoa'};

definput.keyvals.threshlvl = -10;
definput.keyvals.butterpoly = 10;
definput.keyvals.upper_cutfreq = 3000;
definput.keyvals.lower_cutfreq = 1000;
definput.keyvals.avgtoa = 45;
definput.keyvals.fs = [];
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/defaults/arg_itdestimator.php

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
definput.keyvals.fs = [];
