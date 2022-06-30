function [f, varargout] = f2bmdistance( segnum, varargin)
%F2BMDISTANCE calculates the resonance frequency of each cochlear segment
%    
%   Usage: f = f2bmdistance( segnum );
%          f = f2bmdistance( flow, fhigh, segnum );
%
%   F2BMDISTANCE uses the Greenwood position-frequency map function (1990)
%   for calculating the characteristic frequencies (CFs) and the cochlear 
%   positions (Pos) corresponding to the distribution of segnum channels. The
%   the low-frequency (flow) and the high-frequency (fhigh) range can be
%   optionally specified.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/common/f2bmdistance.php

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

if nargin == 1
    %assume we have the segment index given
    n=0:1/segnum:1;
    f=zeros(1,length(n)-1);
    seg=zeros(1,segnum);
    for i=1:segnum
        seg(i)=(n(i)+n(i+1))/2;
    end

    %% Greenwoood parameters
    A = 165.44; % for human auditory span it is A=160.1377
    alfa = 2.1;
    k = 1;
    %% Calculate the Greenwood function
    fe=zeros(size(seg));
    fe=A.*(10.^(alfa.*seg)-k);
    f=fliplr(fe);
    %% Display if needed
    % figure(1)
    % stem(seg,f,':r');
elseif nargin == 3
    %assume we have flow, fhigh, and number of channels given
    Flow = segnum;
    Fhigh = varargin{1};
    N = varargin{2};
    %% Greenwoood parameters
    A = 165.44; % for human auditory span it is A=160.1377
    alfa = 2.1;
    k = 1;
    Plow=(log10((Flow/A)+k)/alfa);
    Phigh=(log10((Fhigh/A)+k)/alfa);
    buff=zeros(1,N+1);Pos=zeros(1,N);
    for i=1:N
        Pos(i)=((Plow-Phigh)/(N-1))*(i-1)+Phigh;
    end

    %%
    CF=zeros(size(Pos));
    CF=A.*(10.^(alfa.*Pos)-k);
    Pos=1-Pos;
    %%
    f = CF;
    varargout{1} = Pos;
else
    error('f2bmdistance either requires the segment index, or flow, fhigh, and channelnumber as input arguments.');
    
end

