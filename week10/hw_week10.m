clc;clear all;close all;
%% hw_week10_OFDM
% initialize
Eb_No_dB=[0:1:10];
Eb_No_lin=db2pow(Eb_No_dB);

sample =1e6;
modOrder = 2;

BER_ = zeros(2,length(Eb_No_dB));

% Generate tx
tx = randi([0 modOrder-1],1,sample);

tx_mod = pskmod(tx, modOrder, 0);

% Serial to Parallel
tx_mod = tx_mod';

% IFFT
tx_ifft = ifft(tx_mod)*sqrt(sample);

% Parallel to Serial
tx_ofdm = tx_ifft';

%% Receiver
for i = 1:length(Eb_No_dB)
    
    rx_ofdm = awgn(tx_ofdm',Eb_No_dB(i));

    % FFT
    rx_fft = fft(rx_ofdm)/sqrt(sample);
    
    % Parallel to Serial
    rx_fft = rx_fft';

    % BPSK demodulation
    rx = pskdemod(rx_fft,modOrder,0);
    n_err = sum(tx~=rx);

    ber_ = n_err/sample;
    BER_(1,i) = ber_;
    BER_(2,i) = 1/2*erfc(sqrt(Eb_No_lin(i)));
end

%% Plotting
figure
hold on; grid on;
xlabel('Eb/No [dB]');ylabel('BER');
p1=plot(Eb_No_dB,BER_(1,:),'o');set(p1,'markersize',5,'markerEdgeColor','b','markerFaceColor','b')
p2=plot(Eb_No_dB,BER_(2,:),'color','r');
legend('BER','BER theory');
set(gca,'yscale','log')