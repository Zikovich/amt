function utf=urlencode(str)
% This function emulates the MATLAB function urlencode by encoding 
% the string STR to UTF-8. All special characters are encoded to 
% %HH (ASCII in hex), except: . _  and -. Further,   is encoded to +.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/oct/urlencode.php

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

% 12.07.2017, Piotr Majdak
  utf = '';
  
if isoctave
  for ii = 1:length(str),
    if isalnum(str(ii)) || str(ii)=='.' || str(ii)=='_' || str(ii)=='*' || str(ii)=='-' 
      utf(end+1) = str(ii);
    elseif str(ii)==' '
      utf(end+1) = '+';
    else
      utf=[utf,'%',dec2hex(str(ii)+0)];
    end 	
  end  
else
  for ii = 1:length(str),
    if isletter(str(ii)) || str(ii)=='.' || str(ii)=='_' || str(ii)=='*' || str(ii)=='-' 
      utf(end+1) = str(ii);
    elseif str(ii)==' '
      utf(end+1) = '+';
    elseif str2num(str(ii)) < 10
      utf(end+1) = str(ii);  
    else
      utf=[utf,'%',dec2hex(str(ii)+0)];
    end 	
  end  
end

