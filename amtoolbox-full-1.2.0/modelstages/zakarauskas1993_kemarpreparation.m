function hM = zakarauskas1993_kemarpreparation(varargin)
%ZAKARAUSKAS1993_KEMARPREPARATION Kemar HRTF preprocessing
%
%   Usage: hM = zakarauskas1993_kemarpreparation;
%
%   Description:
%     Preparation of KEMAR data to validate Zakarauskas et al. (1993)
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/zakarauskas1993_kemarpreparation.php

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

%   Author: Robert Baumgartner, OEAW Acoustical Research Institute
%   latest update: 2010-08-12


amt_load('zakarauskas1993','hrtf_M_KEMAR normal pinna 22kHz');
hM=double(hM);
h=zeros(256,710,2);

for jj=1:size(hM,2)
    for ch=1:2
        h(:,jj,ch)=resample(hM(:,jj,ch),11,24);
    end
end
hM=h;
hM=hrtf2dtf(hM);  
hM=single(hM);

