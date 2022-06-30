
display_level = 'debug'; % set to 'debug' to see more information, set to 'no_debug' to have less mess on your display
fc = 1000;
fs = 44100;
itd = 0.001;
ild = 1;

insig = sig_itdildsin(fc,itd,ild,fs);

[results] = kelvasa2015(insig,fs,display_level);
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_kelvasa2015.php

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
[results] = kelvasa2015(insig,fs,display_level);
