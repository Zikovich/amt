function varargout=amt_load(model,data,variable)
%AMT_LOAD Load auxiliary data of a model
%   Usage: amt_load(MODEL, DATA);
%
%   AMT_LOAD(model, data) loads the auxiliary data from the file data. The data will loaded 
%   from the directory model located in the local auxdata directory given by
%   amt_auxdatapath. 
%
%   If the file is not in the local auxdata directory, it will be downloaded from
%   the web address given by amt_auxdataurl.
%
%   The following file types are supported:
%
%   - .wav   output will be as that from audioread
%   - .mat   output as that as from load
%   - others   output is the absolute filename
%
%   AMT_LOAD(model, data, variable) loads just a particular variable
%   from the file. 
%
%   See also: amt_auxdatapath amt_auxdataurl
%
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/core/amt_load.php

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
%   #Author: Clara Hollomey, 2021

[~,kv]=amt_configuration;

localfn=fullfile(kv.auxdataPath,model,data);
  % file not found? create directories, and download!
if ~exist(localfn,'file')
    % create dir if not existing
  if ~exist(fullfile(kv.auxdataPath,model),'dir') 
    [success,msg]=mkdir(fullfile(kv.auxdataPath,model));
    if success~=1
      error(msg);
    end
  end
    % download
  amt_disp(['Model: ' model '. Downloading auxiliary data: ' data]);
  webfn=[kv.auxdataURL '/' model '/' data];
  webfn(strfind(webfn,'\'))='/';

  webfn=regexprep(webfn,' ','%20');
  amt_disp('Searching in current AMT version...')
  if isoctave
    [~, stat]=urlwrite(webfn, localfn);
  else
    try
      outfilename = websave(localfn,webfn);
      stat = 1;
    catch
      stat = 0;
    end
  end

  if ~stat
      amt_disp('Searching in previous AMT versions...')
    for ii = 2:numel(kv.version)
      amt_disp(['Trying version ', kv.version{ii}])
      webfn = num2str([kv.downloadURL kv.version{ii} '/auxdata/' model '/' data]);
      if isoctave
        [~,stat]=urlwrite(webfn,localfn);
      else
        try
          outfilename = websave(localfn,webfn);
          stat = 1;
        catch
          stat = 0;
        end
      end  

      if stat
        amt_disp(['Found data in version: ' kv.version{ii}]);
        break;
      end
          
      if ii == numel(kv.version)
        error(['Unable to download file: ' webfn]);
      end
    end
  end

end
  % load the content
[~,~,ext] = fileparts(localfn);
switch lower(ext)
  case '.wav'
    [y,fs]=audioread(localfn);
    varargout{1}=y;
    varargout{2}=fs;
  case '.mat'
    if exist('variable','var')
        varargout{1}=load(localfn,variable);
    else
        varargout{1}=load(localfn);
    end
  otherwise
    varargout{1}=localfn;
end

