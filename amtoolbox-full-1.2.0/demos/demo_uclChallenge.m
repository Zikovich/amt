% Solving Challenge https://www.lesicalab.com/phd-studentship-available/
% As part of the application process, you must complete the following challenge.
% Your task is to build a simple model of the cochlea. The model should include three stages:
% 
% Basilar membrane (BM) – a bank of bandpass filters. The filter parameters should be chosen to match what is known about the human cochlea.
% Inner hair cells (IHCs) – half-wave rectification of BM outputs followed by low-pass filtering.
% The filter parameters should be chosen to match what is known about the human cochlea.
% Auditory nerve (AN) – Stochastic spike generation with IHC output providing the time-varying instantaneous spike probability.
% Your model should take as input a sound waveform and produce as output AN spike times.

% Set audiogram to simulate normal hearing
ag_fs = [125 250 500 1e3 2e3 4e3 8e3];
ag_dbloss = [0 0 0 0 0 0 0]; 
% Set audiogram for example high-freq hearing loss
% ag_fs = [125 250 500 1e3 2e3 4e3 8e3];
% ag_dbloss = [0 0 0 20 40 60 80]; 

%TODO  check high freq hearing loss

% what is the audiogram? 
% The frequency range for most audiogram normally go from 100Hz to 8000Hz, which is most essential for speech comprehension. 
% The "hearing ability" is expressed in dB HL (decibel hearing level), which measures "hearing loss." 
% 0dB HL represents the average hearing threshold for people with normal hearing.



species = 'human'; % Human cochlear tuning (Shera et al., 2002)
numL = 10; numM = 10; numH = 30;
[stim, Fs_stim] = amt_load('bruce2018','defineit.wav');


% amt-load ,TODO check another .wav

stimdb = 60; % SPL of speech (in dB) sound pressure level
stim = scaletodbspl(stim,stimdb);

% characteristic frequency (CF), the frequency at which the system is most responsive, or most
% sensitive, at low levels—the frequency with the lowest threshold
% the CF of a fiber is roughly the same as the resonant frequency of the part of the basilar membrane that it is attached to.
numCF = 40;
flow = 250;
fhigh = 16e3;

fc = logspace(log10(flow), log10(fhigh),numCF);

out = bruce2018(stim, Fs_stim, fc, 'ag_fs', ag_fs, 'ag_dbloss', ag_dbloss, ...
  'numL', numL,'numM', numM,'numH', numH,'nrep',1,'outputPerCF');
amt_disp();
neurogram_ft = out.neurogram_ft;
neurogram_mr = out.neurogram_mr;
neurogram_Sout = out.neurogram_Sout;
t_ft = out.t_ft;
t_mr = out.t_mr;
t_Sout = out.t_Sout;
CFs = out.fc;

ng1=figure;
set(ng1,'renderer','painters');
winlen = 256; % Window length for the spectrogram analyses
sp1 = subplot(2,1,1);
[s,f,t] = specgram([stim; eps*ones(round(t_mr(end)*Fs_stim)-length(stim),1)],winlen,Fs_stim,winlen,0.25*winlen);
imagesc(t,f/1e3,20*log10(abs(s)/sum(hanning(winlen))*sqrt(2)/20e-6));
axis xy; axis tight;
hcb = colorbar;
set(get(hcb,'ylabel'),'string','SPL')
caxis([stimdb-80 stimdb])
ylim([0 min([max(CFs/1e3) Fs_stim/2e3])])
xlabel('Time');
ylabel('Frequency (kHz)');
title('Spectrogram')
xl = xlim;
sp2=subplot(2,1,2);

plot_bruce2018(t_mr,CFs,neurogram_mr,sp2);

caxis([0 80])
title('Mean-rate Neurogram')
xlim(xl)

ng2=figure;
set(ng2,'renderer','painters');
winlen = 256; % Window length for the spectrogram analyses
sp1 = subplot(2,1,1);
[s,f,t] = specgram([stim; eps*ones(round(t_mr(end)*Fs_stim)-length(stim),1)],winlen,Fs_stim,winlen,0.25*winlen);
imagesc(t,f/1e3,20*log10(abs(s)/sum(hanning(winlen))*sqrt(2)/20e-6));
axis xy; axis tight;
hcb = colorbar;
set(get(hcb,'ylabel'),'string','SPL')
caxis([stimdb-80 stimdb])
ylim([0 min([max(CFs/1e3) Fs_stim/2e3])])
xlabel('Time');
ylabel('Frequency (kHz)');
title('Spectrogram')
xl = xlim;
sp2=subplot(2,1,2);
plot_bruce2018(t_ft,CFs,neurogram_ft,sp2);
caxis([0 20])
title('Fine-timing Neurogram')
xlim(xl)

ng3=figure;
set(ng3,'renderer','painters');
winlen = 256; % Window length for the spectrogram analyses
sp1 = subplot(2,1,1);
[s,f,t] = specgram([stim; eps*ones(round(t_mr(end)*Fs_stim)-length(stim),1)],winlen,Fs_stim,winlen,0.25*winlen);
imagesc(t,f/1e3,20*log10(abs(s)/sum(hanning(winlen))*sqrt(2)/20e-6));
axis xy; axis tight;
hcb = colorbar;
set(get(hcb,'ylabel'),'string','SPL')
caxis([stimdb-80 stimdb])
ylim([0 min([max(CFs/1e3) Fs_stim/2e3])])
xlabel('Time');
ylabel('Frequency (kHz)');
title('Spectrogram')
xl = xlim;
sp2=subplot(2,1,2);
plot_bruce2018(t_Sout,CFs,neurogram_Sout*diff(t_Sout(1:2)),sp2);
caxis([0 6])
title('S_{out} Neurogram')
xlim(xl)

