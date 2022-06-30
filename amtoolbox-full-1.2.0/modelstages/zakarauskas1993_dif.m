function [ out ] = zakarauskas1993_dif( in,do_it )
%ZAKARAUSKAS1993_DIF differentiates input signal
%
%   Usage:
%     [ out ] = zakarauskas1993_dif( in,do_it )
%
%   Input parameters:
%     in:       magnitude of spectrum
%     do_it:       differential order; default: 0
%
%   Output parameters:
%     out:      derivative of input signal
%
%   Description:
%     This function differentiates the input signal.
%
%   Author: Robert Baumgartner, OEAW
%   latest update: 2010-07-19
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/zakarauskas1993_dif.php

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

% default settings
if ~exist('do_it','var')
    do_it=0;
end

if length(size(in))==1
    switch do_it
        case {1}
            x1=zeros(length(in)-1,1);
            for ind=1:size(x1,1)
                x1(ind) = in(ind+1) - in(ind);
            end
            out=x1;
        case {2}
            x1=zeros(length(in)-1,1);
            for ind=1:size(x1,1)
                x1(ind) = in(ind+1) - in(ind);
            end
            x2=zeros(length(x1)-1,1);
            for ind=1:size(x2,1)
                x2(ind) = x1(ind+1) - x1(ind);
            end
            out=x2;
        otherwise
            out=in;
    end
elseif length(size(in))==2
    switch do_it
        case {1}
            x1=zeros(size(in,1)-1,size(in,2));
            for ii=1:size(in,2)
                for ind=1:size(x1,1)
                    x1(ind,ii) = in(ind+1,ii) - in(ind,ii);
                end
            end
            out=x1;
        case {2}
            x1=zeros(size(in,1)-1,size(in,2));
            for ii=1:size(in,2)
                for ind=1:size(x1,1)
                    x1(ind,ii) = in(ind+1,ii) - in(ind,ii);
                end
            end
            x2=zeros(size(x1,1)-1,size(in,2));
            for ii=1:size(in,2)
                for ind=1:size(x2,1)
                    x2(ind,ii) = x1(ind+1,ii) - x1(ind,ii);
                end
            end
            out=x2;
        otherwise
            out=in;
    end
else
    disp('Please insert each channel seperately!');
end
end


