function definput=arg_ihcenvelope(definput)
%ARG_IHCENVELOPE
%   #License: GPL
%   #Author: Peter Soendergaard (2011): Initial version
%   #Author: Alejandro Osses (2020): Extensions
%   #Author: Piotr Majdak (2021): Adapted to AMT 1.0
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/defaults/arg_ihcenvelope.php

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
 
  definput.flags.ihc = {'ihc','no_ihc'}; 
  definput.flags.ihc_type={'ihc_undefined','ihc_bernstein1999','ihc_breebaart2001','ihc_dau1996','hilbert', ...
                    'ihc_lindemann1986','ihc_meddis1990','ihc_king2019','ihc_relanoiborra2019'};

  definput.keyvals.ihc_minlvl=[];
  definput.keyvals.ihc_filter_order=1;
  definput.keyvals.ihc_scal_constant=[];
  
  definput.groups.ihc_breebaart2001={'ihc_filter_order',5};
  definput.groups.ihc_dau1996={'ihc_filter_order',1};


