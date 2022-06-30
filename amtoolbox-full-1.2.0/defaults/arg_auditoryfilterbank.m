function definput=arg_auditoryfilterbank(definput)
% ARG_AUDITORYFILTERBANK
%
%   #License: GPL
%   #Author: Peter Soendergaard (2011): Initial version
%   #Author: Alejandro Osses (2020): Extensions
%   #Author: Piotr Majdak (2021): Adapted to AMT 1.0
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/defaults/arg_auditoryfilterbank.php

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
definput.keyvals.dboffset = dbspl(1); % dB Full scale convention
definput.flags.outerear = {'no_outerear','outerear'};
definput.flags.middleear= {'no_middleear','middleear','jepsen2008'};
definput.flags.singlefc = {'default', 'lavandier2022'};

%% Auditory filterbank
definput.keyvals.flow=80;
definput.keyvals.fhigh=8000;
definput.keyvals.basef=[];
definput.keyvals.bwmul=1;

definput.keyvals.fs_up  = [];
definput.flags.internalnoise= {'no_internalnoise', 'internalnoise'};

%% Groups
definput.groups.afb_dau1997 = {'dboffset',100,'basef',1000};

% relanoiborra2019: basef=8000 Hz, to match this frequency
%                   bwmul=0.5 because their filter design uses 60 bands
%                      spaced at 0.5 ERBN between 100 and 8000 Hz
definput.groups.drnl_relanoiborra2019 = {'outerear','middleear','basef',8000, ...
    'hearing_profile','NH','internalnoise','bwmul',0.5};

definput.groups.afb_osses2021 = {'outerear','middleear','basef',[]}; 

