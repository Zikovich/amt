function mfc=mfc(fc)
%MFC Generate all possible modulation frequencies for a given fc
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/common/mfc.php

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
s=[0,5,10*(5/3).^(0:9)];

Q = 2;
bw = 5;
ex=(1+1/(2*Q))/(1-1/(2*Q));

startmf = 5;

umf = min(fc.*0.25, 1000);  

tmp = fix((min(umf,10) - startmf)/bw);
tmp = 0:tmp;
mfc = startmf + 5*tmp;
tmp2 = (mfc(end)+bw/2)/(1-1/(2*Q));
tmp = fix(log(umf/tmp2)/log(ex));
tmp = 0:tmp;
tmp = ex.^tmp;
mfc=[0 mfc tmp2*tmp];

%OLDFORMAT

