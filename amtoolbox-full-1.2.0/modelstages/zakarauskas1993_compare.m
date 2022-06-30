function [ out ] = zakarauskas1993_compare( in1,in2,do,bal )
% ZAKARAUSKAS1993_COMPARE Comparison process according to Zakarauskas et al. (1993)
%
%   Usage:      
%     [ out ] = zakarauskas1993_compare( in1,in2 )
%     [ out ] = zakarauskas1993_compare( in1,in2,do )
%     [ out ] = zakarauskas1993_compare( in1,in2,do,bal )
%
%   Input parameters:
%     in1:      modified DFT for one target position and both ears
%     in2:      stored DFT-templates for all positions and both ears
%     do:       differential order; default: 2
%     bal:      balance of left to right channel; default: 1
%
%   Output parameters:
%     out:      summed differences
%
%   Description:
%     This function compares two directional transfer functions with each other.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/zakarauskas1993_compare.php

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
%   latest update: 2010-07-30


% default settings
if ~exist('do','var')
    do=2;
end
if ~exist('bal','var')
    bal=1;
end

ptemp=zeros(size(in2,2),2); % initialisation
for ch=1:2
    for ind=1:size(in2,2)
        z=diff(in1(:,ch),do)-diff(in2(:,ind,ch),do);
        ptemp(ind,ch)=sum(abs(z));
    end
end
p=(bal*ptemp(:,1)+1/bal*ptemp(:,2))/2; % balance
out=p;
end

