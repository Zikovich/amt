function y = dbspl(insig,varargin)
%DBSPL Calculates the SPL (in dB) of a signal 
%   Usage: y = dbspl(insig);
%          y = dbspl(lvl);
%          y = dbspl(insig,'ac');
%
%   DBSPL(insig) calculates the sound pressure level (SPL) in dB of insig*
%   considering the AMT default level convention, which is per default SPL of 
%   93.98 dB for an RMS of 1.
%   
%   DBSPL(lin) outputs the SPL in dB for the linear level of lin. 
%
%   DBSPL(insig,'dboffset',dboffset) computes the SPL (in dB) of insig*
%   for a level convention different than the AMT default by considering
%   an SPL offset given by dboffset such that dbspl = 20*log10(rms(insig)) + dboffset. 
%   Some commonly used offsets are:
%
%    dboffset = 0. With this offset, dbspl(insig) = 20*log10(rms(insig)). 
%     This convention was used for the development of the
%     LOPEZPOVEDA2001 and BREEBAART2001.
%
%    dboffset = -20*log10(20e-6) = 93.98. This corresponds to the 
%     convention of the SPL reference of 20 mu Pa. This addresses
%     signals representing pressure in Pascal.
%
%    dboffset = 100. This convention was used for the development of DAU1996.
%
%   The AMT default level convention can be obtained by:
%
%     dboffset = dbspl(1);
%  
%   In addition, DBSPL takes the following flags at the end of the line of
%   input parameters:
%
%     'ac'      Consider only the AC component of the signal (i.e. the mean is
%               removed).
%
%     'dim',d   Work along specified dimension. The default value of []
%               means to work along the first non-singleton one.
%
%   See also: scaletodbspl
%
%   References:
%     B. C. J. Moore. An Introduction to the Psychology of Hearing. Academic
%     Press, 5th edition, 2003.
%     
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/common/dbspl.php

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

%   #Author: Hagen Wierstorf (2009): original implementation as rmsdb
%   #Author: Peter Soendergaard (2009-2013): improvements and adaptations as dbspl
%   #Author: Piotr Majdak (2021): adaptations for the AMT 1.0

definput.keyvals.dim=[];
definput.flags.mean={'noac','ac'};
definput.keyvals.dboffset=93.98;
[flags,kv]=ltfatarghelper({'dim','dboffset'},definput,varargin);

  
% ------ Computation --------------------------

% The level of a signal in dB SPL is given by the following formula:
% level = 20*log10(p/p_0)
% To get to the standard used in the toolbox.
y = 20*log10( rms(insig,flags.mean) )+kv.dboffset;


