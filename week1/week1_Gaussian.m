N=50000;
avg=2;
var=2;

T=randn(1,N);

G=T*sqrt(var)+avg;

R=100;

[M,X]=hist(G,R);

resol = X(2)-X(1);
pdf=M/N/resol;

cdf=cumsum(pdf*resol);

figure; hold on;
bar(X,pdf);
plot(X,cdf);

r_avg=sum(G)/N
i=1:N;
r_var=sum((G(i)-r_avg).^2)/N

syms f(x)
f(x)=(1/(sqrt(r_var)*sqrt(2*pi)))*exp(-1/2*((x-r_avg)/sqrt(r_var)).^2);
plot(X,f(X));