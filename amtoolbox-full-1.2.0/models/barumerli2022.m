function [varargout] = barumerli2022(varargin)
%BARUMERLI2022  Bayesian spherical sound localization model (multi-feature)
%   Usage: [m] = barumerli2022(sofa_obj);
%          [m] = barumerli2022(template,target);
%   
%   Input parameters:
%       sofa_obj : valid SOFA object containing listener HRTFs. 
%                  The model computes the templates and the targets 
%                  from the direction in the object. Then, the model  
%                  estimates all the directions in the SOFA object.
%
%   Output parameters:
%     m       : (matrix) table organized as in localizationerror.m with actual
%               and predicted directions. Consider
%               barumerli2022_metrics for the analysis of such matrix.
%     doa     : (stuct) data struct containg the field .estimations and .posterior. 
%               The first is a matrix with dimensions [target_num, kv.num_exp, 3]
%               and coordinates are stored in cartesian coordinates.
%               The second provide the computed posterior distribution for
%               further elaborations and its dimensions are 
%               [target_num, template_num, kv.num_exp).
%     coords  : (object) actual directions of the binaural sounds in
%               target struct.
%
%
%   BARUMERLI2022(...) is an ideal-observer model of human sound 
%   localization, by which we mean a model that performs optimal 
%   information processing within a Bayesian context. The model considers
%   all available spatial information contained within the acoustic
%   signals encoded by each ear. Parameters for the optimal Bayesian model
%   are determined based on psychoacoustic discrimination experiments on 
%   interaural time difference and sound intensity.
%
%
%
%   Additional input parameters: 
%   ----------------------------
%
%     'num_exp'         Number of repetitions. For each target repeat the experiment num_exp times. Default: 1 
% 
%     'sigma_itd'       Standard deviation associated to noise added to the ITD feature. Default: 0.569
% 
%     'sigma_ild'       Standard deviation associated to noise added to the ILD feature. Default: 1
% 
%     'sigma_spectral'  Standard deviation associated to noise added to the spectral features. Default: 1
% 
%     'sigma_prior'     Standard deviation of the prior distribution. If set to empty [], a uniform distribution is considered. Default:11.5
% 
%     'sigma_motor'     Standard deviation of the motor noise. Default: 10
%
%
%   If no SOFA object is provided then the model requires: 
%
%     'template'   internal representation specified by a specific feature space. Refer to barumerli2022_featureextraction for its computation.
%
%     'target'     preprocessed target struct with the binaural sounds of which the direction has to be estimated. Refer to barumerli2022_featureextraction for its computation. 
% 
%   Further, cache flags (see amt_cache) can be specified.
%
%   See also: demo_barumerli2022 barumerli2022_featureextraction
%    barumerli2022_metrics exp_barumerli2022
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/models/barumerli2022.php

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

%   References: barumerli2022
%
%   #StatusDoc: Good
%   #StatusCode: Submitted
%   #Verification: Unknown
%   #Requirements: MATLAB SOFA M-STATISTICS M-Control M-Signal
%   #Author: Roberto Barumerli, Information Engineering Dept., University of Padova, Italy, 2020



%% Check input options
definput.keyvals.sofa_obj = struct([]);
definput.keyvals.template = struct([]);
definput.keyvals.target = struct([]);

definput.keyvals.num_exp = 50;
definput.keyvals.sigma_itd =  0.569;
definput.keyvals.sigma_ild = 1;
definput.keyvals.sigma_spectral = 1.25;
definput.keyvals.sigma_prior = 11.5;
definput.keyvals.sigma_motor = 14;

definput.flags.estimator = {'MAP', 'PM'}; % Maximum a posteriori or Probability Matching

[flags, kv]  = ltfatarghelper({}, ...
                             definput, varargin);

if ~isempty(kv.sofa_obj)
    %% prepare feature space
    [template, target] = barumerli2022_featureextraction(kv.sofa_obj);
elseif ~isempty(kv.template) && ~isempty(kv.target)  
    template = kv.template;
    target = kv.target;
else
    error(['Please specify a SOFA object or the ', ...
             'template and the targets. See barumerli2022_featureextraction.'])
end

