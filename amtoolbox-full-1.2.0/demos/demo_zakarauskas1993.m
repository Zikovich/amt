%DEMO_ZAKARAUSKAS1993 script for localization model according to ZAKARAUSKAS et al.(1993)
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_zakarauskas1993.php

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Robert Baumgartner, OEAW Acoustical Research Institute
% latest update: 2010-08-03
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

b = amt_load('zakarauskas1993', 'hrtf_M_KEMAR-gardner 22kHz.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               SETTINGS                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% global settings
fs=b.stimPar.SamplingRate;       % sampling frequency
plotflag=1;     % switch for plots
lat=00;         % lateral angle of sagital plane
delta=0;        % lateral variability in degree
% model settings
q10=10;         % relativ bandwidth of filter bands;  default: 10
space=1.10;     % spacing factor of filter bank (distance of bands)
bal= 1;         % balance of left to right channel;   default: 1
fstart =1000;   % start frequency of filter bank;     default: 1kHz
fend   =11000;  % end frequency of filter bank;       default: 11kHz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

idx=find(b.posLIN(:,4)>=-(delta+0.01)/2+lat & b.posLIN(:,4)<=(delta+0.01)/2+lat); % median plane with lateral delta-variation; +0.01 because of rounding errors in posLIN
[pol,polidx]=unique(b.posLIN(idx,5));   % sorted polar angles
sagir=double(b.hM(:,idx,:));            % unsorted impulse responses on sagital plane
ir=sagir(:,polidx,:);                   % sorted

paper = zakarauskas1993_inputfilter( 'imp','paper' );
shock = zakarauskas1993_inputfilter( 'imp','shock' );

h = waitbar(0,'Please wait...');

do = 1;
[dp,hitsdp,errdp,aedp] = zakarauskas1993( ir,pol,paper,q10,do,bal,fstart,fend,fs,space ); 
waitbar(1/4)
[ds,hitsds,errds,aeds] = zakarauskas1993( ir,pol,shock,q10,do,bal,fstart,fend,fs,space ); 
waitbar(2/4)

do = 2;
[cp,hitscp,errcp,aecp] = zakarauskas1993( ir,pol,paper,q10,do,bal,fstart,fend,fs,space );
waitbar(3/4)
[cs,hitscs,errcs,aecs] = zakarauskas1993( ir,pol,shock,q10,do,bal,fstart,fend,fs,space );
waitbar(4/4)
close(h)

% plots
if plotflag==1
    plot_zakarauskas1993_dif( ds,cs,pol,find(pol>=190,1,'first'),'word "shock"' );
    plot_zakarauskas1993_responsepattern( errds,errcs,pol,'word "shock"' );
    % result table
    disp('_______________________________________');
    disp('               Operator  Paper   Shock');
    disp(sprintf('#exact/%d:         D      %d      %d',size(cp,1),hitsdp,hitsds));
    disp(sprintf('#exact/%d:         C      %d      %d',size(cp,1),hitscp,hitscs));
    disp(sprintf('Average error:     D    %5.2f�  %5.2f�',aedp,aeds));
    disp(sprintf('Average error:     C    %5.2f�  %5.2f�',aecp,aecs));
    disp('_______________________________________');
end
