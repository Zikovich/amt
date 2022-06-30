function data = exp_dau1997(varargin)
%EXP_DAU1997 - 
%
%   Usage: data = exp_dau1997(flags)
%
%   exp_dau1997 reproduces Figs. 4 and 14 from Osses et al. (2020), where the 
%   dau1997 model was used. The figures are similar to Figs. 4.14, C.9B, 
%   and C.11B from Osses (2018).
%
%
%   The following flags can be specified;
%
%     'redo'    Recomputes data for specified figure
%
%     'plot'    Plot the output of the experiment. This is the default.
%
%     'noplot'  Don't plot, only return data.
%
%     'fig4_osses2020'    Reproduce Fig. 4 of Osses et al. (2020).
%
%     'fig14_osses2020'    Reproduce Fig. 14 of  Osses et al. (2020).
%
%   Fig. 4 - Two internal representations of a piano sound ('P1') using the  
%   PEMO model with two configurations of the adaptation loops are shown:
%   Overshoot limitation with a factor of 5, as suggested in Osses et al. (2020), and 
%   with a factor of 10 (see, Dau et al., 1997).
%   To display Fig. 4 of Osses et al. (2020) use :
%
%     out = exp_dau1997('fig4_osses2020');
%
%   Fig. 14 - The effect of the overshoot limitation with factors of 5 and 10
%   are shown for a 4-kHz pure tone of 70 dB SPL that includes 2.5-ms up/down 
%   ramps. For these plots the outer and middle ear stages are skipped. One
%   gammatone filter at 4 kHz is used, followed by the ihc stage (ihc_breebaart),
%   and the adaptation loops (adt_osses2020 for lim=5, adt_dau for lim=10).
%   To display Fig. 14 of Osses et al. (2020) use :
%
%     out = exp_dau1997('fig14_osses2020');
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/legacy/exp_dau1997.php

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

%   AUTHOR: Alejandro Osses

error('EXP_DAU1997 is deprecated. Use EXP_OSSES2021 instead.');  
