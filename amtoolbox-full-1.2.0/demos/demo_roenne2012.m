%DEMO_ROENNE2012 implemented for testing purposes
%
%   Simulates a click evoked ABR (c0 of the loaded file is a click). 
%   Note that the click loaded in this example starts after 15ms. 
%   The simulated wave V latency is thus also 15 ms "late"
%
%   Figure 1: ABR response
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_roenne2012.php

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

%   #Author: Clara Hollomey (December 2020)

stim=data_elberling2010('stim');
stim_level = 60;
flow = 100;
fhigh = 16000;

[waveVamp, waveVlat, simpot, ANout]  = roenne2012(stim.c0,30e3,stim_level);

plot_roenne2012(stim_level,waveVamp, waveVlat, simpot, ANout, 'flow',flow, 'fhigh', fhigh);


