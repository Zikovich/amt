function amt_stop
%AMT_STOP Removes all amt_related paths and clears persistent variables
%
%   AMT_STOP restores the paths to their state prior to runnnig amt_start and clears the
%   memory of all persistent variables within the amt core functions. This 
%   function facilitates working with different AMT versions.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/core/amt_stop.php

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

%   #Author: Clara Hollomey (2021-2022)

global userdefaultpath

if exist('arg_amt_configuration', 'file')

    [flags, kv] = amt_configuration;
    if isempty(flags)
        disp('No configuration available. AMT may already have been uninstalled.')
        return;
    else
        amt_configuration('amtrunning', 0);
    end
    
    %clear persistent variables from all core functions
    functions = dir([kv.path, filesep, 'core', filesep, 'amt_*']);

    for ii = 1:numel(functions)
      try
      munlock(functions(ii).name);
      catch
      end
      clear(char(functions(ii).name));
    end
    
    %restore the paths
    try
      path(userdefaultpath);
      clear('global', 'userdefaultpath');
    catch
    end

    
else
    disp('AMT not loaded - nothing to reset.')
end

