N=50000;
avg=0;
stdev=sqrt(2);

T=randn(1,N);

G=T*stdev+avg;

R=100;

[M,X]=hist(G,R);

resol = X(2)-X(1);
pdf=M/N/resol;

cdf=cumsum(pdf*resol);

figure; hold on;
bar(X,pdf);
plot(X,cdf);