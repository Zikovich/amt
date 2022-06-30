function plot_zakarauskas1993_contours(varargin)
% PLOT_ZAKARAUSKAS1993_CONTOURS Script for plotting HRTF contour plots 
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/plot/plot_zakarauskas1993_contours.php

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

% b=load('hrtf_M_KEMAR-CIPIC 22kHz.mat');
b=load('hrtf_M_KEMAR-CIPIC 44kHz.mat');

% settings
fs=b.stimPar.SamplingRate;       % sampling frequency
lat=00;         % lateral angle of sagital plane
delta=0;        % lateral variability in degree
q10=10;         % relativ bandwidth of filter bands;  default: 10
space=1.10;     % spacing factor of filter bank (distance of bands)
fstart =1000;   % start frequency of filter bank;     default: 1kHz
fend   =15000;   % end frequency of filter bank;       default: 11kHz

% sorting data and filtering
idx=find(b.posLIN(:,4)>=-(delta+0.01)/2+lat & b.posLIN(:,4)<=(delta+0.01)/2+lat); % median plane with lateral delta-variation; +0.01 because of rounding errors in posLIN
[pol,polidx]=unique(b.posLIN(idx,5));   % sorted polar angles
sagir=double(b.hM(:,idx,:));            % unsorted impulse responses on sagital plane
ir=sagir(:,polidx,:);                   % sorted
[y2n,y2n,fn]=butterfb(ir,ir,q10,fstart,fend,fs,space); % filter bank
y2n=y2n-max(max(max(y2n)))+14;

% plots
do=0;
figure;
[C,h] = contour(fn(1:end-do),pol,dif(squeeze(y2n(:,:,1)),do)');
set(gca,'XScale','log')
set(gca,'XLim',[1000 10000])
set(gca,'XTick',1000:1000:10000)
set(gca,'XTickLabel',{'1','2','3','4','5','6','7','8','9','10'})
set(gca,'YLim',[-90 270])
set(gca,'YTick',[-90 -50:50:250 270])
set(gca,'YTickLabel',{'','-50','0','50','100','150','200','250',''})
set(gca,'YMinorTick','on')
set(h,'LevelStep',2)
colormap hot
c=colormap;
colormap(flipud(c));
axis square
clabel(C,h,[-12 -4 0 4 8 12 14])
xlabel('Frequency in kHz');ylabel('Elevation in degrees');
title(sprintf('X_n  ;  Q_{10}=%d  ;  c.f. Fig. 4 of Zakarauskas et al. (1993)',q10))

do=1;
figure;
[C,h] = contour(fn(1:end-do),pol,dif(squeeze(y2n(:,:,1)),do)');
set(gca,'XScale','log')
set(gca,'XLim',[1000 10000])
set(gca,'XTick',1000:1000:10000)
set(gca,'XTickLabel',{'1','2','3','4','5','6','7','8','9','10'})
set(gca,'YLim',[-90 270])
set(gca,'YTick',[-90 -50:50:250 270])
set(gca,'YTickLabel',{'','-50','0','50','100','150','200','250',''})
set(gca,'YMinorTick','on')
set(h,'LevelStep',2)
colormap(flipud(c));
axis square
clabel(C,h,-8:4:12)
xlabel('Frequency in kHz');ylabel('Elevation in degrees');
title(sprintf('D_n  ;  Q_{10}=%d  ;  c.f. Fig. 5 of Zakarauskas et al. (1993)',q10))

do=2;
figure;
[C,h] = contour(fn(1:end-do),pol,dif(squeeze(y2n(:,:,1)),do)');
set(gca,'XScale','log')
set(gca,'XLim',[1000 10000])
set(gca,'XTick',1000:1000:10000)
set(gca,'XTickLabel',{'1','2','3','4','5','6','7','8','9','10'})
set(gca,'YLim',[-90 270])
set(gca,'YTick',[-90 -50:50:250 270])
set(gca,'YTickLabel',{'','-50','0','50','100','150','200','250',''})
set(gca,'YMinorTick','on')
set(h,'LevelStep',2)
colormap(flipud(c));
axis square
clabel(C,h,-5:5:20)
xlabel('Frequency in kHz');ylabel('Elevation in degrees');
title(sprintf('C_n  ;  Q_{10}=%d  ;  c.f. Fig. 6 of Zakarauskas et al. (1993)',q10))

