function definput=arg_relanoiborra2019(definput)
% ARG_RELANOIBORRA2019
%
%   #License: GPL
%   #Author: Piotr Majdak (2021): created for the AMT 1.0
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/defaults/arg_relanoiborra2019.php

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

%% General
definput.flags.disp = {'no_debug','debug'};
definput.keyvals.dboffset = dbspl(1); % dB Full scale convention of this model

%% AFB Parameters
definput.keyvals.flow=100;
definput.keyvals.fhigh=8000;
definput.flags.afb = {'erbspace', 'erbspacebw'};
  % used when erbspace is used to calculat fc's
definput.keyvals.fcnt = 60; % number of fc
  % used when erbspacebw is used to calculate fc's
definput.keyvals.bwmul = 0.5; % bandwidth of each fc 
definput.keyvals.basef = 8000; % one of the fc's will be exactly basef

definput.keyvals.subject='NH';
definput.keyvals.N_org = [];
definput.flags.internalnoise= {'internalnoise','no_internalnoise'};


%% IHC
definput.flags.ihc = {'ihc','no_ihc'}; 

%% Adaptation loops
definput.flags.an = {'an','no_an'};
definput.keyvals.limit=10; % arbitrary units
definput.keyvals.minspl=dbspl(2e-7,[],100); % approx. -34 dB, lowest audible SPL of the signal (in dB)
definput.keyvals.tau=[0.005 0.050 0.129 0.253 0.500];

%% Modulation filterbank


