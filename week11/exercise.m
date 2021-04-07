clc; clear all; close all;
%% WiFi Signal 송수신

nFFTSize = 64; % fft size
BW = 20*10^6; % Net Bandwidth occupied (20MHz)
deltaf = BW/nFFTSize; % Sub-carrier spacing (312.5kHz)
Tu = 1/(deltaf); % OFDM symbol period (3.2*10^(-6)s)
Tg = Tu/4; % Guard Interval (0.8*10^(-6)s)
T = Tg+Tu; % Total OFDM symbol duration (4*10^(-6)s)
fs = nFFTSize/Tu; % Baseband sampling frequency (20MHz)

%% 송신부 BPSK
% random하게 [0,1] 범위의 정수를 52개 생성
sample = 52;
modOrder = 2;
tx = randi([0 modOrder-1], 1, sample);

figure; hold on; box on;
stem(real(tx));
xlabel('Data Bits');ylabel('Value')
grid on;

% pskmod를 이용하여 BPSK signal 생성
tx_mod = pskmod(tx, modOrder,0); % BPSK 신호 생성

figure; hold on; box on;
stem(real(tx_mod'));
xlabel('BPSK Symbols');ylabel('Value')
grid on;

%% Serial to Parallel & Data Mapping

inputiFFT = zeros(1,nFFTSize);

% assigning bits a1 to a52 to subcarriers [-26 to -1, 1 to 26]
% for each symbol bits a1 to a52 are assigned to subcarrier
% index [-26 to -1 1 to 26]
subcarrierIndex = [-26:-1 1:26];
inputiFFT(subcarrierIndex+nFFTSize/2+1) = tx_mod(:);

% S/P
inputiFFT = inputiFFT';

figure;hold on; box on;
stem(real(inputiFFT'));
xlabel('BPSK Symbols');ylabel('Value')
grid on;

% IFFT 변환
outputiFFT = ifft(inputiFFT,nFFTSize)*sqrt(nFFTSize);

figure; hold on; box on;
stem(abs(outputiFFT'));
xlabel('OFDM Samples');ylabel('Value')
grid on;

%% Guard Interval(CP) Insert
nSampGI = nFFTSize/4;
tx_ofdm = [outputiFFT(nFFTSize-nSampGI+1:end); outputiFFT];

figure; hold on; box on;
stem(abs(tx_ofdm'));
xlabel('OFDM Samples');ylabel('Value')
grid on;

%% P/S
tx_ofdm = tx_ofdm';

figure;hold on; box on;
[Pxx] = periodogram(tx_ofdm);
step = (20*10^6)/length(Pxx);
x = [-10^7:step:10^7-step]/10^6;
plot(x,10*log10((Pxx)));
xlabel('frequency, MHz')
ylabel('power spectral density')
title('Transmit spectrum OFDM (based on 802.11a)');
grid on;

%% AWGN
rx_ofdm = tx_ofdm;

%% 수신부
%% Guard Interval(CP) Remove
rx_sig = rx_ofdm(nSampGI+1:end);

%% S/P
rx_sig = rx_sig';

%% FFT
rx_fft = fft(rx_sig,nFFTSize)/sqrt(nFFTSize);

figure; hold on; box on;
stem((rx_fft'));
xlabel('BPSK Symbols');ylabel('Value')
grid on;

%% Data Demapping
rx_demap = rx_fft(subcarrierIndex+sample/2+6+1);

%% Parallel to Serial
rx_demap = rx_demap';

figure; hold on; box on;
stem(real(tx_mod'),'o','Linewidth',2)
stem(real(rx_demap'),'--x','Linewidth',2)
xlabel('Sample');ylabel('Value')
legend('Before IFFt','After FFT')
grid on;

%% BPSK demodulation
rx=pskdemod(rx_demap,modOrder,0);

%% Check Symbol
x = [1:sample];
figure; hold on;
stem(x,tx,'o','Linewidth',2);
stem(x,rx,'--x','Linewidth',2);
grid on;
xlabel('Index');ylabel('Value')
legend('TX Bits','RX Bits')
ylim([0 1.5])