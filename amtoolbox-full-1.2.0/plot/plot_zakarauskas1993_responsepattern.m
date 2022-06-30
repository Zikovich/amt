function [h] = plot_zakarauskas1993_responsepattern( errd,errc,pol,tit )
% PLOT_ZAKARAUSKAS1993_RESPONSEPATTERN plots response pattern estimation
%
%   Usage:       
%     plot_zakarauskas1993_responsepattern( errd,errc,pol )
%     plot_zakarauskas1993_responsepattern( errd,errc,pol,tit )
%
%   Input arguments:
%     errd:    error of D-estimator (1st order differential)
%     errc:    error of C-estimator (2nd order differential)
%     pol:     source angles
%     tit:     string for figure title
%
%   Description:
%     plots response pattern of estimation according to
%     Zakarauskas et al. (1993), Fig.8
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/plot/plot_zakarauskas1993_responsepattern.php

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
% latest update: 2010-08-05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%default settings
if ~exist('tit','var')
    tit='response patterns of D- and C-estimator';
end

h=figure('Name','Localization model of Zakarauskas et al.(1993), cf. Fig.8','NumberTitle','off');
clf
plot(pol,pol+errd,'b+:');
hold on
plot(pol,pol+errc,'rs-');
set(gca,'XMinorTick','on')
set(gca,'YMinorTick','on')
axis square
legend('D_n','C_n','Location','SouthEast');
xlabel('Source elevation (degrees)');
ylabel('Located elevation (degrees)');
title(tit);

end

