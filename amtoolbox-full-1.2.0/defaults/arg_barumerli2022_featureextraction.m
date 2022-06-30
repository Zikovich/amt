function definput=arg_barumerli2022_featureextraction(definput)
    definput.flags.compute = {'all', 'template', 'target'};
    definput.flags.feature_monaural = {'pge', 'dtf', 'monaural_none', 'reijniers'};
    definput.flags.source = {'source_broadband', 'source'};
    
    % filterbank options
    definput.keyvals.fs = 48e3;
    definput.keyvals.flow = 700;
    definput.keyvals.fhigh = 18e3;
    
    definput.keyvals.space = 1; % filterbank spacing
    definput.keyvals.monoaural_bw = [0 Inf]*1e3;
    
    % target directions
    definput.keyvals.targ_az = [];
    definput.keyvals.targ_el = [];

    % sound source (time domain)
    % (default) broad band sound source at 0dB
    definput.keyvals.source_ir = [];
    definput.keyvals.source_fs = 0;

%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/defaults/arg_barumerli2022_featureextraction.php

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

