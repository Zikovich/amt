function may2011_cbarlabel(szString,fig)
%MAY2011_CBARLABEL sets the labels of a cbar plot
%
%   Usage: 
%     may2011_cbarlabel(szString,fig)
%
%   Input parameters:
%     szString : ordinate label
%     fig      : figure number
%
%   Output parameters:
%      OUT : results [nFrames x 1]
%
%
%   MAY2011_CBARLABEL is a helper function to modify cbar plots.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/may2011_cbarlabel.php

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

%   Developed with Matlab 7.8.0.347 (R2009a).
%   
%   Author  :  Tobias May, 2009 
%              TUe Eindhoven and Philips Research  
%              t.may@tue.nl      tobias.may@philips.com
%
%   History :
%   v.1.0   2009/08/6


%% ***********************  CHECK INPUT ARGUMENTS  ************************

% Check for proper input arguments
if nargin < 1 || nargin > 2
    help(mfilename);
    error('Wrong number of input arguments!');
end

% Set default values
if nargin < 2 || isempty(fig); fig = gcf; end

% Look for color handel
allH = get(fig,'children');

% Number of handels
nHandles = length(allH);

% Allocate logical operator
isCBar = false(nHandles,1);

% Loop over objects
for ii = 1 : length(allH)
    if strmatch('Colorbar',get(allH(ii),'tag'));
        isCBar(ii) = true;
    end       
end

% Set colormap label
switch isequal(1,sum(isCBar))
    case 0
        warning('No colorbar was detected ...')
    case 1
        set(get(allH(isCBar),'ylabel'),'String',szString);
    otherwise
        error('Confusion due to multiple colorbars ...')
end

h = allH(isCBar);