template_feat = [template.itd, template.ild, template.monaural];
target_feat = [target.itd, target.ild, target.monaural];
assert(~isempty(template.ild))

if ~isempty(template.monaural) 
    if numel(kv.sigma_spectral) == 1
        polar_len = size(template.monaural, 2);
        lateral_bis_len = size(template.ild, 2);
        sigma = blkdiag(kv.sigma_itd^2*eye(size(template.itd, 2)), ...
                        kv.sigma_ild^2*eye(lateral_bis_len), ...
                        (kv.sigma_spectral)^2*eye(polar_len));
    elseif(numel(kv.sigma_spectral) == size(template.monaural,2))
        assert(numel(kv.sigma_spectral) == size(template.monaural,2), ...
            'problem with dimensions with sigma_spectral and template_polar')
        lateral_bis_len = size(template.ild, 2);
        sigma = blkdiag(kv.sigma_itd.^2*eye(size(template.itd, 2)), ...
                        kv.sigma_ild.^2*eye(lateral_bis_len), ...
                        diag(kv.sigma_spectral));
    elseif sqrt(numel(kv.sigma_spectral)) == size(template.monaural,2) % the user specified the covariance matrix for the polar dimension
        lateral_bis_len = size(template.ild, 2);
        sigma = blkdiag(kv.sigma_itd.^2*eye(size(template.itd, 2)), ...
        kv.sigma_ild.^2*eye(lateral_bis_len), ...
        kv.sigma_spectral);
    else
        error('Something went wrong with the definition of the polar uncertainty.')
    end
else
    sigma = blkdiag(kv.sigma_itd^2*eye(size(template.itd, 2)), ...
                    (kv.sigma_ild)^2*eye(size(template.ild, 2)));
end

sigma_inv = inv(sigma);

%% prior computation 
if ~isempty(kv.sigma_prior)
    sph = template.coords.return_positions('spherical');

    prior = exp(-0.5*(sph(:,2)/kv.sigma_prior).^2);  
    prior = prior./sum(prior);
else
    prior = ones(1,length(template.coords.pos));
end

%% internal belief computation
template_num = size(template_feat, 1);
target_num = size(target_feat, 1);
doa_idx = zeros(target_num, kv.num_exp);
doa_estimations = zeros(target_num, kv.num_exp, 3);
posterior = zeros(target_num, template_num, kv.num_exp);
temp_c = template.coords.return_positions('cartesian');
post = zeros(template_num, 1);

for e = 1:kv.num_exp
    for ta = 1:target_num % number of targets
        %% AWGN NOISE
        x = mvnrnd(target_feat(ta,:),sigma);

        %% COMPUTE POSTERIOR
%         for te = 1:template_num % number of directions in the template
%             u_diff = (x-template_feat(te,:));
%             post(te, 1) = (exp(-0.5*u_diff/sigma*transpose(u_diff)))*prior(te);            
%         end

        post = mvnpdf(x, template_feat, sigma).*prior;
        % normalize
        post = (post./sum(post)); 
 
        % store posterior
        posterior(ta,:,e) = post;

        %% decision stage
        if flags.do_MAP
            [~, doa_idx(ta,e)] = max(post);
        elseif flags.do_PM % sample from categorical distribution
            cdf = [0; cumsum(post)];
            [~, ~,doa_idx(ta,e)] = histcounts(rand, cdf);
        else
            error('No decistion stage select!')
        end
        
        doa_estimations(ta,e,:) = temp_c(doa_idx(ta,e),:);
    end
end

%% SENSORIMOTOR SCATTERING
if ~isempty(kv.sigma_motor)
    for e = 1:kv.num_exp
        doa_estimations(:,e,:) = sensorimotor_scatter_von_mises(squeeze(doa_estimations(:,e,:)), ...
            kv.sigma_motor);
    end
end

% results 
doa.estimations = doa_estimations;
doa.posterior = posterior;

% return m matrix 
varargout{1} = barumerli2022_metrics(doa, target.coords, 'm');

% return cartesian estimations and other stuff
if nargout > 1
    varargout{2} = doa;
end

% return cartesian actual directions
if nargout == 3
    varargout{3} = target.coords;
end


