function varargout = amt_subdir(varargin)
%AMT_SUBDIR Performs a recursive file search
%
%   Usage:
%     amt_subdir
%     amt_subdir(name)
%     files = amt_subdir(...)
%
%   Input parameters:
%     name:   pathname or filename for search, can be absolute or relative
%             and wildcards (*) are allowed.  If ommitted, the files in the
%             current working directory and its child folders are returned    
%
%   Output parameters:
%     files:  m x 1 structure with the following fields:
%
%             .name    full filename
%
%             .date    modification date timestamp
%
%             .bytes   number of bytes allocated to the file
%
%             .isdir   1 if name is a directory; 0 if no
%
%   This function performs a recursive file search.  The input and output
%   format is identical to the dir function.
%
%   Example:
%     a = subdir(fullfile(matlabroot, 'toolbox', 'matlab', '.mat'))
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/core/amt_subdir.php

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

%   Copyright 2006 Kelly Kearney
%   Kelly Kearney (2021). subdir: a recursive file search https://github.com/kakearney/subdir-pkg
% 
%   #License: mit
%   #Author: Kelly Kearney
%   #Author: Clara Hollomey (for AMT)


%---------------------------
% Get folder and filter
%---------------------------
narginchk(0,1);
nargoutchk(0,1);
if nargin == 0
    folder = pwd;
    filter = '*';
else
    [folder, name, ext] = fileparts(varargin{1});
    if isempty(folder)
        folder = pwd;
    end
    if isempty(ext)
        if isdir(fullfile(folder, name))
            folder = fullfile(folder, name);
            filter = '*';
        else
            filter = [name ext];
        end
    else
        filter = [name ext];
    end
    if ~isdir(folder)
        error('Folder (%s) not found', folder);
    end
end
%---------------------------
% Search all folders
%---------------------------
pathstr = genpath_local(folder);
pathfolders = regexp(pathstr, pathsep, 'split');  % Same as strsplit without the error checking
pathfolders = pathfolders(~cellfun('isempty', pathfolders));  % Remove any empty cells
Files = [];
%pathandfilt = fullfile(pathfolders, filter);
%for ifolder = 1:length(pathandfilt)
for ifolder = 1:length(pathfolders)
  pathandfilt = fullfile(char(pathfolders(ifolder)), filter);
%    NewFiles = dir(pathandfilt{ifolder});
NewFiles = dir(pathandfilt);
    if ~isempty(NewFiles)
        fullnames = cellfun(@(a) fullfile(pathfolders{ifolder}, a), {NewFiles.name}, 'UniformOutput', false); 
        [NewFiles.name] = deal(fullnames{:});
        Files = [Files; NewFiles];
    end
end
%---------------------------
% Prune . and ..
%---------------------------
if ~isempty(Files)
    [~, ~, tail] = cellfun(@fileparts, {Files(:).name}, 'UniformOutput', false);
    dottest = cellfun(@(x) isempty(regexp(x, '\.+(\w+$)', 'once')), tail);
    Files(dottest & [Files(:).isdir]) = [];
end
%---------------------------
% Output
%---------------------------
    
if nargout == 0
    if ~isempty(Files)
        amt_disp(' ');
        amt_disp(Files.name);
        amt_disp(' ');
    end
elseif nargout == 1
    varargout{1} = Files;
end
function [p] = genpath_local(d)
% Modified genpath that doesn't ignore:
%     - Folders named 'private'
%     - MATLAB class folders (folder name starts with '@')
%     - MATLAB package folders (folder name starts with '+')
files = dir(d);
if isempty(files)
  return
end
p = '';  % Initialize output
% Add d to the path even if it is empty.
p = [p d pathsep];
% Set logical vector for subdirectory entries in d
isdir = logical(cat(1,files.isdir));
dirs = files(isdir);  % Select only directory entries from the current listing
for i=1:length(dirs)
   dirname = dirs(i).name;
   if i > 1
     p = [p pathsep];
   end
   if    ~strcmp( dirname,'.') && ~strcmp( dirname,'..')
       p = [p genpath(fullfile(d,dirname))];  % Recursive calling of this function.
   end
end


%===============================================================================

%The MIT License (MIT)

%Copyright (c) 2015 Kelly Kearney

%Permission is hereby granted, free of charge, to any person obtaining a copy of
%this software and associated documentation files (the "Software"), to deal in
%the Software without restriction, including without limitation the rights to
%use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
%the Software, and to permit persons to whom the Software is furnished to do so,
%subject to the following conditions:

%The above copyright notice and this permission notice shall be included in all
%copies or substantial portions of the Software.

%THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
%FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
%COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
%IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
%CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

