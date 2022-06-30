function definput = arg_chen2011(definput)

definput.flags.outerearcorrection = {'FreeField', 'PDR10', 'Eardrum'};%OuterEarOpt
definput.keyvals.HLohcdB0 = 0;%no hearing impairment
definput.keyvals.HLihcdB0 = 0;
definput.keyvals.HLcf = 0;
%these values are for calculation of the reference cf...these are the CF of
%the auditory filters, not (necessarily) those in inputF
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/defaults/arg_chen2011.php

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
definput.keyvals.cambin = 0.25;
definput.keyvals.flow = 40;
definput.keyvals.fhigh = 17000;

