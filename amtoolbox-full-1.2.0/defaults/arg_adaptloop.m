function definput=arg_adaptloop(definput)
%ARG_ADAPTLOOP
%   #License: GPL
%   #Author: Peter Soendergaard (2011): Initial version
%   #Author: Alejandro Osses (2020): Extensions
%   #Author: Piotr Majdak (2021): Adapted to AMT 1.0
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/defaults/arg_adaptloop.php

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
 
  definput.flags.adt = {'adt','no_adt'};
  definput.keyvals.limit=10;
  definput.keyvals.minspl=0; % lowest audible SPL of the signal (in dB)
  definput.keyvals.tau=[0.005 0.050 0.129 0.253 0.500];
    
  definput.groups.adt_dau1996 = {'tau',[0.005 0.050 0.129 0.253 0.500],'limit',0};
  definput.groups.adt_dau1997 = {'tau',[0.005 0.050 0.129 0.253 0.500],'limit',10};
  definput.groups.adt_breebaart2001 = {'tau',linspace(0.005,0.5,5),'limit',0};
  definput.groups.adt_puschel1988 = {'tau',linspace(0.005,0.5,5),'limit',0};
  definput.groups.adt_osses2021 = {'tau',[0.005 0.050 0.129 0.253 0.500],'limit',5};
  definput.groups.adt_relanoiborra2019 = {'tau',[0.005 0.050 0.129 0.253 0.500],'limit',10,'minspl',dbspl(2e-7,[],100)};
