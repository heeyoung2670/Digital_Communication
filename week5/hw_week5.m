clc; clear; close all;
%% week5 과제

Eb_mW = 1;
N_sim = 1e6;

coordi_ = zeros(2,N_sim);
N_error = zeros(1,N_sim);

Eb_No = [-3:1:10];
ber_ = zeros(size(Eb_No));

for j=1:length(Eb_No)
    parfor i = 1:N_sim
        b_ = rand()>0.5;
        if b_== 1
            sn_t_ = sqrt(Eb_mW);
        else
            sn_t_ = -sqrt(Eb_mW);
        end
        No=db2pow(-Eb_No(j));
        noise_ = sqrt(No/2)*randn();
        x_t=sn_t_+noise_;
        c_n_est = x_t
        if c_n_est > 0
            b_est = 1;
        else
            b_est = 0;
        end
        N_error(i)=(b_est ~= b_);
        coordi_(1,i) = c_n_est;
    end
ber_(j) = sum(N_error)/N_sim
end

Eb_No_linear = db2pow(Eb_No);
ber_t = erfc(sqrt(Eb_No_linear))/2;

figure
hold on; grid on;
xlabel('Eb/No [dB]');ylabel('BER');
q1=plot(Eb_No,ber_,'o');set(q1,'markersize',5,'markerEdgeColor','k','MarkerFaceColor','g')
q2=plot(Eb_No,ber_t);
legend('BER','BER theory');
axis([-3,10,1e-5,1]);
set(gca,'yscale','log');