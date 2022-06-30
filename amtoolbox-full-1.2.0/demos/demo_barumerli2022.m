%DEMO_BARUMERLI2022 Demo for full sphere localization model from Barumerli et al. (2022)
%
%   DEMO_BARUMERLI2022(flag) demonstrates how to compute and visualize 
%   the baseline prediction (localizing broadband sounds with own ears) 
%   on the full sphere using the localization model from Barumerli et al. (2022).
%
%   Figure 1: Baseline prediction
% 
%      This demo computes the baseline prediction (localizing broadband 
%      sounds with own ears) for an exemplary listener (NH12).
%
%      Averaged polar and lateral accuracy
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_barumerli2022.php

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

%   See also: barumerli2022 exp_barumerli2022 
% AUTHOR : Roberto Barumerli

amt_disp('Loading real data from Majdak et al. 2010')

data_majdak = data_majdak2010('Learn_M');
data_majdak = data_majdak(6);

%% real subject
% print metrics computed on real data 
real = barumerli2022_metrics(data_majdak.mtx, 'middle_metrics');

amt_disp('Metrics from actual data')
amt_disp(sprintf('lateral_bias [°]:\t%0.2f', real.accL))
amt_disp(sprintf('lateral_rms_error [°]:\t%0.2f', real.rmsL))
amt_disp(sprintf('elevation_bias [°]:\t%0.2f', real.accP))
amt_disp(sprintf('local_rms_polar [°]:\t%0.2f', real.rmsP))
amt_disp(sprintf('quadrant_err [%%]:\t%0.2f', real.querr))

%% simulated subject
% load HRTF dataset
amt_disp('Model simulation starting...')

sofa_obj = SOFAload(fullfile(SOFAdbPath,'barumerli2022',['ARI_NH12_hrtf_M_dtf 256.sofa']));

% compute features for target and templates 
amt_disp(sprintf('\nGenerating feature space over the uniformily sampled sphere'))
[template, target] = barumerli2022_featureextraction(sofa_obj, 'pge');

% estimate each direction in the target struct twice
amt_disp('Simulating subject answers')
m = barumerli2022(...
                'template', template, ...
                'target', target, ...
                'num_exp', 2, ...
                'sigma_itd', 0.569, ...
                'sigma_ild', 0.7, ...
                'sigma_spectral', 1.25, ...
                'sigma_prior', 11.5, ...
                'sigma_motor', 11);

% compute metrics over estimated directions
sim = barumerli2022_metrics(m, 'middle_metrics');

amt_disp('Metrics from simulated data')
amt_disp(sprintf('lateral_bias [°]:\t%0.2f', sim.accL))
amt_disp(sprintf('lateral_rms_error [°]:\t%0.2f', sim.rmsL))
amt_disp(sprintf('elevation_bias [°]:\t%0.2f', sim.accP))
amt_disp(sprintf('local_rms_polar [°]:\t%0.2f', sim.rmsP))
amt_disp(sprintf('quadrant_err [%%]:\t%0.2f', sim.querr))

%% ESTIMATE ONE DIRECTION
amt_disp(sprintf('\nSimulating single estimation'))

targ_az = 0;
targ_el = 45;

% compute features only for the single bianural sound
% (the template has been computed above)
target_single = barumerli2022_featureextraction(sofa_obj, 'pge', 'target','targ_az', targ_az, 'targ_el', targ_el);

% simulate single estimation process
[m, doa, doa_real] = barumerli2022(...
                'template', template, ...
                'target', target_single, ...
                'num_exp', 1, ...
                'sigma_itd', 0.569, ...
                'sigma_ild', 0.7, ...
                'sigma_spectral', 1.25, ...
                'sigma_prior', 11.5, ...
                'sigma_motor', 11);

% print resulted estimation
for i=1:size(targ_az,1)
    amt_disp(sprintf('target [az,el]: [%.2f, %.2f]', targ_az(i), targ_el(i)))
    amt_disp(sprintf('response [az,el]: [%.2f, %.2f]\n', m(i, 3), m(i, 4)))
end

plot_reijniers2014(template.coords.return_positions('cartesian'), ...
                    doa.posterior, ...
                    'target', doa_real.return_positions('cartesian'));
title('Posterior distribution and target direction')
