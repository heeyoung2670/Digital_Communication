clc; clear; close all;
%% Rayleigh PDF

N = 1e5;
h = (randn(1,N)+1j*randn(1,N))/sqrt(2);

h_square = h.*conj(h);
h_amp = sqrt(h_square);

x_ =  0:0.01:5;

[M,X]=hist(h_amp,x_);

resol = X(2)-X(1);
pdf_h_amp=M/N/resol;

sigma_square = 0.5;
pdf_h_theory = x_/sigma_square.*exp(-x_.^2/(2*sigma_square));
figure
hold on; grid on;
p=plot(x_,pdf_h_amp);set(p,'linestyle','none','marker','o');
r=plot(x_,pdf_h_theory);
xlabel('|h|'),ylabel('PDF');
h_legend = legend('empirical','theoretical');