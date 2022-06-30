 function varargout = amt_info(varargin)
%AMT_INFO Displays the license, technical requirements, authors, and status of a file
%   Usage: amt_info('modelname')
%          amt_info('once')
%
%   Input parameters:
%      modelname    :  search pattern (typically the name of the first author) associated to a model. 
%      once         :  can only be called from within a model or modelstage. Displays the license, technical requirements, and
%                      authors of that model once, the first time a model is run within an AMT session.
%
%   Examples:
%
%   List the paths to all models and modelstages in the AMT associated to publications with first author Takanen:
%
%     amt_info('takanen');
%
%   List the license, technical requirements, and authors of the model culling2004:
%
%     amt_info('culling2004');
%
%   If not specified, the license will always be GPLv3.
%
%   See also: amt_start amt_configuration amt_stop
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/core/amt_info.php

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

%   #Author: Clara Hollomey
mlock;
  persistent displayed;
  [fl, kv] = amt_configuration;
 
  if nargin==0, % if no arguments, print the amt_configuration
    disp('FLAGS:');
    disp(fl);
    disp('KEY-VALUE PAIRS:');
    disp(kv);
    return;
  end
  
  if nargin ~= 1
    error('amt_info requires a single string as an input.');
  end
  
  varargin = char(varargin);
  modelname = [];
  if strcmp(lower(varargin), 'once')
    if isempty(displayed)
    stack = dbstack;
    S = fileread(stack(2).file);
    fileList.name = stack(2).file;
    displayed = 1;
    f=dbstack('-completenames');
    fn=f(2).file;
    modelname = fn;
    
    else
        return;
    end
  else
    %search for the file and read it in
    if ~strcmp(char(varargin(end-1:end)), '.m')
      instring =[char(varargin),'.m'];
    else
      instring = char(varargin);
    end
    
    fileList = amt_subdir(fullfile(amt_basepath, 'models', instring));
    
    if numel(fileList) > 1
      amt_disp('More than one file found:');
      for jj=1:numel(fileList)
          amt_disp(fileList(jj).name);
      end
      amt_disp('Please narrow down your search.');
      return;
    elseif isempty(fileList)
      amt_disp('No file found. Please check your search terms.');
      return;
    else
      S = fileread(fileList.name);
    end
    
  end
%read the information associated to the anchors
  S = regexp(S, '\n', 'split');
    
  k = strfind(S, '%   #License: ');
  l = strfind(S, '%   #Requirements: ');
  m = strfind(S, '%   #Author: ');
  w = strfind(S, '%   #StatusDoc: ');
  x = strfind(S, '%   #StatusCode: ');
  y = strfind(S, '%   #Verification: ');
  
  licenseline=find(cellfun(@(c) ~isempty(c), k));
  requirementsline=find(cellfun(@(c) ~isempty(c), l));
  authorline=find(cellfun(@(c) ~isempty(c), m));
  docline = find(cellfun(@(c) ~isempty(c), w));
  codeline = find(cellfun(@(c) ~isempty(c), x));
  verificationline = find(cellfun(@(c) ~isempty(c), y));
   
  license = char(S{licenseline});
  requirements = char(S{requirementsline});
  requirements = lower(requirements(length('%   #Requirements: ')+1:end-1));
  docstatus = char(S{docline});
  codestatus = char(S{codeline});
  verificationstatus = char(S{verificationline});

 %display that information 
  if isempty(requirements), requirements = ' No specific information provided'; end
  authors = [];
  for ii = 1:numel(authorline)
        authorTmp = char(S{authorline(ii)});
        authors = [authors '* ' authorTmp(numel('%   #Author: ')+1:end)];
  end
  if isempty(authors), authors = 'No specific information provided'; end
  
  % Prepare the license text
  if ~isempty(licenseline)
       licenseType = license(length('%   #License: ')+1:end);
       licenseType = licenseType(~isspace(licenseType));
  else %GPL3
       licenseType = 'gpl3';
  end
  LicenseText = fullfile(kv.path, 'licenses', [licenseType '_boilerplate.txt']);
  
  %status information
  if isempty(docstatus), 
    docstatus = '?'; 
  else
    docstatus=docstatus(length('%   #StatusDoc: ')+1:end);
    docstatus=docstatus(~isspace(docstatus));
  end
  if isempty(codestatus), 
    codestatus = '?';
  else
    codestatus=codestatus(length('%   #StatusCode: ')+1:end);
    codestatus=codestatus(~isspace(codestatus));
  end
  if isempty(verificationstatus), 
    verificationstatus = '?'; 
  else
    verificationstatus=verificationstatus(length('%   #Verification: ')+1:end);
    verificationstatus=verificationstatus(~isspace(verificationstatus));
  end
  
  [~,modelname,~]=fileparts(fileList.name);
  if strcmpi(varargin, 'once')
    amt_disp(' ');
    amt_disp('********');
    amt_disp(['WARNING: ' upper(modelname) ' is licensed under a different license than the AMT!']);
    amt_disp('********');
  else
    amt_disp(['Model: ' upper(modelname)]);
  end  

  T = fileread(LicenseText);
  amt_disp(['License: ' upper(licenseType)]);
  amt_disp(strrep(T, char([13 10]), char(10)));
  if ~strcmpi(varargin, 'once')
    amt_disp(' ');
    amt_disp([('Requirements: ') upper(requirements)]);
  end
  amt_disp(' ');
  if numel(authorline)>1
    amt_disp('Authors: ');
    amt_disp(authors);
  else
    amt_disp([('Author: ') authors]);
  end
  if ~strcmpi(varargin, 'once')
    amt_disp(['Status: Documentation: ' docstatus '.  ' ...
             'Code: ' codestatus '.  ' ...
             'Verification: ' verificationstatus '.']);
  end

