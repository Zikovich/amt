function [out,status] = amt_extern(environment, directory, module, input, outstruct)
%AMT_EXTERN Process a function from an external environment
%   Usage: 
%     output = amt_extern(environment, directory, module, input, outstruct);
%
%   Input parameters:
%
%     environment  : String selecting the environment to be used.
%                    Currently must be Python.
%     directory    : Diretory inside the environment. 
%                    For example, verhulst2018 for the model from 
%                    Verhulst et al. (2018).
%     module       : Module name to be called within the environment.
%                    For example, run_cochlear_model.py for the model
%                    from Verhulst et al. (2018).
%     input        : Structure with the input parameters. All fields 
%                    will be saved in the directory out within the
%                    directory in the file input.mat.
%     outstruct    : Structure defining the output parameters. Each field's
%                    name defines the variable name to be read from a file
%                    named by the field with the ending .np in the 
%                    out directory. Each field must contain a vector 
%                    defining the size of the variable to be read. Up to 
%                    three dimensions are handled. 
%
%   Output parameters:
%
%     out          : Structure with the output defined by outstruct. The
%                    fields of out will have names as in outstruct. Each
%                    field will have size as given by the corresponding 
%                    vector in outstruct.
%     status       : Structure with the status and results, see system.
%
%   See also: verhulst2012 verhulst2018
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/core/amt_extern.php

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

%   #License: gpl3
%   #Author: Piotr Majdak (2021): programmed for the AMT 1.0



switch environment
  case 'Python'
      % change to directory
    act_path=pwd;
    cd(fullfile(amt_basepath,'environments', directory));
      % input parameters
    if ~isempty(input),      
      save(fullfile('out','input.mat'), '-struct', 'input', '-v7');
    end
      % call
    [stat,res]=system(['python ' fullfile(amt_basepath,'environments', directory, module)]);
    status.status=stat;
    status.res=res;
    if stat ~= 0
        amt_disp();
        amt_disp(res);
        error('AMT_EXTERN: Something went wrong calling Python (see message above)');
    end    
      % collect the output
    fn=fieldnames(outstruct);
    for ii=1:length(fn)
        varname=fn{ii};
        var=outstruct.(varname);
        dim1=var(1); 
        if length(var)<2, dim2=1; else dim2=var(2); end
        if length(var)<3, dim3=1; else dim3=var(3); end
        for jj=1:dim3
          filename=fullfile(amt_basepath,'environments', directory, 'out',[varname int2str(jj) '.np']);
          f=fopen(filename,'r');
          out.(varname)(:,:,jj)=fread(f,[dim1 dim2],'double','n');
          fclose(f);
          delete(filename);
        end
    end
      % clean up     
    if ~isempty(input), delete(fullfile('out','input.mat')); end
    cd(act_path);  
  otherwise
    error(['Environment ' environment ' is not supported']);
end

