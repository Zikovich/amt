function [h] = plot_zakarauskas1993_dif( d,c,pol,pos,tit )
% PLOT_ZAKARAUSKAS1993_DIF plots summed differences of estimation
%
%   Usage:
%     [h] = plot_zakarauskas1993_dif( d,c,pol,pos )
%     [h] = plot_zakarauskas1993_dif( d,c,pol,pos,tit )
%
%   Input arguments:
%     d:       summed differences of D-estimator (1st order differential)
%     c:       summed differences of C-estimator (2nd order differential)
%     pol:     source angles
%     pos:     pol-index of plotted response angle
%     tit:     string for figure title
%
%   Definition:
%     plots summed differences of estimation (Zakarauskas 1993, Fig. 9)
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/plot/plot_zakarauskas1993_dif.php

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
% latest update: 2010-08-24
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%default settings
if ~exist('pos','var')
    pos=23;
end
if ~exist('tit','var')
    tit='comparison of D- and C-estimator';
end

h=figure('Name','Localization model of Zakarauskas et al.(1993), cf. Fig.9','NumberTitle','off');
clf
plot(pol,d(:,pos),':');
hold on
plot(pol,c(:,pos),'r');
legend('D_n','C_n');
xlabel('Source elevation (degrees)');
ylabel('Summed difference');
title(tit);

end

