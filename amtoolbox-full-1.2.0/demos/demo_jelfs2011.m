%DEMO_JELFS2011  Binaural speech intelligibility advantage
%
%   DEMO_JELFS2011 will plot the output of the
%   jelfs2011 binaural speech intelligibility advantage model for a
%   target azimuth angle of 0 deg. The masker position will move over a
%   full circle in the horizontal plane, and the output is visualized on
%   a polar plot. The KEMAR HRTF dataset is used.
%
%
%   See also: jelfs2011, culling2004
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_jelfs2011.php

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

target_azim=0;
database='kemar';

step = 5;
n_op = 360/step+1;
benefit = zeros(n_op,3);
weighted_SNR=zeros(n_op,3);
weighted_bmld=zeros(n_op,3);
angles = (0:step:360)'*pi/180;
for ii = 1:n_op
  [benefit(ii,:),weighted_SNR(ii,:), weighted_bmld(ii,:)] = ...
      jelfs2011({target_azim, database}, {(ii-1)*step, database});
end
figure; polar([angles angles angles], benefit); title('Benefit');
figure; polar([angles angles angles], weighted_SNR); title('Weighted SNR');
figure; polar([angles angles angles], weighted_bmld); title('Weighted BMLD');

