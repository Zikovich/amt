function definput = arg_hauth2020(definput)
% ARG_HAUTH2020
%
%   #License: GPL
%   #Author: Piotr Majdak (2021)
%% General
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/defaults/arg_hauth2020.php

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
definput.keyvals.long_term = 1; % use long-term model (1) or short-term model (0)
definput.flags.timescale = {'longterm', 'shortterm'};

%% Filterbank
definput.keyvals.Filterbank = 'GT';% define filtering: GT is gammatone filter
definput.keyvals.fmin = 150;
definput.keyvals.fmax = 8500; % highest filter of gammatone filterbank
definput.keyvals.f_target = 500; % specified frequeny that will have a matched filter
%definput.keyvals.bin_err = 1; % enable(1)/disable(0) binaural processing inaccuracies (important for Monte-Carlo Simulations)
definput.keyvals.ERB_factor = 1;% define bandwidth of filters
definput.keyvals.OptSigs = [];
definput.flags.bin_err = {'binauralinaccuracies', 'no_binauralinaccuracies'};

