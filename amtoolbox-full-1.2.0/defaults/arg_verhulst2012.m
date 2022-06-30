function definput=arg_verhulst2012(definput)
% ARG_VERHULST2012
%
%   #License: GPL
%   #Author: Piotr Majdak (2021)
%% General
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/defaults/arg_verhulst2012.php

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
definput.flags.disp = {'no_debug','debug'};

definput.keyvals.normalize = []; % leave empty for no normalization, or provide a binary vector enabling normalization at each channel. 
definput.keyvals.subject = 1; % standard subject controls the cochlear irregulatiries.
definput.keyvals.irr = []; % leave empty for irregularities in all channels or provide a binary vector enabling irregularities at each channel.



