clc; clear all; close all;
%% 4주차 Quantization

f0 = 24000;
T0 = 1/f0;
t = [0:T0:4.77];
load('encode_data.mat');
bit_rate=56000;

% 샘플링 신호
fs = 8000;
Ts = 1/fs;
t_s = [0:Ts:4.77];
N_s = length(t_s)-2;

% 양자화
Q_level = 2^(bit_rate/fs);
Q_step = 2/Q_level;

% 복호화
N_bit = log2(Q_level);
temp = (reshape(x_en,N_bit,N_s))';
for i1 = 1:N_s
    x_de(i1)=Q_step*bin2dec(temp(i1,:))+Q_step/2-1;
end

% 복원()
y = zeros(1,length(t));
for i1 = 1:N_s
    y= y+x_de(i1)*sinc((t-(i1-1)*Ts)/Ts);
end

% 복원된 신호를 wav 파일에 저장
audiowrite('Reconstruction_data.wav',y,f0);
sound(y,f0);