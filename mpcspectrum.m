% MPCSPECTRUM() - Calcula espectro de frequências da coerência e diferença 
%       de fase média pelo método Welch
% 
%   Usage:
%       [MPC,MPdiff,mpctrial,mpdiff,f] = mpcspectrum(dado1,dado2,window,noverlap,nfft,Fs);
%
%   Inputs:
%       dado        = dado(samples,trials)
%       window      = vetor para janelamento (samples,1)    [default: hamming(8 segmentos)]
%       noverlap    = proporção (<1) ou número de samples   [default: 0.5]
%       nfft        = número de pontos da fft               [default: 2^nextpow2(tamanho janela)]
%       Fs          = frequência de amostragem (Hz)         [default: 1]
%
%   Outputs:
%       MPC         = espectro da coerência de fase média
%       MPdiff      = espectro da diferença de fase média 
%       mpctrial    = espectro da coerência de fase média por trial
%       mpdiff      = espectro da diferença de fase média por trial
%       f           = vetor frequência (Hz)

% Autor: Danilo Benette Marques, 2018

function [MPC,MPdiff,mpctrial,mpdiff,f] = mpcspectrum(dado1,dado2,window,noverlap,nfft,Fs);

if size(dado1) ~= size(dado2)
    error('dado1 e dado2 devem ter o mesmo tamanho')
end

%Número de argumentos
if nargin<3 
    seg_length = round(size(dado1,1)/8);
    window = hamming(seg_length);
    noverlap = .5;
    nfft = 2^nextpow2(seg_length);
    Fs = 1;
elseif nargin<4 
    seg_length = length(window);
    noverlap = .5;
    nfft = 2^nextpow2(seg_length);
    Fs = 1;
elseif nargin<5 & nargin>=4
    seg_length = length(window);
    nfft = 2^nextpow2(seg_length);
    Fs = 1;
elseif nargin<6 & nargin>=5
    Fs = 1;
end
%argumento vazio
if isempty(window)
    seg_length = round(size(dado1,1)/8);
    window = hamming(seg_length); 
end
if isempty(noverlap)
    noverlap = .5; 
end
if isempty(nfft)
    seg_length = length(window);
    nfft =2^nextpow2(seg_length); 
end
if isempty(Fs)
    Fs = 1; 
end

%Tamanhos
trials = size(dado1,2);
N = size(dado1,1);
seg_length = length(window);

% se noverlap como porcentagem
if noverlap<1
    noverlap = noverlap*seg_length;
end

%Número de janelas com overlap
windows = (N-seg_length)/(seg_length-noverlap)+1;

for trial = 1:trials
    for w = 1:windows
        inicio = (w-1)*(seg_length-noverlap)+1;
        fim = inicio+seg_length-1;

        dado1w(:,w) = window.*dado1(inicio:fim,trial);
        dado2w(:,w) = window.*dado2(inicio:fim,trial);

    end

        dado1w_fft = fft(dado1w,nfft,1);
        dado2w_fft = fft(dado2w,nfft,1);
        dado12w = dado1w_fft.*conj(dado2w_fft);

        mpdiff(:,trial) = mean( angle(dado12w) ,2);
        mpctrial(:,trial) = abs( mean( exp(1i*angle(dado12w)) ,2) );
end

mpctrial = mpctrial(1:end/2+1,:);
MPC = mean(mpctrial,2);

mpdiff = mpdiff(1:end/2+1,:);
MPdiff = mean(mpdiff,2);

f = linspace(0,Fs,nfft);
f = f(1:end/2+1);


end