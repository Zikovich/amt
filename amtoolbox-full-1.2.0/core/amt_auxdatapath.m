function auxPath=amt_auxdatapath(newPath)
%AMT_AUXDATAPATH Local path to the auxiliary data
%   Usage: auxpath=amt_auxdatapath
%          amt_auxdatapath(newpath)
%
%   auxPath=AMT_AUXDATAPATH returns the path of the directory containing
%   auxiliary data.
%
%   Default path to the auxiliary data is amt_basepath/auxdata.
% 
%   AMT_AUXDATAPATH(newpath) sets the path of the directory for further calls
%   of AMT_AUXDATAPATH.
%
%   See also: amt_auxdataurl amt_load amt_basepath
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/core/amt_auxdatapath.php

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

%   #Author: Piotr Majdak, 2015

mlock;
persistent CachedPath;
caller = dbstack;
last = numel(caller);

if exist('newPath','var')
  CachedPath=newPath;
elseif isempty(CachedPath)
  CachedPath=fullfile(amt_basepath, 'auxdata');
end
auxPath=CachedPath;

if ~strcmp('amt_configuration', caller(last).name)
  amt_configuration('auxdataPath', auxPath);
end
  

