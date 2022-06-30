function data = data_goupell2010(varargin)
%DATA_GOUPELL2010 Localization performance in sagittal planes
%   Usage: data = data_goupell2010(condition)
%          data = data_goupell2010(lat, dlat, condition)
%
%   Output parameters:
%     data : structure
%
%   The condition flag may be one of:
%     'BB'   Broadband DTFs (baseline condition). This is the default.
%     'CL'   Click trains with unlimited number of channels
%     'N24'  24 vocoder channels
%     'N18'  18 vocoder channels
%     'N12'  12 vocoder channels
%     'N9'   9 vocoder channels
%     'N6'   6 vocoder channels
%     'N3'   3 vocoder channels
%
%
%   The 'data' struct contains the following fields:
%     '.id'    : listener ID
%     '.mtx'   : experimental data matrix conaining 9 colums
%
%
%   The columns contain:
%     'col1'  target azimuth
%     'col2'  target elevation
%     'col3'  response azimuth
%     'col4'  response elevation
%     'col5'  lateral angle of target
%     'col6'  polar angle of target
%     'col7'  lateral angle of response
%     'col8'  polar angle of response
%
%   Listener-specific experimental data from Goupell et al. (2010) testing
%   localization performance in sagittal planes for various numbers of
%   channels of a GET vocoder.
%
%   References:
%     M. J. Goupell, P. Majdak, and B. Laback. Median-plane sound
%     localization as a function of the number of spectral channels using a
%     channel vocoder. J. Acoust. Soc. Am., 127:990--1001, 2010.
%     
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/data/data_goupell2010.php

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

%   AUTHOR: Robert Baumgartner

%% Check input options

% Define input flags
definput.flags.condition = {'BB','CL','N24','N18','N12','N9','N6','N3'};

% Parse input options
[flags,kv]  = ltfatarghelper({},definput,varargin);

%% Extract data
x=amt_load('goupell2010','data.mat');

C = find(ismember(x.condition,flags.condition));

for ll = 1:length(x.subject)
  
  data(ll).mtx = x.subject(ll).expData{C}(:,1:8);
  data(ll).id = x.subject(ll).id;

end

