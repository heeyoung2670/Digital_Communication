clc; clear; close all;
%% QPSK 실습

Eb_mW = 1;
Eb_No_dB_vec = 5;
No_mW = db2pow(-Eb_No_dB_vec);

N_sym = 1e3;

coordi_ = zeros(2,N_sym);
n_symbol_error_saved = zeros(1,N_sym);
n_bit_error_saved = zeros(1,N_sym);

for i_sym = 1:N_sym
    % bit 생성
    bits_ = rand(2,1)>0.5;
    % bit 부호화 1->+1, 0->-1
    bits_after_encoding = bits_*2-1;
    % 심볼 에너지
    Es_mW = 2*Eb_mW;
    % QPSK 변조
    symbol_ = sqrt(Es_mW/2)*(bits_after_encoding(1)+1j*bits_after_encoding(2));
    
    % 잡음 생성
    noise_ = sqrt(No_mW/2)*(randn() + 1j*randn());
    % 잡음이 추가된 신호 생성
    y = symbol_ + noise_;
    coordi_(:,i_sym) = [real(y),imag(y)];
    % 부호 판정 후 symbol 복조
    symbol_after_decoding = 2*(real(y)>0)-1 + 1j*(2*(imag(y)>0)-1);
    % 복조된 심볼을 통해 비트 복조
    bit_re = [real(symbol_after_decoding)>0;imag(symbol_after_decoding)>0];
    
    % 에러가 발생한 심볼 count
    bool_symbol_error = (symbol_~= symbol_after_decoding);
    n_symbol_error_saved(i_sym) = bool_symbol_error;
    % 에러가 발생한 비트 count
    n_bit_error = sum(bits_ ~= bit_re);
    n_bit_error_saved(i_sym) = n_bit_error;
end
ser_ = sum(n_symbol_error_saved)/N_sym;
ber_ = sum(n_bit_error_saved)/(2*N_sym);

%% Plotting
% 잡음이 섞이지 않은 신호의 좌표
qpsk_symbol = [1 1 -1 -1; 1 -1 1 -1];
figure
hold on; grid on;
p = plot(qpsk_symbol(1,:),qpsk_symbol(2,:),'o');
set(p,'markersize',8,'markeredgecolor','r','markerfacecolor','r');
% 잡음이 섞인 신호의 좌표
q = plot(coordi_(1,:), coordi_(2,:),'*','color','b','markersize',2);
title_ = sprintf('Eb/No : %d [dB]',Eb_No_dB_vec);
xlabel('In-phase'),ylabel('Quadrature'),title(title_);