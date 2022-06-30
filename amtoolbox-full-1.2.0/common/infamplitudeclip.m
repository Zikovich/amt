function xout = infamplitudeclip(xin,options)
%INFAMPLITUDECLIP  Perform infinite amplitude clipping on signal
%   Usage:  xout = infamplitudeclip(xin);
%          xout = infamplitudeclip(xin,'norm');
%
%   INFAMPLITUDECLIP(xin) performs infinite amplitude clipping on the
%   input signal. This is a signal modification that preserves the
%   zero-crossings of the signal, but sets the amplitude to either +1 or
%   -1 depending on the sign of the signal. This type of modification was
%   used in "Licklider and Pollack, 1948".
%
%   INFAMPLITUDECLIP(xin,'norm') or INFAMPLITUDECLIP(xin,'rms') will do
%   the same, but scale the signal so as to preserve the l^2 of the
%   signal (its RMS value).
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/common/infamplitudeclip.php

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

%   REFERENCES:
%   J. Licklider and I. Pollack. Effects of differentiation, integration,
%   and infinite peak clipping upon the intelligibility of speech. The
%   Journal of the Acoustical Society of America, 20:42-52, 1948.

% Copyright (C) 2009 CAHR.
% This file is part of CASP version 0.01
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
  
  
%   AUTHOR : Peter Soendergaard.
%   TESTING: OK
%   REFERENCE: OK
%   Last changed on $Date: 2009-01-14 17:46:50 +0100 (ons, 14 jan 2009) $
%   Last change occured in $Rev: 733 $

  
  error(nargchk(1,2,nargin));

  l2 = norm(xin);
  
  xout = sign(xin);
  
  if nargin>1
    switch(lower(options))
     case {'rms','norm'}
      xout=xout/norm(xout)*l2;
     otherwise
      error('Unknown option: %s',options);
    end;
    
  end;
  
  
  
  

