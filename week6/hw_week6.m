clc; clear; close all;
%% QPSK_week6_HW

Eb_No = [-3:1:10];

Eb_mW = 1;
No_mW = db2pow(-Eb_No);

N_sym = 1e5;

coordi_ = zeros(2,N_sym);
n_symbol_error_saved = zeros(1,N_sym);
n_bit_error_saved = zeros(1,N_sym);

ser_ = zeros(size(Eb_No));
ber_ = zeros(size(Eb_No));

for j=1:length(Eb_No)
    for i_sym = 1:N_sym
    bits_ = rand(2,1)>0.5;
    bits_after_encoding = bits_*2-1;
    Es_mW = 2*Eb_mW;
    symbol_ = sqrt(Es_mW/2)*(bits_after_encoding(1)+1j*bits_after_encoding(2));
    
    noise_ = sqrt(No_mW(j)/2)*(randn() + 1j*randn());
    y = symbol_ + noise_;
    coordi_(:,i_sym) = [real(y),imag(y)];
    symbol_after_decoding = 2*(real(y)>0)-1 + 1j*(2*(imag(y)>0)-1);
    bit_re = [real(symbol_after_decoding)>0;imag(symbol_after_decoding)>0];
    
    bool_symbol_error = (symbol_~= symbol_after_decoding);
    n_symbol_error_saved(i_sym) = bool_symbol_error;
    
    n_bit_error = sum(bits_ ~= bit_re);
    n_bit_error_saved(i_sym) = n_bit_error;
    end
ser_(j) = sum(n_symbol_error_saved)/N_sym
ber_(j) = sum(n_bit_error_saved)/(2*N_sym)
end

ber_t = berawgn(Eb_No,'psk',4,'nondiff');
ser_t = 1 - (1-ber_t).^2;

%% Plotting
figure
hold on; grid on;
xlabel('Eb/No [dB]');ylabel('SER/BER');
q1=plot(Eb_No,ser_,'o');set(q1,'markersize',5,'markerEdgeColor','r','MarkerFaceColor','r')
q2=plot(Eb_No,ser_t,'color','r');
p1=plot(Eb_No,ber_,'o');set(p1,'markersize',5,'markerEdgeColor','b','MarkerFaceColor','b')
p2=plot(Eb_No,ber_t,'color','b');
legend('SER','SER theory','BER','BER theory');
axis([-3,10,1e-5,1]);
set(gca,'yscale','log');