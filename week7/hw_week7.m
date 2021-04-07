clc; clear; close all;
%% hw_week7_One-path Rayleigh
N_bits = 1e5;

Eb_No_dB = 0:3:30;
Eb_No_lin = db2pow(Eb_No_dB);
Eb_mW = 1; %energy for bit

 % noise power

n_err = zeros(1,N_bits);
BER_ = zeros(2,length(Eb_No_dB));

for j_ = 1:length(Eb_No_dB)
    for i_ = 1:N_bits
        % BPSK symbol generation
        b = rand()>0.5; % 비트 생성
        
        s= 2*b -1; % BPSK 변조
        
        h= (randn()+1j*randn())/sqrt(2); % 채널 생성
        
        n = sqrt(No_mW(j_)/2)*(randn()+1j*randn()); % 잡음 생성
        
        y = s*h + n; % 수신 신호 생성
        
        r = conj(h)/(abs(h)^2)*y; % 채널 보상
        
        b_re = real(r>0); % BPSK 복조
        
        n_err(1,i_) = b_re~=b; % 에러 비트 카운트
    end
    ber_ = mean(n_err,2);
    BER_(1,j_) = ber_;
    BER_(2,j_) = 1/2*(1-sqrt(Eb_No_lin(j_)/(Eb_No_lin(j_)+1)))
end

%% Plotting
figure
hold on; grid on;
xlabel('Eb/No [dB]');ylabel('BER');
p1=plot(Eb_No_dB,BER_(1,:),'o');set(p1,'markersize',5,'markerEdgeColor','b','markerFaceColor','b')
p2=plot(Eb_No_dB,BER_(2,:),'color','r');
legend('BER','BER theory');
set(gca,'yscale','log')
axis([Eb_No_dB(1),Eb_No_dB(end),1e-4,1])