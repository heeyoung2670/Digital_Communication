clc; clear; close all;
%% BPSK 실습

syms Eb t Tb f

f=1/Tb;
phi_t = sqrt(2/Tb)*cos(2*pi*f*t);
s1_t = sqrt(Eb)*phi_t;
s0_t = -sqrt(Eb)*phi_t;

c1_ = int(s1_t*phi_t,t,[0,Tb]);
c0_ = int(s0_t*phi_t,t,[0,Tb]);

s1_t_ = subs(s1_t,Eb,1);
c1_ = int(s1_t_*phi_t,t,[0,Tb]);
s0_t_ = subs(s0_t,Eb,1);
c0_ = int(s0_t_*phi_t,t,[0,Tb]);

N0 = db2pow(-10);
noise_=sqrt(N0/2)*randn()*phi_t;
x_t = s1_t_+noise_;

c_n_est = vpa(int(x_t*phi_t,t,[0,Tb]));
if c_n_est>0
    b_est =1;
else
    b_est =0;
end
