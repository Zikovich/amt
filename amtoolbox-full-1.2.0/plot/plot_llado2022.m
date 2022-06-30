function [] = plot_llado2022(y_est_dir,y_est_uncertainty,angle_id,y_test)
%PLOT_LLADO2022 plots the figures from llado et al. (2022)
%   Usage: plot_llado2022(y_est_dir,y_est_uncertainty,angle_id,y_test);
%
%   Input parameters:
%     y_est_dir          : Estimated data for perceived direction
%     y_est_uncertainty  : Estimated data for perceived uncertainty
%     angle_id           : Vector of lateral angles of the test subset
%
%   PLOT_LLADO2022 plots the Figures from llado2022.
%
%   Optional input parameters:
%
%     'y_test'           labels from subjective test
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/plot/plot_llado2022.php

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


%%  DEFAULT OPTIONAL INPUTS
%%
figure;
subplot(1,2,1)
if nargin > 3
    plot(angle_id,y_test(:,1),'k','LineWidth',2);
    hold on;
end
plot(angle_id,y_est_dir,'k','LineStyle','--','LineWidth',2);
title('Perceived direction');
ylim([min(angle_id)-10 max(angle_id)+10])
xlim([min(angle_id)-10 max(angle_id)+10])
ax = gca();
grid(ax, 'on') 
set(ax,'XTick',angle_id)
ylabel('Perceived direction (°)')
xlabel('Sound source direction (°)')

ax.XTick = [angle_id];
ax.XTickLabel = [angle_id];


ax.YTick = [angle_id];
ax.YTickLabel = [angle_id(end:-1:1)];
set(gca, 'YDir','reverse')
if nargin > 3
    legend('Subjective','NN-Estimated','Location','northwest');
else
    legend('NN-Estimated','Location','northwest');
end



%%
%figure;
subplot(1,2,2)
if nargin >3
    plot(angle_id,y_test(:,2),'k','LineWidth',2);
    hold on;
end
plot(angle_id,y_est_uncertainty,'k','LineStyle','--','LineWidth',2);
title('Position uncertainty');
ylim([0 10])
xlim([min(angle_id)-10 max(angle_id)+10])
ax = gca();
grid(ax, 'on') 
set(ax,'XTick',angle_id)
ylabel('Position uncertainty (°)')
xlabel('Sound source direction (°)')
ax.XTick = [angle_id];
ax.XTickLabel = angle_id;

if nargin > 3
    legend('Subjective','NN-Estimated','Location','northwest');
else
    legend('NN-Estimated','Location','southwest');
end
end

