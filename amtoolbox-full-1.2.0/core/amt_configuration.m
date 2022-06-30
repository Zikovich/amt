function [flags,kv]=amt_configuration(varargin)
%AMT_CONFIGURATION Get and set the configuration of the current AMT session
%
%   Usage: 
%     [flags, kv] = amt_configuration;
%     [flags, kv] = amt_configuration('cacheURL', cU);
%     [flags, kv] = amt_configuration('silent');
%     [flags, kv] = amt_configuration('silent', 'normal');
%
%   AMT_CONFIGURATION accepts the following optional parameters:
%
%     'cacheURL',cU        Set the download URL of the cache
%
%     'auxdatapath',aP     Set the path where the auxdata is stored
%
%     'auxdataURL',aU      Set the download URL for the auxdata
%
%
%   AMT_CONFIGURATION accepts the following flags:
%
%     'cacheMode'     sets the global cache mode, supported options
%
%                     - global
%                     - normal
%                     - cached
%                     - redo
%
%     'disp'          sets the global display mode, supported options
%
%                     - verbose
%                     - documentation
%                     - silent
%
%   AMT_CONFIGURATION can be used to retrieve and set the above
%   parameters. Any parameter set in the functions amt_auxdatapath, 
%   amt_auxdataurl, and amt_cache will also be set in amt_configuration and 
%   vice-versa.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/core/amt_configuration.php

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

%   #Author : Clara Hollomey
mlock;
persistent AMT_CONFIG;
caller = dbstack;
last = 2;
%make sure that amt_configuration can also be called from the command line
if numel(caller) < 2
    caller(last).file = [];
    caller(last).name = [];
    caller(last).line = [];
end

%if AMT_CONFIG is empty, it needs to be initialized. This needs to be done
%by amt_start.
if isempty(AMT_CONFIG) && ~isempty(varargin)
    if strcmp('amt_start', caller(last).name) && isfield(varargin{1,1}, 'keyvals') && isfield(varargin{1,1}, 'flags')
      definput.keyvals = varargin{1,1}.keyvals;     
      definput.flags = varargin{1,1}.flags; 
      [flags,kv]=ltfatarghelper({},definput,{} );
      AMT_CONFIG.flags=flags;
      AMT_CONFIG.kv=kv;
      disp('AMT configuration has been initialized.');
    else
      disp('AMT configuration needs to be initialized by calling amt_start.');
    end
end

%if AMT_CONFIG is not empty and there is some input, the user or another
%function wants to set some parameters. those parameters are either
% a) a key/value pair, or
% b) a flag (cachemode and display)
if ~isempty(AMT_CONFIG) && ~isempty(varargin)
   if ischar(varargin{1})
       switch varargin{1}
        case 'cacheURL'
          AMT_CONFIG.kv.cacheURL = varargin{2};      
          if ~strcmp('amt_cache', caller(last).name)
            amt_cache('setURL',varargin{2});
          end
        case 'auxdataURL' 
          AMT_CONFIG.kv.auxdataURL = varargin{2};
          if ~strcmp('amt_auxdataurl', caller(last).name)
            AMT_CONFIG.kv.auxdataURL = amt_auxdataurl(varargin{2});
          end
        case 'auxdataPath'
          AMT_CONFIG.kv.auxdataPath = varargin{2};
          if ~strcmp('amt_auxdatapath', caller(last).name)
            AMT_CONFIG.kv.auxdataPath = amt_auxdatapath(varargin{2});
          end
        otherwise

          for ii = 1:numel(varargin)
          if strcmp(varargin{ii}, 'silent') || strcmp(varargin{ii}, 'verbose') || strcmp(varargin{ii}, 'documentation')
             definput.import={'amt_disp'};
             [flags,~]=ltfatarghelper({},definput,varargin(ii));
             AMT_CONFIG.flags.disp=flags.disp;
             AMT_CONFIG.flags.do_verbose=flags.do_verbose;
             AMT_CONFIG.flags.do_documentation=flags.do_documentation;
             AMT_CONFIG.flags.do_silent=flags.do_silent;
          end
          if strcmp(varargin{ii}, 'global') || strcmp(varargin{ii}, 'normal') || strcmp(varargin{ii}, 'redo') || strcmp(varargin{ii}, 'localonly') || strcmp(varargin{ii}, 'cached')
              definput.import={'amt_cache'};
             [flags,~]=ltfatarghelper({},definput,varargin(ii));
             AMT_CONFIG.flags.cachemode=flags.cachemode;
             AMT_CONFIG.flags.do_global=flags.do_global;
             AMT_CONFIG.flags.do_normal=flags.do_normal;
             AMT_CONFIG.flags.do_cached=flags.do_cached;
             AMT_CONFIG.flags.do_localonly=flags.do_localonly;
             AMT_CONFIG.flags.do_redo=flags.do_redo;
             if ~strcmp('amt_cache', caller(last).name)
               amt_cache('setMode',flags.cachemode);
             end
          end
          end   

       end
   end
end  
if isfield(AMT_CONFIG, 'flags')
  flags=AMT_CONFIG.flags;
  kv=AMT_CONFIG.kv;
else
  disp('No configuration stored. Please re-initialize using amt_start.');
  flags = [];
  kv = [];
end




