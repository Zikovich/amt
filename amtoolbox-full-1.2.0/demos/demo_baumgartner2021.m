%DEMO_BAUMGARTNER2021 Demo for externalization model from Baumgartner and Majdak (2021)
%
%   demo_baumgartner2020(flag) demonstrates how to apply the model in
%   order to estimate perceived externalization deterioration following
%   spectral distortions based on the example of using non-individualized
%   HRTFs for binaural headphone reproduction.
%
%   Figure 1: Degree of externalization predicted for subject S01 listening to HRTFs from others.
%
%   See also: baumgartner2021 exp_baumgartner2021 
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_baumgartner2021.php

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

% AUTHOR : Robert Baumgartner

%% Settings

subjNum = 1;    % choose target listener by number (1 through 23)
lat = 0;        % lateral target angle in degrees
   

%% Get listener's data

data = data_baumgartner2017looming('hrtf');   % load frontal horizontal-plane HRTFs of listener pool
Nsubj = length(data);


%% Run model to get externalization scores for every HRTF

template = data(subjNum).Obj;
E = nan(Nsubj,1);
for ids = 1:Nsubj
  target = data(ids).Obj;
  E(ids) = baumgartner2021(target,template,'lat',lat);
  amt_disp([num2str(ids),' out of ',num2str(Nsubj)],'volatile')
end

%% Plot results

figure;
bar(100*E)
set(gca,'XTick',1:Nsubj,'XTickLabel',{data.id})
ylabel('Degree of externalization (%)')
xlabel('HRTFs from subject')

