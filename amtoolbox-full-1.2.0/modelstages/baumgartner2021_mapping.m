function E = baumgartner2021_mapping(d,S_cue,Erange,Eoffset,varargin)
%BAUMGARTNER2021_MAPPING externalization mapping function of baumgartner2021 model
%   Usage:    E = baumgartner2021_mapping(d,S_cue,Erange,Eoffset)
%
%   Input parameters:
%     d:        deviation metric
%
%     S_cue:    cue-specific sensitivity parameter (inverse slope) 
%
%     Erange:   range of rating scale
%
%     Eoffset:  scale offset
%
%   Output parameters:
%     E:        externalization score within rating scale
%
%   Description: 
%   ------------
%
%   BAUMGARTNER2021_MAPPING(...) represents a sigmoidal mapping function 
%   scaled by?Erange, shifted by?Eoffset, and slope-controlled by S_cue 
%   used to map deviation metrics?to externalization ratings within the
%   baumgartner2021 model.
%
%   BAUMGARTNER2021_MAPPING accepts the following flags:
%
%     'single'       Single-sided externalization ratings with respect to 
%                    reference sound. This is the default.
%
%     'two'          Two-sided externalization ratings.
%
%   See also: baumgartner2021 
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/baumgartner2021_mapping.php

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

% AUTHOR : Robert Baumgartner

definput.flags.sided={'single','two'};
[flags,kv]=ltfatarghelper({},definput,varargin);

if flags.do_single % sided
  Erange = Erange*2;
end

E = Erange./(1+exp(d./S_cue))+Eoffset;

