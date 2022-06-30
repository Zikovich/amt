function out = may2011_framedata(input,blockSize,hopSize,win)
%MAY2011_FRAMEDATA   Frame data
% 
%   Usage:
%     frames = may2011_framedata(input,blockSize,hopSize,window,nFrames);
% 
%   Input parameters:
%     input     : input signal
%     blockSize : length of one audio block [samples]
%     hopSize   : length of time shift between audio blocks [samples]
%     win       : vector containing the window coefficients
% 
%   Output parameters:
%     out : processed audio
%
%   MAY2011_FRAMEDATA splits the input signal in blocks of length
%   blockSize. The overlap between adjacent blocks is given by
%   hopsize, and the desired window can be passed via win.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/may2011_framedata.php

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
 
%   Developed with Matlab 7.9.0.529 (R2009b).
   
%   Author  :  Tobias May, 2009 
%              TUe Eindhoven and Philips Research  
%              t.may@tue.nl      tobias.may@philips.com
%
%   History :
%   v.0.1   2009/11/23
%   v.0.2   2010/05/18 automatically determine the number of frames

% Check for proper input arguments
if nargin ~= 4
    help(mfilename);
    error('Wrong number of input arguments!');
end


% Compute number of frames
nFrames = max(fix((size(input,1)-(blockSize-hopSize))/(hopSize)),1);

% Check if window is a window in samples or a string
if ischar(win)
    win = window(win,blockSize);
else
    if blockSize ~= length(win)    
       error('Mismatch between blocksize and window size.') 
    end
end

% Framing (MEX processing)
out = comp_may2011_framedata(input,blockSize,hopSize,win,nFrames);


%   ***********************************************************************
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
% 
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
% 
%   You should have received a copy of the GNU General Public License
%   along with this program.  If not, see <http://www.gnu.org/licenses/>.
%   ***********************************************************************