function dirs_new = sensorimotor_scatter_von_mises(dirs, sigma_m)
% add sensorimotor noise to localization estimations
%
%%
% Input parameters:
%   m                   localization matrix (check localizationerror.m)
%   sigma               standard deviation in degrees
%   
% Output paramenters
%   m_new     localization matrix with scattered estimations
%   dirs      directions in cartesian coordinates
%
% AUTHOR: Roberto Barumerli
% Information Engineering Dept., University of Padova, Italy, 2020

    assert(size(dirs, 2) == 3 | numel(dirs) == 3)
    assert(sigma_m >= 5, 'sensorimotor concentration can lead to complex values')
    % handle if size(dirs) = [3,1]
    if numel(dirs) == 3
        if size(dirs, 1) == 3
            dirs = dirs';
        end
    end

    dirs_new = zeros(size(dirs));

    kappa = 1/deg2rad(sigma_m)^2;

    for i=1:size(dirs,1)
        dirs_new(i,:) = randvmf(kappa, dirs(i,:));
    end
    
% function y = randvmf(kappa, mu)
% % randvmf Generates a random sample of size 1 from the 
% %                von Mises-Fisher distribution
% %
% % Required Inputs
% % kappa       distribution parameter (kappa must be positive)
% %
% % Optional Inputs
% % mu          distribution parameter, (for rotating the North pole to mu)
% %
% % 2022-04-22 Roberto Barumerli, Acoustic Research Institute, Vienna
% %
% % This function has been derived from the toolbox of Gy.Terdik, B.Wainwright
% % available at https://github.com/TerdikGyorgy/3D-Simulation-Visualization
% % That toolbox is licensed under 
% % the Apache License, Version 2.0 (the "License");
% % you may not use this file except in compliance with the License.
% % You may obtain a copy of the License at
% %
% % http://www.apache.org/licenses/LICENSE-2.0
% %
% % Unless required by applicable law or agreed to in writing, software
% % distributed under the License is distributed on an "AS IS" BASIS,
% % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% % See the License for the specific language governing permissions and
% % limitations under the License.
% %
%     % Verify parameter values and set defaults
%     assert(~isempty(mu))
%     assert(kappa > 0)
%     
%     Np=[0,0,1]; % z-axis (North Pole)
%     
%     %% density
%     % Rubinstein 81, p.39, Fisher 87, p.59
%     kappaS=sign(kappa);
%     kappa=abs(kappa);
%     U = rand(1,1); %random n-by-1 vector from uniform(0,1)
%     x=log(2*U*sinh(kappa)+exp(-kappa))/kappa;
%     x=kappaS*x;
%     
%     %%
%     psi = 2*pi*rand(1,1);
%     s_x = sqrt(1-x.^2); 
%     y = [cos(psi).*s_x,sin(psi).*s_x,x];
% 
%     %% rotation (orient mean vector (mu) with the North Pole)
%     mu=mu/norm(mu); % should be unit vector
%     
%     if norm(mu-Np) > eps % !!!!!modified!!!!!!!!!!!
%         %% rotation (orient mean vector (mu) with the North Pole)
%         if mu(3)~= 1
%             Ux=cross(Np,mu);%axis of rotation
%             Ux= Ux/norm(Ux);
%             thetaX=acos(mu(3));
%             Rg= rodrigues_rotn(Ux*thetaX);
%             y=y*Rg;
%         end
%     end


%function M = rodrigues_rotn(vector)
    % Rodrigues' formula for matrix rotation
    % Reference: https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
    % check Matrix notation section in that page
    % 
    % robaru, Wien
%    theta = norm(vector);
%    M =  eye(length(vector));
%
%    if (theta < 1e-9)
%        return
%    end
%
%    v = vector ./ theta;
%    v = v(:);
%
%    % anti-asymmetric matrix 
%    % https://mathworld.wolfram.com/RodriguesRotationFormula.html
%    K = [ 0    -v(3)  v(2); ...
%          v(3)  0    -v(1);...
%         -v(2)  v(1)  0];
%
%    M = eye(length(v)) + sin(theta)*K + (1-cos(theta))*K^2; % Rodrigues' formula
%
%    M = M';

