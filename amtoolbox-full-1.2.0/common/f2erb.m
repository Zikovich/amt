function ERB = f2erb(CF_Hz, ERB_break_freq, ERB_Q)
%F2ERB calculates the widt of 1 Cam in Hz at frequency f in Hz
%
%   When used with only the frequency as input, F2ERB calculates ERB [Hz]
%   according to moore2016
%   when used with all three input parameters, it calculates ERB [Hz]
%   as used in lyon2011
%
%   Auditory filter nominal Equivalent Rectangular Bandwidth
%   Ref: Glasberg and Moore: Hearing Research, 47 (1990), 103-138
%   
%       ERB = 24.7 * (1 + 4.37 * CF_Hz / 1000);
%
%   See also: moore2016 lyon2011_design
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/common/f2erb.php

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


if nargin < 3
    ERB_Q = 1000/(24.7*4.37);  % 9.2645
        if nargin < 2
            ERB_break_freq = 1000/4.37;  % 228.833
        end
end

if nargin == 1
    ERB = 24.673*(0.004368*CF_Hz + 1); %as originally given in moore2016
else
    ERB = (ERB_break_freq + CF_Hz) / ERB_Q;
end

