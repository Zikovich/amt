function [dirs_rot] = mclachlan2021_rotatedirs(dirs,theta,type)
%MCLACHLAN2021_ROTATEDIRS Rotate a set of coordinates on a sphere to a new set of coordinates
%   Usage: [dirs_rot] = rotateDirs(dirs,theta,type);
%
%   Input parameters:
%       dirs       : original directions in cartesian coordinates [x,y,z;...]
%       theta      : rotation amount (in degrees)
%       type       : type of rotation, options are 'yaw','pitch','roll'
%
%   Output parameters:
%       dirs_rot   : rotated directions in cartesian coordinates [x,y,z;...]
%
%   See also: mclachlan2021, mclachlan2021_preproc
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/mclachlan2021_rotatedirs.php

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

% convert to rads, head rotation = -source rotation
theta = -theta/180*pi;

% rotate coordinates according to type of rotation
if strcmp(type,'yaw')
    dirs_rot(:,1) = cos(theta).*dirs(:,1) - sin(theta).*dirs(:,2) ;
    dirs_rot(:,2) = sin(theta).*dirs(:,1) + cos(theta).*dirs(:,2) ;
    dirs_rot(:,3) = dirs(:,3) ;
elseif strcmp(type,'pitch')
    dirs_rot(:,1) = cos(theta).*dirs(:,1) + sin(theta).*dirs(:,3) ;
    dirs_rot(:,2) = dirs(:,2);
    dirs_rot(:,3) = -sin(theta).*dirs(:,1) + cos(theta).*dirs(:,3) ;
elseif strcmp(type,'roll')
    dirs_rot(:,1) = dirs(:,1);
    dirs_rot(:,2) = cos(theta).*dirs(:,2) - sin(theta).*dirs(:,3);
    dirs_rot(:,3) = sin(theta).*dirs(:,2) + cos(theta).*dirs(:,3);

else
    error('Unrecognised rotation type');
end

