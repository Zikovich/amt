%DEMO_VIEMEISTER1979 test demo
%   this demo has been implemented for testing purposes by Clara Hollomey (December 2020)
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_viemeister1979.php

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

fs = 44100;
duration = 1;
t = 1/fs:1/fs:duration;

carrier = sind(6000 * t);
carrier = randn(1,44100);

faxis = [0 2 4 8 16 32 64 125 250 500 1000 2000 4000];

for ii = 1:length (faxis)
  insig = sind(faxis(ii) * t).* carrier;
  modelOut(ii) = viemeister1979(insig,fs);
end  

plot(faxis(2:end), 20*log10(modelOut(2:end))/2)
%m...ratio of peak value to dc
xlim([1 1000])
xticks(faxis)

set (gca (), "ydir", "reverse")
xlabel('Modulation frequency')
ylabel('Modulation index')
grid on
