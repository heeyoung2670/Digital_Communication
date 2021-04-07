clc; clear; close all;
%% Rayleigh channel_BPSK
N_bits = 1e3;

Eb_No_dB_vec = 0:2:30;
BER_ = zeros(2,length(Eb_No_dB_vec));
for i_ebno = find(Eb_No_dB_vec==20)
    
    coordi_plus = nan(2,N_bits);
    coordi_minus = nan(2,N_bits);
    
    Eb_No_dB = Eb_No_dB_vec(i_ebno);
    Eb_No_lin = db2pow(Eb_No_dB);
    Eb_mW = 1; %energy for bit
    
    No_dBm = -Eb_No_dB;
    No_mW = db2pow(No_dBm); % noise power
    n_err = zeros(1,N_bits);
    
    for i_ = 1:N_bits
        % BPSK symbol generation
        b = rand()>0.5; % 비트 생성
        
        s= 2*b -1; % BPSK 변조
        
        h= (randn()+1j*randn())/sqrt(2); % 채널 생성
        
        n = sqrt(No_mW/2)*(randn()+1j*randn()); % 잡음 생성
        
        y = s*h + n; % 수신 신호 생성
        
        r = conj(h)/(abs(h)^2)*y; % 채널 보상
        
        b_re = real(r>0); % BPSK 복조
        
        n_err(1,i_) = b_re~=b; % 에러 비트 카운트
        
        bool_tmp = zeros(2,1);
        if b ==1
            coordi_plus(:,i_) = [real(r);imag(r)];
        else
            coordi_minus(:,i_) = [real(r);imag(r)];
        end
        
    end
    ber_ = mean(n_err,2);
    BER_(1,i_ebno) = ber_;
    BER_(2,i_ebno) = 1/2*(1-sqrt(Eb_No_lin/(Eb_No_lin+1)))
    
end

figure
hold on;grid on;
p1 = plot(coordi_plus(1,:),coordi_plus(2,:),'o');
p2 = plot(coordi_minus(1,:),coordi_minus(2,:),'s');
set(p1,'color','b');
set(p2,'color','k');
axis([-3,3,-3,3]);
set(gca,'ytick',-3:0.5:3,'xtick',-3:0.5:3)
title(sprintf('Eb/No = %d[dB]',Eb_No_dB));
q1 = plot(1,0,'o');set(q1,'markersize',15,'markerEdgeColor','r','MarkerFaceColor','r')
q2 = plot(-1,0,'o');set(q2,'markersize',15,'markerEdgeColor','r','MarkerFaceColor','r')