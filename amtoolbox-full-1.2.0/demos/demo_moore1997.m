%DEMO_MOORE1997 was implemented for testing purposes by Clara Hollomey (December 2020)
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_moore1997.php

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

fs = 32000; 
t = linspace(0,1,fs);
sig = sin(2*pi*1000*t).';
inSig = scaletodbspl(sig,100, 100);  

[results] = moore1997(inSig,fs);

figure
plot(results.erbN, results.eLdB)
title('Excitation pattern')
ylabel('E/E0')
xlabel('Critical bands [cams]')
