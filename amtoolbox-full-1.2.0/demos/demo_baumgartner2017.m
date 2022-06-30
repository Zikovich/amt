%DEMO_BAUMGARTNER2017 Demo for testing Baumgartner2017.m
%
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_baumgartner2017.php

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

% AUTHOR : Clara Hollomey
flags = {'boyd2012', 'hartmann1996', 'hassager2016', 'baumgartner2017'};

flag = flags{1};

data = exp_baumgartner2017(flag);
