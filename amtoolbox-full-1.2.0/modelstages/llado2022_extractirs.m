function [IRs] = llado2022_extractirs(sofaFileName,lat_angles,fs)
%LLADO2022_EXTRACTIRS extract impulse response signals for the given lateral angles from a sofa file
%
%   Input parameters:
%     sofaFileName   : hrir set in sofa format
%     lat_angles     : vector of lateral angles to extract
%     fs             : sample frequency
%
%   Output parameters:
%     IRs            : Impulse response according to the following matrix
%                      dimensions: direction x time x channel/ear
%
%   LLADO2022_EXTRACTIRS extracts the impulse responses as a SOFA file
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/llado2022_extractirs.php

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

hrirname = char(sofaFileName);
SOFAobj = SOFAload(['http://amtoolbox.org/amt-1.1.0/hrtf/llado2022/',hrirname]);
if (fs ~= SOFAobj.Data.SamplingRate)
    amt_disp('Sample Frequency mismatch');
end

for lat_id = 1:length(lat_angles)
    lat = lat_angles(lat_id);
    idx=find(round(SOFAobj.SourcePosition(:,1),0)==lat & SOFAobj.SourcePosition(:,2)==0,1);
    IRs(lat_id,:,:)=squeeze(SOFAobj.Data.IR(idx,:,:));
end
IRs = permute(IRs,[1,3,2]);
end
    

