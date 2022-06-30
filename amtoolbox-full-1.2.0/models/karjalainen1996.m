function [slow,fast]=karjalainen1996(insig,fs)
%KARJALAINEN1996  Non-linear adapation network
%   Usage: [slow,fast]=karjalainen1996(insig,fs)
%
%   [slow,fast]=KARJALAINEN1996(insig,fs) computes the non-linear
%   adaptation network from Karjalainen et al. (1996) on the input signal
%   insig sampled with a sampling frequency of fs Hz.
% 
%    XXX What are the assumptions on the input? The example below
%     generates NaN's
%
%    XXX What is slow and fast*? In which units are they defined?
%
%    XXX Which level convention is used ?
%
%    XXX Bibtex entry for the correct paper to cite.
%
%   Examples:
%   ---------
%
%   The following show the adapation to a simple test signal:
%
%     [insig,fs] = greasy;
%     [slow,fast]=karjalainen1996(insig,fs);
%
%     subplot(1,2,1);
%     plot(slow);
%
%     subplot(1,2,2);
%     plot(fast);
%
%   This file (and the corresponding mex file) where originally part of
%   HUTear- Matlab toolbox for auditory modeling. The toolbox is available at 
%   http://www.acoustics.hut.fi/software/HUTear/>`
%
%   AMT 1.0: PM (24.4.2021): single stage from a larger model presented at a conference without data for evaluation. Status: submitted/submitted/unknown.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/models/karjalainen1996.php

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

%   #StatusDoc: Good
%   #StatusCode: Good
%   #Verification: Unknown
%   #Author: Aki Härmä, Helsinki University of Technology, 

[slow,fast]=comp_karjalainen1996(insig,fs);
