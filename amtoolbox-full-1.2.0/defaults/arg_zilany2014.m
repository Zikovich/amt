function definput = arg_zilany2014(definput)
% ARG_ZILANY2014
%
%   #License: GPL
%   #Author: Piotr Majdak (2021)
%% General
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/defaults/arg_zilany2014.php

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
definput.flags.species = {'human','cat'};
definput.keyvals.dboffset = dbspl(1);

%% Outer and middle ear

%% Auditory filterbank
definput.flags.BMtuning = {'shera2002','glasberg1990'}; % selects the BM tuning, either Shera et al. (2002) or Glasberg & Moore (1990)

%% IHC & OHC
definput.keyvals.cohc    = 1;
definput.keyvals.cihc    = 1;
definput.keyvals.nrep    = 1; % repeated calculations, 1: fast; 500: nice PSTH
definput.keyvals.reptime = 2; % repeat the stimulus in intervals of reptime*signallength

%% AN
definput.keyvals.fiberType = 2; % Simulate a neuron with the following SR: 1=Low; 2=Medium; 3=High; 4:Custom (see numH, numM and numL)
definput.flags.noiseType = {'fixedFGn','varFGn'};
definput.flags.powerLawImp = {'approxPL','actualPL'};
definput.keyvals.fsmod   = 100e3;

definput.keyvals.numH = 12; % # of high SR neurones, if fiberType=4
definput.keyvals.numM = 4; % # of high SR neurones, if fiberType=4
definput.keyvals.numL = 4; % # of high SR neurones, if fiberType=4

definput.keyvals.psth_binwidth = []; % width for PSTH calculations (in s). Set to [] for a raw PSTH (i.e., time resolution 1/fsmod)

