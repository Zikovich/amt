%DEMO_REIJNIERS2014 Demo for full sphere localization model from Reijniers et al. (2014)
%
%   DEMO_REIJNIERS2014(flag) demonstrates how to compute and visualize 
%   the baseline prediction (localizing broadband sounds with own ears) 
%   on the full sphere using the localization model from Reijniers et al. (2014).
%
%   Figure 1: Baseline prediction
% 
%      This demo computes the baseline prediction (localizing broadband 
%      sounds with own ears) for an exemplary listener (NH12).
%
%      Averaged polar and lateral accuracy
%
%   See also: reijniers2014 exp_reijniers2014 reijniers2014_featureextraction
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_reijniers2014.php

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
  
%   #Author : Roberto Barumerli

%% Settings

subID = 'NH12';   % subject ID of exemplary listener
az = 15;         % azimuth target angle in degrees
el = 30;         % elevation target angle in degrees
num_exp = 100;      % # of virtual experimental runs
display_level = 'no_debug'; % set to 'debug' to see more information, set to 'no_debug' to have less mess on your display

assert(numel(az)==numel(el))

amt_disp('Experiment conditions:','documentation');
for i=1:length(az)
    amt_disp(sprintf('  Azimuth: %0.1f deg; Elevation: %0.1f deg', az(i), el(i)),'documentation');
end
amt_disp(sprintf('  Repetitions: %i', num_exp),'documentation');
amt_disp('------------------------','documentation');


%% Get listener's data
SOFA_obj = SOFAload(fullfile(SOFAdbPath,'baumgartner2013', ...
                        'ARI_NH12_hrtf_M_dtf 256.sofa'));


%% Preprocessing source information for both directions
[template, target] = reijniers2014_featureextraction(SOFA_obj, ... 
                    'targ_az', az, 'targ_el', el, display_level);

%% Run virtual experiments
[doa, params] = reijniers2014(template, target, 'num_exp', num_exp, display_level);

%% Calcualte performance measures 
amt_disp('Performance Predictions:','documentation');

lat_acc = reijniers2014_metrics(doa, 'accL');
pol_acc = reijniers2014_metrics(doa, 'accP');

amt_disp(sprintf('  Lateral accuracy: %0.2fdeg', lat_acc),'documentation');
amt_disp(sprintf('  Polar accuracy: %0.2fdeg', pol_acc),'documentation');

%% Plot results
plot_reijniers2014(params.template_coords, ...
                   squeeze(params.post_prob(1, 1, :)), ...
                   'target', doa.real(1,:));
title('Posterior probability density of the first experiment');  

