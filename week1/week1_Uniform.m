N=10000;
R=10;

U=rand(1,N)*(6-4)+4;

[M,X]=hist(U,R);

resol = X(2)-X(1);
pdf=M/N/resol;

cdf=cumsum(pdf*resol);

figure; hold on;
bar(X,pdf);
plot(X,cdf);

avg = sum(U)/N