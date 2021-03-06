function data = data_majdak2010(varargin)
%DATA_MAJDAK2010 Listener specific localization performance
%   Usage: data = data_majdak2010(condition)
%
%   DATA_MAJDAK2010(condition) returns listener-specific experimental data
%   from Majdak et al. (2010) testing localization performance for various
%   experimental methods.
%
%   The data struct comprises the following fields:
%
%     'id'    listener ID
%
%     'mtx'   experimental data matrix containing 9 columns
%
%             - target azimuth
%             - target elevation
%             - response azimuth
%             - response elevation
%             - lateral angle of target
%             - polar angle of target
%             - lateral angle of response
%             - polar angle of response
%
% 
%   The condition flag may be one of:
%
%     'HMD_M'   Head-mounted display and manual pointing. Testing of naive
%               subjects.
%     'HMD_H'   Head-mounted display, head pointing, naive subjects.
%     'Dark_M'  Dark room, manual pointing, naive subjects.
%     'Dark_H'  Dark room, head pointing, naive subjects.
%     'Learn_M' Acoustic learning condition with manual pointing. This is the default.
%     'Learn_H' Acoustic learning condition with head pointing.
%
%   References:
%     P. Majdak, M. J. Goupell, and B. Laback. 3-D localization of virtual
%     sound sources: Effects of visual environment, pointing method and
%     training. Atten Percept Psycho, 72:454--469, 2010.
%     
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/data/data_majdak2010.php

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

% AUTHOR: Robert Baumgartner

%% Check input options

% Define input flags
definput.flags.condition = {'Learn_M','Learn_H','HMD_M','HMD_H','Dark_M','Dark_H'};

% Parse input options
[flags,kv]  = ltfatarghelper({},definput,varargin);


%% Extract data
x=amt_load('majdak2010','data.mat');

C = find(ismember(x.condition,flags.condition));

for ll = 1:length(x.subject)
  
  if not(isempty(x.subject(ll).expData{C}))
    data(ll).mtx = real(x.subject(ll).expData{C}(:,1:8));
  end
  data(ll).id = x.subject(ll).id;

end

