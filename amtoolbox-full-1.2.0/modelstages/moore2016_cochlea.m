function out = moore2016_cochlea( s, filenameFilter )
%MOORE2016_COCHLEA performs outer and middle ear filtering
%
%   Input parameters:
%     s : input signal
%     filenameFilter : name of the file containing the filter coefficients
%
%   Output parameters:
%     out : filtered signal
%
%   This code corresponds to the outer and middle ear filtering in the binaural loudness model moore2016
%   in the version for TVL 2016 based on ANSI S3.4-2007 and Moore & Glasberg (2007).
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/moore2016_cochlea.php

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


    %load([filenameFilter]);
    data = amt_load('moore2016', 'ff_32000.mat');
    vecCoefficients = data.vecCoefficients;
    out(:,1) = conv( vecCoefficients, s(:,1) );
    if ( min( size(s) ) > 1 )
        out(:,2) = conv( vecCoefficients, s(:,2) );
    else
        out(:,2) = out(:,1);
    end
    out = out((1025):(end-1024),:);
%     out = [zeros(1024,2); s; zeros(1024,2)];  % without filter
end

