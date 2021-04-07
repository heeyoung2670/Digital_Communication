N=50000;
R=20;

U=rand(1,N)*(2-1)+1;

[M,X]=hist(U,R);

resol = X(2)-X(1);
pdf=M/N/resol;

cdf=cumsum(pdf*resol);

figure; hold on;
bar(X,pdf);
plot(X,cdf);