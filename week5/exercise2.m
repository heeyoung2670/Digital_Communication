clc; clear; close all;
%% BPSK 실습

syms Eb t Tb f

f=1/Tb;
phi_t = sqrt(2/Tb)*cos(2*pi*f*t);

N_sim = 1e3;

coordi_ = zeros(2,N_sim);
N_error = zeros(1,N_sim);
for i = 1:N_sim
    b_ = rand()>0.5;
    if b_== 1
        sn_t = sqrt(Eb)*phi_t;
    else
        sn_t = -sqrt(Eb)*phi_t;
    end
    sn_t_ = subs(sn_t,Eb,1);
    No=db2pow(-10);
    noise_ = sqrt(No/2)*randn()*phi_t;
    x_t=sn_t_+noise_;
    c_n_est = vpa(int(x_t*phi_t,t,[0,Tb]));
    if c_n_est > 0
        b_est = 1;
    else
        b_est = 0;
    end
    N_error(i)=(b_est ~= b_);
    coordi_(1,i) = c_n_est;
end
ber_ = sum(N_error)/N_sim;

s1_t = sqrt(Eb)*phi_t;
s0_t = -sqrt(Eb)*phi_t;

s1_t_ = subs(s1_t,Eb,1);
c1_ = int(s1_t_*phi_t,t,[0,Tb]);
s0_t_ = subs(s0_t,Eb,1);
c0_ = int(s0_t_*phi_t,t,[0,Tb]);

figure
hold on; grid on;
q1=plot(c1_,0,'o');set(q1,'markersize',15,'markerEdgeColor','r','MarkerFaceColor','r')
q2=plot(c0_,0,'o');set(q2,'markersize',15,'markerEdgeColor','r','MarkerFaceColor','r')
p = plot(coordi_(1,:),coordi_(2,:),'*');
set(p,'color','k');
axis([-1.5,1.5,-0.1,0.1]);
set(gca,'ytick',-1:2:1);