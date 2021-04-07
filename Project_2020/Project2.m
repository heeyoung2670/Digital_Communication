clc; clear; close all;
%% Project2_OFDM
loaded_data = load('project2.mat');

% parameter setting
nFFTSize = loaded_data.nFFTSize; % fft size
nSubcarrier = loaded_data.nSubcarrier; % Subcarrier
modOrder = loaded_data.modOrder; % modOrder
nSampGI = loaded_data.nSampGI; % SampGI
subcarrierIndex = loaded_data.subcarrierIndex; % subcarrierIndex
N_OFDM_symbols = loaded_data.N_OFDM_symbols; % OFDM_symbols
N_ASCII_Bits = loaded_data.N_ASCII_Bits; % N_ASCII_Bits
y = loaded_data.y; % 수신 신호

rx_ofdm = reshape(y,[nFFTSize+nSampGI,N_OFDM_symbols]);
rx_bi = zeros(2,nSubcarrier);
rx = zeros(nSubcarrier*2,N_OFDM_symbols);
for i_ = 1:N_OFDM_symbols
    rx_ofdm_i = rx_ofdm(:,i_);
    
    % Guard Interval(CP) Remove
    rx_sig = rx_ofdm_i(nSampGI+1:end);

    % S/P
    rx_sig = rx_sig.';

    % FFT
    rx_fft = fft(rx_sig,nFFTSize)/sqrt(nFFTSize);
   
    % Data Demapping
    rx_demap = rx_fft(subcarrierIndex);
    
    % Parallel to Serial
    rx_demap = rx_demap.';

    % QPSK demodulation
    for j_ = 1:nSubcarrier
        symbol_after_decoding = 2*(real(rx_demap(j_))>0)-1 + 1j*(2*(imag(rx_demap(j_))>0)-1);
        rx_bi(:,j_) = [real(symbol_after_decoding)>0, imag(symbol_after_decoding)>0];
    end
    rx(:,i_) = rx_bi(:);
end
Data_bitstream_re = rx(:);

% Bitstream -> Textfile
Data_bits_reshape = reshape(Data_bitstream_re, [length(Data_bitstream_re)/N_ASCII_Bits,N_ASCII_Bits]);

Data_ASCII_re_ = bi2de(Data_bits_reshape);

Data_re = char(Data_ASCII_re_')