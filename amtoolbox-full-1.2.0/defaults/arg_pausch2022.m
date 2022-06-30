function definput = arg_pausch2022(definput)

definput.flags.type_stf = {'hartf_front','hartf_rear','hrtf'};
definput.flags.type_mod = {'pausch','kuhn','woodworth','woodworth_ext'};
definput.flags.plot = {'no_plot','plot'};

definput.keyvals.x5 = [];
definput.keyvals.d9 = [];
definput.keyvals.d10 = [];
definput.keyvals.Theta3 = [];
definput.keyvals.azi_min = 0;
definput.keyvals.azi_max = 180;
definput.keyvals.azi_res = 2.5;
definput.keyvals.c = 343;
definput.keyvals.bp_fc_low = 500;
definput.keyvals.bp_fc_high = 1500;

definput.keyvals.col_meas = [0.7, 0.7, 0.7];
definput.keyvals.col_mod1 = [0.4, 0.4, 0.4];
definput.keyvals.col_mod2plus = [0, 0, 0];
definput.keyvals.col_mod3 = [0, 84, 159]/255;

definput.keyvals.col_shad_meas = [0.8, 0.8, 0.8];
definput.keyvals.col_shad_mod1 = [0.7, 0.7, 0.7];
definput.keyvals.col_shad_mod2plus = [0.4, 0.4, 0.4];
definput.keyvals.col_shad_mod3 = [142, 186, 229]/255;

definput.keyvals.alpha = 0.2;



%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/defaults/arg_pausch2022.php

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

