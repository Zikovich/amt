function outsig = viemeister1979(insig,fs)
%VIEMEISTER1979  The Viemeister (1979) leaky-integrator model
%   Usage: outsig=viemeister1979(insig,fs);
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/models/viemeister1979.php

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

%
%   VIEMEISTER79(insig,fs) is a simpel amplitude modulation detection model
%   from the paper Viemeister 79. The input insig is a matrix containing
%   the intervals as column vectors. The first column is assumed to
%   always contain the target. The output is 1 if the model found that
%   the most amplitude modulated interval was the target, and 0 otherwise.
%
%   This model is included mostly as a test, as it is so simple.
%
%   References: viemeister1979tmt

%   C. Hollomey (2020): added four-pole Butterworth Bandpass
%   AMT 1.0, PM (24.4.2021): Viemeister (1979) is about TMTFs, but the implementation is just a a leaky integrator. Is this the full model? Status: submitted/submitted/unknown
%   #StatusDoc: Submitted
%   #StatusCode: Submitted
%   #Verification: Unknown
%   #Requirements: M-Signal
  

narginchk(2, 2);
  
% 4-6 kHz four-pole Butterworth Bandpass (tentatively added)
[b, a] = butter (4, [4000/fs, 6000/fs]);
insig = filter(b, a, insig);
  
% halfwave rectification
insig = max(insig,0);

% first-order lowpass filter @ 65 Hz
[lp_b,lp_a] = butter(1,65/(fs/2));
insig = filter(lp_b, lp_a, insig);

% ac-coupled rms = std
%<<<<<<< HEAD:models/viemeister1979.m
%outsig = std(insig,1);

%=======
stddev = std(insig,1);

% Choose the interval with the highest standard deviation
[dummy,interval] = max(stddev);

% Answer is correct if we choose the first intervals
answer=(interval==1);

