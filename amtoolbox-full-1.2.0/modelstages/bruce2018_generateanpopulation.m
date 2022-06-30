function [sponts,tabss,trels]=bruce2018_generateanpopulation(numcfs,numsponts)
%BRUCE2018_GENERATEANPOPULATION generates an AN population for a given number of nerve fibres and numsponts
%
%   Usage:
%     [sponts,tabss,trels]=bruce2018_generateanpopulation(numcfs,numsponts)
%
%   Input parameters:
%     numfcs    : number of frequencies
%     numsponts : number of low- mid- and highly-spontaneously firing nerve fibres
%                 [numlow nummid numhigh]
%
%   Output parameters:
%     sponts    : nerve fibres
%     tabs      : absolute timing info
%     trels     : relative timing info
%
%   BRUCE2018_GENERATEANPOPULATION generates an AN population for a 
%   given absolute number of nerve fibres and relative proportion of
%   low- mid- and highly-spontaneously firing nerve fibres
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/bruce2018_generateanpopulation.php

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

%   #Author: Ian Bruce
%CHANGES: removed saving of ANpopulation.mat (CH, 2021)

tabsmax = 1.5*461e-6;
tabsmin = 1.5*139e-6;
trelmax = 894e-6;
trelmin = 131e-6;

% generate sponts, tabss & trels for LS fibers (fiberType = 1)
sponts.LS = min(max(0.1+0.1*randn(numcfs,numsponts(1)),1e-3),0.2);
refrand = rand(numcfs,numsponts(1));
tabss.LS = (tabsmax - tabsmin)*refrand + tabsmin;
trels.LS = (trelmax - trelmin)*refrand + trelmin;

% generate sponts, tabss & trels for MS fibers (fiberType = 2)
sponts.MS = min(max(4+4*randn(numcfs,numsponts(2)),0.2),18);
refrand = rand(numcfs,numsponts(2));
tabss.MS = (tabsmax - tabsmin)*refrand + tabsmin;
trels.MS = (trelmax - trelmin)*refrand + trelmin;

% generate sponts, tabss & trels for HS fibers (fiberType = 3)
sponts.HS = min(max(70+30*randn(numcfs,numsponts(3)),18),180);
refrand = rand(numcfs,numsponts(3));
tabss.HS = (tabsmax - tabsmin)*refrand + tabsmin;
trels.HS = (trelmax - trelmin)*refrand + trelmin;

%if exist ('OCTAVE_VERSION', 'builtin') ~= 0
%    save('-mat','ANpopulation.mat','sponts','tabss','trels')
%else
%    save('ANpopulation.mat','sponts','tabss','trels')
%end


