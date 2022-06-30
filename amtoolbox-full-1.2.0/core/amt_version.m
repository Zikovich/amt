function op1=amt_version(varargin)
%AMT_VERSION Help on the AMToolbox
%   Usage:  amt_version;
%           v=amt_version('version');
%
%   AMT_VERSION displays some general AMT banner.
%
%   AMT_VERSION('version') returns the version number.
%
%
%   See also:  amt_start
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/core/amt_version.php

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

%   #Author : Peter Søndergaard. 
%   #Author : Piotr Majdak (09.07.2017)  
%   #Author : Clara Hollomey (17.03.2021)

bp=amt_basepath;
[flags, kv] = amt_configuration;
definput.keyvals.versiondata=kv.version{1};
definput.keyvals.modulesdata=[];
definput.flags.mode={'general','version','modules','authors'};

[flags,kv]=ltfatarghelper({},definput,varargin);

if flags.do_general
  amt_disp(' ');
  amt_disp('--- AMT - The Auditory Modeling Toolbox. ---');
  amt_disp(' ')

  amt_disp(['-------------Version ',kv.versiondata,'-------------']);
  amt_disp(' ');


end;
  
if flags.do_version
  op1=kv.versiondata;
end;

if flags.do_modules
  amt_disp('This functionality has been deprecated.');
end;


