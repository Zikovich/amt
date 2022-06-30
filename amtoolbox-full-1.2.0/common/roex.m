function W = roex(fc, fs)
%ROEX  roex fit as proposed in patterson1982
%   Usage: W = roex(fc,fs,'type');
%
%   Input parameters:
%      fc    : center frequency in Hz.
%      fs    : sampling rate in Hz.
%      type  : 'p', 'pr', or 'pwt'.
%
%   Output parameters:
%      W     :  vector containing the roex-fitted values.
%
%   ROEX(fc, fs, varagin) computes the roex fit to
%   notched-noise masking data as proposed in patterson1982.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/common/roex.php

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

g = (0.001: 0.001 : 0.8) *fs/fc; 
% corresponds to deltaF/f0, with boundaries as in patterson1982

r = 0.0001; %approximates shallow tail outside of passband
p = 25; %reflects broadening of filter passband
    
%summation of roex approximation and integration tail
W = (1-r)*(1+p*g).*exp(-p*g) + r +...
   -(1-r)*p^(-1)*(2+p*g).*exp(-p*g)+r*g;

%build symmetric filter 
W = [flip(W), W];
