function [psth,neurogram_ft] = carney2015_generateneurogram(stim,Fs_stim,species,ag_fs,ag_dbloss,CF_num,dur,iCF,fiber_num,CF_range,fiberType)
%CARNEY2015_GENERATENEUROGRAM generates a neurogram from HL parameters
%
%   Usage:
%      [psth,neurogram_ft] = carney2015_generateneurogram(stim,Fs_stim,species,ag_fs,ag_dbloss,CF_num,dur,iCF,fiber_num,CF_range,fiberType)
%
%   Input parameters:
%     stim         : stimulus
%     Fs_stim      : sampling frequency
%     species      : can be either human ('2') or cat ('1')
%     ag_fs        : Frequencies at which the audiogram should be evaluated
%     ag_dbloss    : Hearing loss [dB] at the frequencies 'ag_fs'
%     CF_num       : Corresponds to the number of fibers between lowest and highest
%                    frequency. The fibers will be equidistantly spaced
%                    on the basilar membrane.
%     dur          : stimulus duration
%     iCF          : frequency index of the fibres of interest
%     fiber_num    : number of fibres
%     CF_range     : range over which the fibers should be spaced; [lowest f highest f]
%     fiberType    : Type of the fiber based on spontaneous rate (SR) in spikes/s
%
%   Output parameters:
%     psth         : peri-stimulus time histogram
%     neurogram_ft : (fine-timing) neurogram
%
%
%   provides a neurogram from a set of frequencies and hearing loss [dB]
%   at those frequencies
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/carney2015_generateneurogram.php

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

%   CHANGES to original function (generate_neurogram_UREar2):
%   load => amt_load (CH, 2021)
%   generateANpopulation => bruce2018_generateanpopulation
%   vihc = model_IHC_BEZ2018(pin,CF,nrep,1/Fs_stim,simdur,cohc,cihc,species);
%   => vihc = bruce2018_innerhaircells (same C-source, but wrapped via MAT)
% 	[psth_ft,~,~,~] = model_Synapse_BEZ2018(vihc,CF,nrep,1/Fs_stim,noiseType,implnt,spont,tabs,trel);
%   => bruce2018_synapse (same C-source but wrapped via MAT)


%space the nerve fibers logarithmically====================================
% model fiber parameters
numcfs = CF_num;
%CFs   = logspace(log10(250),log10(16e3),numcfs);  % CF in Hz;
CFs = logspace(log10(CF_range(1)),log10(CF_range(2)),CF_num);
% cohcs  = ones(1,numcfs);  % normal ohc function
% cihcs  = ones(1,numcfs);  % normal ihc function

dbloss = interp1(ag_fs,ag_dbloss,CFs,'linear','extrap');

%simulate the hearing loss=================================================
% mixed loss
[cohcs,cihcs,OHC_Loss] = carney2015_fitaudiogram(CFs,dbloss,species);
% OHC loss
% [cohcs,cihcs,OHC_Loss]=fitaudiogram(CFs,dbloss,species,dbloss);
% IHC loss
% [cohcs,cihcs,OHC_Loss]=fitaudiogram(CFs,dbloss,species,zeros(size(CFs)));

% depending on the fiber type, select the number of low-spont, medium-spont,
% and high-spont fibers at each CF in a healthy AN
numsponts_healthy = [0,0,0];
if fiberType == 1
	numsponts_healthy = [fiber_num 0 0]; 
elseif fiberType == 2
	numsponts_healthy = [0 fiber_num 0];
elseif fiberType == 3
	numsponts_healthy = [0 0 fiber_num];
end

%generate an AN population for simulating the desired fiber type===========
data = amt_load('bruce2018', 'ANpopulation.mat');
sponts = data.sponts;
tabss = data.tabss;
trels = data.trels;

if (size(sponts.LS,2)<numsponts_healthy(1))||(size(sponts.MS,2)<numsponts_healthy(2))||(size(sponts.HS,2)<numsponts_healthy(3))||(size(sponts.HS,1)<numcfs||~exist('tabss','var'))
    amt_disp('Saved population of AN fibers in ANpopulation.mat is too small - generating a new population');
    [sponts,tabss,trels] = bruce2018_generateanpopulation(numcfs,numsponts_healthy);
end

implnt = 0;    % "0" for approximate or "1" for actual implementation of the power-law functions in the Synapse
noiseType = 1;  % 0 for fixed fGn (1 for variable fGn)


% PSTH parameters==========================================================
psthbinwidth_mr = 100e-6; % mean-rate binwidth in seconds;
windur_ft=32;
smw_ft = hamming(windur_ft);
windur_mr=128;
smw_mr = hamming(windur_mr);

pin = stim(:).';

% clear stim100k
simdur = ceil(dur*1.2/psthbinwidth_mr)*psthbinwidth_mr;

CFlp = iCF;

CF = CFs(CFlp);
cohc = cohcs(CFlp);
cihc = cihcs(CFlp);

numsponts = round([1 1 1].*numsponts_healthy); % Healthy AN
% numsponts = round([0.5 0.5 0.5].*numsponts_healthy); % 50% fiber loss of all types
% numsponts = round([0 1 1].*numsponts_healthy); % Loss of all LS fibers
% numsponts = round([cihc 1 cihc].*numsponts_healthy); % loss of LS and HS fibers proportional to IHC impairment

sponts_concat = [sponts.LS(CFlp,1:numsponts(1)) sponts.MS(CFlp,1:numsponts(2)) sponts.HS(CFlp,1:numsponts(3))];
tabss_concat = [tabss.LS(CFlp,1:numsponts(1)) tabss.MS(CFlp,1:numsponts(2)) tabss.HS(CFlp,1:numsponts(3))];
trels_concat = [trels.LS(CFlp,1:numsponts(1)) trels.MS(CFlp,1:numsponts(2)) trels.HS(CFlp,1:numsponts(3))];
nrep = 1;

% calculate the ihc potential according to bruce2018 (and zilany2014)======
% and run the phenomenological synapse model proposed in bruce2018=========
vihc = bruce2018_innerhaircells(pin,CF,nrep,1/Fs_stim,simdur,cohc,cihc,species);

for  spontlp = 1:sum(numsponts)
	
	if exist ('OCTAVE_VERSION', 'builtin') ~= 0
		fflush(stdout);
	end
	
	spont = sponts_concat(spontlp);
	tabs = tabss_concat(spontlp);
	trel = trels_concat(spontlp);
	[psth_ft,~,~,~] = bruce2018_synapse(vihc,CF,nrep,1/Fs_stim,noiseType,implnt,spont,tabs,trel);
	
	if spontlp == 1
		neurogram_ft = filter(smw_ft,1,psth_ft);
		psth = psth_ft;
	else
		psth = psth + psth_ft;
		neurogram_ft = neurogram_ft+filter(smw_ft,1,psth_ft);
	end
	
end % end of for Spontlp

neurogram_ft = neurogram_ft(1:windur_ft/2:end); % 50% overlap in Hamming window
end

