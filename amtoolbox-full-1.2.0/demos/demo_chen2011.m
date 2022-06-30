%DEMO_CHEN2011 plot equal loudness contours from chen2011 to ISO standard
%
%   DEMO_CHEN2011 contrasts the equal loudness contours obtained from the 
%   model devised by Chen et al. (2011) with those from ISO 226-2003.
%
%   Figure 1: Comparison of equal loudness contours
%  
%   See also: chen2011 exp_chen2011
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_chen2011.php

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

%   #Author : Zhangli Chen (2011-08-12)

OuterEarOpt = 'FreeField';

%% 1-kHz as reference
CF1k = 1000;
LdB1k = [2 10:10:90]';
for j = 1:length(LdB1k)
    Ldn1k(j) = chen2011(CF1k,LdB1k(j), OuterEarOpt);
end

%% calculating equal loudness contours
%this is the data from iso226-2003
data = amt_load('chen2011', 'data_chen2011.mat');
freq = data.freq;
spl = data.spl;

f = freq(:,1);
LdB = -10:2:140;

for i = 1:length(f)  
    for j = 1:length(LdB)
        [Ldn(j),Exitation,Cam,CF] = chen2011(f(i),LdB(j), OuterEarOpt);          
    end
    
    LdB_sameLdn(i,:) = interp1(Ldn,LdB,Ldn1k,'linear','extrap');
end

figure;
semilogx(freq(:,1),spl(:,1)-1.6,'k--',freq(:,1),LdB_sameLdn(:,1),'k',...
    freq(:,2:end),spl(:,2:end),'k--',freq(:,2:end),LdB_sameLdn(:,2:end),'k');
legend('ISO 226-2003','This paper');
xlabel('Frequency, Hz');ylabel('LdB, dB SPL');
axis([20 20000 -10 130]);
set(findobj('FontSize',10),'FontSize',12);
set(get(gca,'XLabel'),'FontSize',12);
set(get(gca,'YLabel'),'FontSize',12);
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
set(gca,'LineWidth',1');
text(600,44,'40 phons');


